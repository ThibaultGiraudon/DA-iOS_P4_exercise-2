import SwiftUI

struct UserListView: View {
//    // TODO: - Those properties should be viewModel's OutPuts
//    @State private var users: [User] = []
//    @State private var isLoading = false
//    @State private var isGridView = false
//
//    // TODO: - The property should be declared in the viewModel
//    private let repository = UserListRepository()
    
    @ObservedObject var vm = ViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if !vm.isGridView {
                    List(vm.users) { user in
                        NavigationLink(destination: UserDetailView(user: user)) {
                            HStack {
                                ImageView(user: user, size: 50)
                                
                                VStack(alignment: .leading) {
                                    Text("\(user.name.first) \(user.name.last)")
                                        .font(.headline)
                                    Text("\(user.dob.date)")
                                        .font(.subheadline)
                                }
                            }
                        }
                        .onAppear {
                            if vm.shouldLoadMoreData(currentItem: user) {
                                vm.fetchUsers()
                            }
                        }
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                            ForEach(vm.users) { user in
                                NavigationLink(destination: UserDetailView(user: user)) {
                                    VStack {
                                        ImageView(user: user, size: 150)
                                        
                                        Text("\(user.name.first) \(user.name.last)")
                                            .font(.headline)
                                            .multilineTextAlignment(.center)
                                    }
                                }
                                .onAppear {
                                    if vm.shouldLoadMoreData(currentItem: user) {
                                        vm.fetchUsers()
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Users")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Picker(selection: $vm.isGridView, label: Text("Display")) {
                        Image(systemName: "rectangle.grid.1x2.fill")
                            .tag(true)
                            .accessibilityLabel(Text("Grid view"))
                        Image(systemName: "list.bullet")
                            .tag(false)
                            .accessibilityLabel(Text("List view"))
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        vm.reloadUsers()
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .imageScale(.large)
                    }
                }
            }
        }
        .onAppear {
            vm.fetchUsers()
        }
    }

    // TODO: - Should be a viewModel's input
//    private func fetchUsers() {
//        isLoading = true
//        Task {
//            do {
//                let users = try await repository.fetchUsers(quantity: 20)
//                self.users.append(contentsOf: users)
//                isLoading = false
//            } catch {
//                print("Error fetching users: \(error.localizedDescription)")
//            }
//        }
//    }
//
//    // TODO: - Should be an OutPut
//    private func shouldLoadMoreData(currentItem item: User) -> Bool {
//        guard let lastItem = users.last else { return false }
//        return !isLoading && item.id == lastItem.id
//    }
//
//    // TODO: - Should be a viewModel's input
//    private func reloadUsers() {
//        users.removeAll()
//        fetchUsers()
//    }
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
    }
}
