import XCTest
@testable import UserList

final class UserListRepositoryTests: XCTestCase {
    // Happy path test case
    func testFetchUsersSuccess() async throws {
        // Given
        let repository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
        let quantity = 2
        
        // When
        let users = try await repository.fetchUsers(quantity: quantity)
        
        // Then
        XCTAssertEqual(users.count, quantity)
        XCTAssertEqual(users[0].name.first, "John")
        XCTAssertEqual(users[0].name.last, "Doe")
        XCTAssertEqual(users[0].dob.age, 31)
        XCTAssertEqual(users[0].picture.large, "https://example.com/large.jpg")
        
        XCTAssertEqual(users[1].name.first, "Jane")
        XCTAssertEqual(users[1].name.last, "Smith")
        XCTAssertEqual(users[1].dob.age, 26)
        XCTAssertEqual(users[1].picture.medium, "https://example.com/medium.jpg")
    }
    
    // Unhappy path test case: Invalid JSON response
    func testFetchUsersInvalidJSONResponse() async throws {
        // Given
        let invalidJSONData = "invalid JSON".data(using: .utf8)!
        let invalidJSONResponse = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!

        let mockExecuteDataRequest: (URLRequest) async throws -> (Data, URLResponse) = { _ in
            return (invalidJSONData, invalidJSONResponse)
        }
        
        let repository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
        
        // When
        do {
            _ = try await repository.fetchUsers(quantity: 2)
            XCTFail("Response should fail")
        } catch {
            // Then
            XCTAssertTrue(error is DecodingError)
        }
    }
}

class ViewModelTests: XCTestCase {
    var viewModel: ViewModel!

    override func setUp() {
        super.setUp()
        viewModel = ViewModel(executeDataRequest: mockExecuteDataRequest) // Assurez-vous d'injecter le repository dans le ViewModel
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testFetchUsers_Success() async {
        XCTAssertEqual(viewModel.users.count, 0)
        XCTAssertFalse(viewModel.isLoading)

        await viewModel.fetchUsers()

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.users.count, 2) // Vérifie que 2 utilisateurs ont été ajoutés
    }


    func testReloadUsers() async {
        await viewModel.fetchUsers()
        XCTAssertEqual(viewModel.users.count, 2)
        await viewModel.fetchUsers()
        XCTAssertEqual(viewModel.users.count, 4)

        await viewModel.reloadUsers()
        XCTAssertEqual(viewModel.users.count, 2) // Les utilisateurs doivent être supprimés avant le rechargement
        await viewModel.fetchUsers()
        XCTAssertEqual(viewModel.users.count, 4)
    }

    func testShouldLoadMoreData() async {
        await viewModel.fetchUsers()
        let lastUser = viewModel.users.last!
        
        // Create new viewModel with empty users
        let vm = ViewModel()
        XCTAssertFalse(vm.shouldLoadMoreData(currentItem: lastUser))

        XCTAssertTrue(viewModel.shouldLoadMoreData(currentItem: lastUser))

        let notLastUser = viewModel.users.first!
        XCTAssertFalse(viewModel.shouldLoadMoreData(currentItem: notLastUser))
    }
    
    func testFetchUsers_Failure() async {
        viewModel = ViewModel(executeDataRequest: mockExecuteDataRequestFailed)
        await viewModel.fetchUsers()
        XCTAssertEqual(viewModel.users.count, 0)
        
    }
}

private extension ViewModelTests {
    func mockExecuteDataRequest(_ request: URLRequest) async throws -> (Data, URLResponse) {
        // Create mock data with a sample JSON response
        let sampleJSON = """
            {
                "results": [
                    {
                        "name": {
                            "title": "Mr",
                            "first": "John",
                            "last": "Doe"
                        },
                        "dob": {
                            "date": "1990-01-01",
                            "age": 31
                        },
                        "picture": {
                            "large": "https://example.com/large.jpg",
                            "medium": "https://example.com/medium.jpg",
                            "thumbnail": "https://example.com/thumbnail.jpg"
                        }
                    },
                    {
                        "name": {
                            "title": "Ms",
                            "first": "Jane",
                            "last": "Smith"
                        },
                        "dob": {
                            "date": "1995-02-15",
                            "age": 26
                        },
                        "picture": {
                            "large": "https://example.com/large.jpg",
                            "medium": "https://example.com/medium.jpg",
                            "thumbnail": "https://example.com/thumbnail.jpg"
                        }
                    }
                ]
            }
        """
        
        let data = sampleJSON.data(using: .utf8)!
        let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (data, response)
    }
    
    func mockExecuteDataRequestFailed(_ request: URLRequest) async throws -> (Data, URLResponse) {
        // Create mock data with a sample JSON response
        throw URLError(.badServerResponse)
    }
}

private extension UserListRepositoryTests {
    // Define a mock for executeDataRequest that returns predefined data
    func mockExecuteDataRequest(_ request: URLRequest) async throws -> (Data, URLResponse) {
        // Create mock data with a sample JSON response
        let sampleJSON = """
            {
                "results": [
                    {
                        "name": {
                            "title": "Mr",
                            "first": "John",
                            "last": "Doe"
                        },
                        "dob": {
                            "date": "1990-01-01",
                            "age": 31
                        },
                        "picture": {
                            "large": "https://example.com/large.jpg",
                            "medium": "https://example.com/medium.jpg",
                            "thumbnail": "https://example.com/thumbnail.jpg"
                        }
                    },
                    {
                        "name": {
                            "title": "Ms",
                            "first": "Jane",
                            "last": "Smith"
                        },
                        "dob": {
                            "date": "1995-02-15",
                            "age": 26
                        },
                        "picture": {
                            "large": "https://example.com/large.jpg",
                            "medium": "https://example.com/medium.jpg",
                            "thumbnail": "https://example.com/thumbnail.jpg"
                        }
                    }
                ]
            }
        """
        
        let data = sampleJSON.data(using: .utf8)!
        let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (data, response)
    }
}
