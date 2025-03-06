//
//  TodoListView.swift
//  ToDoey
//
//  Created by Igor Cotrim on 06/03/25.
//

import SwiftUI

struct TodoListView: View {
    // MARK: - Properties
    @State private var viewModel = TodoListViewModel()
    @State private var showAddToDo: Bool = false
    
    // MARK: - Init
    init() {
        let appearance = UINavigationBarAppearance()
        
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "ThirdColor") ?? UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "ThirdColor") ?? UIColor.black]
        
        UINavigationBar.appearance().standardAppearance = appearance
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                } else {
                    todoListView
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.background))
            .navigationTitle("To Do List")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        viewModel.logout()
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
                    TextField("Enter Item:", text: $viewModel.newToDoTitle)
                    
                    HStack {
                        Button(role: .cancel) {
                            showAddToDo = false
                            viewModel.newToDoTitle = ""
                        } label: {
                            Text("Cancel")
                        }
                        Button {
                            viewModel.addTodo()
                            showAddToDo = false
                        } label: {
                            Text("Done")
                        }
                    }
                }
            }
            .alert("Error", isPresented: Binding<Bool>(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .onAppear {
                viewModel.fetchTodos()
            }
        }
    }
    
    // MARK: - Views
    private var todoListView: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.todos) { todo in
                    TodoItemView(
                        todo: todo,
                        onToggle: {
                            withAnimation {
                                viewModel.toggleTodoCompletion(for: todo)
                            }
                        },
                        onDelete: {
                            viewModel.deleteTodo(todo)
                        }
                    )
                }
            }
            .padding()
        }
        .scrollIndicators(.hidden)
    }
}

// MARK: - TodoItemView
struct TodoItemView: View {
    let todo: ToDoModel
    let onToggle: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        Button {
            onToggle()
        } label: {
            HStack {
                Image(systemName: todo.isComplete ? "checkmark.circle.fill" : "circle")
                Text(todo.title)
                    .strikethrough(
                        todo.isComplete,
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
                onDelete()
            } label: {
                HStack {
                    Image(systemName: "trash.fill")
                    Text("Delete")
                }
            }
        }
    }
}

#Preview {
    TodoListView()
}
