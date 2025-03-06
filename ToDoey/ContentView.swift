//
//  ContentView.swift
//  ToDoey
//
//  Created by Igor Cotrim on 06/03/25.
//

import SwiftUI

struct ToDoModel: Identifiable, Codable {
    var id: Int?
    var createdAt: Date
    var title: String
    var isComplete: Bool
    var userId: UUID
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case title
        case isComplete = "is_complete"
        case userId = "user_id"
    }
}

struct ContentView: View {
    @State var todos = [ToDoModel]()
    @State var showAddToDo: Bool = false
    @State var newToDoTitle: String = ""
    
    init() {
        let appearance = UINavigationBarAppearance()
        
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "ThirdColor") ?? UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "ThirdColor") ?? UIColor.black]
        
        UINavigationBar.appearance().standardAppearance = appearance
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ForEach(todos.indices, id: \.self) { idx in
                        Button {
                            withAnimation {
                                todos[idx].isComplete.toggle()
                                updateTodo(todos[idx])
                            }
                        } label: {
                            HStack {
                                Image(systemName: todos[idx].isComplete ? "checkmark.circle.fill" : "circle")
                                Text(todos[idx].title)
                                    .strikethrough(
                                        todos[idx].isComplete,
                                        color: .gray
                                    )
                            }
                            .foregroundStyle(.main)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(Color("SecondaryColor"))
                            )
                        }
                        .contextMenu {
                            Button {
                                deleteItem(todo: todos[idx])
                            } label: {
                                HStack {
                                    Image(systemName: "trash.fill")
                                    Text("Delete")
                                }
                            }
                        }
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .ignoresSafeArea(.all, edges: .bottom)
            .scrollIndicators(.hidden)
            .background(Color(.background))
            .navigationTitle("To Do List")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        logout()
                    } label: {
                        Text("Log out")
                            .foregroundStyle(.red)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddToDo = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(Color.third)
                            .font(.title2)
                    }
                }
            }
            .alert("Add Item", isPresented: $showAddToDo) {
                VStack {
                    TextField("Enter Item:", text: $newToDoTitle)
                    
                    HStack {
                        Button(role: .cancel) {
                            showAddToDo = false
                            newToDoTitle = ""
                        } label: {
                            Text("Cancel")
                        }
                        Button {
                            didAddItem()
                        } label: {
                            Text("Done")
                        }
                    }
                }
            }
            .onAppear {
                fetchTodos()
            }
        }
    }
    
    func didAddItem() {
        if newToDoTitle.count > 2 {
            let todo = ToDoModel(
                createdAt: .now,
                title: newToDoTitle,
                isComplete: false,
                userId: UUID(uuidString: "96bb6844-4877-43ac-a3cc-2482a5d0f0ee")!
            )
            
            Task {
                do {
                    let returnedItem = try await SupabaseService.shared.postTodoItem(todo)
                    todos.append(returnedItem)
                    newToDoTitle = ""
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func fetchTodos() {
        Task {
            do {
                guard let userId = AuthService.shared.session?.user.id else { return }
                todos = try await SupabaseService.shared.fetchTodos(userId: userId)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func updateTodo(_ todo: ToDoModel) {
        Task {
            do {
                try await SupabaseService.shared.updateTodo(todo)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteItem(todo: ToDoModel) {
        Task {
            do {
                guard let id = todo.id else { return }
                try await SupabaseService.shared.deleteTodo(id: id)
                todos.removeAll { $0.id == id }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func logout() {
        Task {
            do {
                try await AuthService.shared.logout()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    ContentView()
}
