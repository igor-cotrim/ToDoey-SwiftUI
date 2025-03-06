//
//  AuthService.swift
//  ToDoey
//
//  Created by Igor Cotrim on 06/03/25.
//

import Supabase
import Foundation

@Observable
final class AuthService {
    let auth = SupabaseClient(
        supabaseURL: URL(string: "https://oynikmrnlspnjckpegja.supabase.co")!,
        supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im95bmlrbXJubHNwbmpja3BlZ2phIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDEyODMwMTYsImV4cCI6MjA1Njg1OTAxNn0.R8SGPytMGUTOdUYXga8azCdD5fIbZTMITno-S13Nkd8"
    )
    
    var session: Supabase.Session?
    
    static let shared = AuthService()
    
    init() {
        Task {
            session = try? await auth.auth.session
        }
    }
    
    func signIn(email: String, password: String) async throws {
        session = try await auth.auth.signIn(email: email, password: password)
    }
    
    func logout() async throws {
        try await auth.auth.signOut()
        session = nil
    }
}
