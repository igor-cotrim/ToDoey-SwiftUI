//
//  SupabaseService.swift
//  ToDoey
//
//  Created by Igor Cotrim on 06/03/25.
//

import Supabase
import Foundation

final class SupabaseService {
    let supabase = SupabaseClient(
        supabaseURL: URL(string: "https://oynikmrnlspnjckpegja.supabase.co")!,
        supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im95bmlrbXJubHNwbmpja3BlZ2phIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDEyODMwMTYsImV4cCI6MjA1Njg1OTAxNn0.R8SGPytMGUTOdUYXga8azCdD5fIbZTMITno-S13Nkd8"
    )
    static let shared = SupabaseService()
    
    private init() {}
    
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
