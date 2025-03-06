//
//  SupabaseService.swift
//  ToDoey
//
//  Created by Igor Cotrim on 06/03/25.
//

import Supabase
import Foundation

final class SupabaseService {
    // MARK: - Properties
    let supabase = SupabaseClient(
        supabaseURL: URL(string: Constants.Supabase.url)!,
        supabaseKey: Constants.Supabase.apiKey
    )
    
    static let shared = SupabaseService()
    
    // MARK: - Init
    private init() {}
    
    // MARK: - Functions
    func postTodoItem(_ todo: ToDoModel) async throws -> ToDoModel {
        let item: ToDoModel = try await supabase
            .from("todos")
            .insert(todo, returning: .representation)
            .single()
            .execute()
            .value
        
        return item
    }
    
    func updateTodo(_ todo: ToDoModel) async throws {
        try await supabase
            .from("todos")
            .update(todo)
            .eq("id", value: todo.id)
            .execute()
    }
    
    func fetchTodos(userId: UUID) async throws -> [ToDoModel] {
        return try await supabase
            .from("todos")
            .select()
            .in("user_id", values: [userId])
            .execute()
            .value
    }
    
    func deleteTodo(id: Int) async throws {
        try await supabase
            .from("todos")
            .delete()
            .eq("id", value: id)
            .execute()
    }
}
