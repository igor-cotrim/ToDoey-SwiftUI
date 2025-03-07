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
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundColor")
                    .ignoresSafeArea()
                
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(Color("ThirdColor"))
                } else if viewModel.todos.isEmpty {
                    emptyStateView
                } else {
                    todoListView
                }
            }
            .navigationTitle("To Do List")
            .foregroundStyle(Color("ThirdColor"))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        viewModel.logout()
                    } label: {
                        Text("Log out")
                            .foregroundStyle(.red)
                            .fontWeight(.medium)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddToDo = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(Color("ThirdColor"))
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showAddToDo) {
                addTodoView
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
        List {
            ForEach(viewModel.todos) { todo in
                TodoItemView(
                    todo: todo,
                    onToggle: {
                        withAnimation {
                            viewModel.toggleTodoCompletion(for: todo)
                        }
                    }
                )
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        withAnimation {
                            viewModel.deleteTodo(todo)
                        }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .background(Color("BackgroundColor"))
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "checklist")
                .font(.system(size: 60))
                .foregroundStyle(Color("ThirdColor"))
            
            Text("No tasks yet")
                .font(.title2)
                .fontWeight(.medium)
            
            Text("Tap the + button to add a new task")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button {
                showAddToDo = true
            } label: {
                Text("Add Your First Task")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding()
                    .padding(.horizontal)
                    .background(Color("ThirdColor"))
                    .clipShape(Capsule())
            }
            .padding(.top)
        }
    }
    
    private var addTodoView: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("What do you want to do?", text: $viewModel.newToDoTitle)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                Button {
                    viewModel.addTodo()
                    showAddToDo = false
                } label: {
                    Text("Add Task")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.newToDoTitle.count > 2 ? Color("ThirdColor") : Color.gray)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .disabled(viewModel.newToDoTitle.count <= 2)
                
                Spacer()
            }
            .padding(.top)
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") {
                        showAddToDo = false
                        viewModel.newToDoTitle = ""
                    }
                }
            }
        }
    }
}

// MARK: - TodoItemView
struct TodoItemView: View {
    let todo: ToDoModel
    let onToggle: () -> Void
    
    var body: some View {
        Button {
            onToggle()
        } label: {
            HStack {
                Image(systemName: todo.isComplete ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(todo.isComplete ? Color("ThirdColor") : .gray)
                    .font(.system(size: 22))
                    .padding(.trailing, 5)
                
                Text(todo.title)
                    .font(.system(size: 17))
                    .strikethrough(
                        todo.isComplete,
                        color: .gray
                    )
                    .foregroundStyle(todo.isComplete ? Color.gray : Color.primary)
                
                Spacer()
                
                if todo.isComplete {
                    Text("Done")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(Color("ThirdColor"))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color("ThirdColor").opacity(0.2))
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color("SecondaryColor"))
            )
        }
    }
}

#Preview {
    TodoListView()
}
