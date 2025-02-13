//
//  ViewModel.swift
//  UserList
//
//  Created by Thibault Giraudon on 21/01/2025.
//

import Foundation
import SwiftUI


class ViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var isGridView = false
    
    private var repository = UserListRepository()
    
    init(
        executeDataRequest: @escaping (URLRequest) async throws -> (Data, URLResponse) = URLSession.shared.data(for:)
    ) {
        self.repository = UserListRepository(executeDataRequest: executeDataRequest)
    }
    
    @MainActor
    func fetchUsers() async {
        isLoading = true
            do {
                let users = try await repository.fetchUsers(quantity: 20)
                self.users.append(contentsOf: users)
                isLoading = false
            } catch {
                print("Error fetching users: \(error.localizedDescription)")
            }
    }

    func shouldLoadMoreData(currentItem item: User) -> Bool {
        guard let lastItem = users.last else { return false }
        return !isLoading && item.id == lastItem.id
    }

    func reloadUsers() async {
        users.removeAll()
        await fetchUsers()
    }
}
