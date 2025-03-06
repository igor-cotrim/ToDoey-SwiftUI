//
//  TodoListViewModel.swift
//  ToDoey
//
//  Created by Igor Cotrim on 06/03/25.
//

import Foundation
import SwiftUI

@Observable
final class TodoListViewModel {
    // MARK: - Properties
    var todos = [ToDoModel]()
    var newToDoTitle: String = ""
    var isLoading: Bool = false
    var errorMessage: String?
    
    // MARK: - Functions
    func fetchTodos() {
        guard let userId = AuthService.shared.session?.user.id else { return }
        isLoading = true
        
        Task {
            do {
                let fetchedTodos = try await SupabaseService.shared.fetchTodos(userId: userId)
                await MainActor.run {
                    self.todos = fetchedTodos
                    self.isLoading = false
                    self.errorMessage = nil
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    func addTodo() {
        guard newToDoTitle.count > 2, let userId = AuthService.shared.session?.user.id else {
            errorMessage = "Todo title must be at least 3 characters"
            return
        }
        
        let todo = ToDoModel(
            createdAt: .now,
            title: newToDoTitle,
            isComplete: false,
            userId: userId
        )
        
        Task {
            do {
                let returnedItem = try await SupabaseService.shared.postTodoItem(todo)
                await MainActor.run {
                    todos.append(returnedItem)
                    newToDoTitle = ""
                    errorMessage = nil
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func toggleTodoCompletion(for todo: ToDoModel) {
        guard let index = todos.firstIndex(where: { $0.id == todo.id }) else { return }
        
        todos[index].isComplete.toggle()
        updateTodo(todos[index])
    }
    
    func updateTodo(_ todo: ToDoModel) {
        Task {
            do {
                try await SupabaseService.shared.updateTodo(todo)
                await MainActor.run {
                    errorMessage = nil
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func deleteTodo(_ todo: ToDoModel) {
        guard let id = todo.id else { return }
        
        Task {
            do {
                try await SupabaseService.shared.deleteTodo(id: id)
                await MainActor.run {
                    todos.removeAll { $0.id == id }
                    errorMessage = nil
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func logout() {
        Task {
            do {
                try await AuthService.shared.logout()
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}
