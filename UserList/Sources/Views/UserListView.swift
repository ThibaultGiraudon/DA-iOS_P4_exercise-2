import SwiftUI

struct UserListView: View {    
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
                                Task {
                                    await vm.fetchUsers()
                                }
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
                                        Task {
                                            await vm.fetchUsers()
                                        }
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
                        Task {
                            await vm.reloadUsers()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .imageScale(.large)
                    }
                }
            }
        }
        .onAppear {
            Task {
                await vm.fetchUsers()
            }
        }
    }
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
    }
}
