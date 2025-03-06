//
//  AuthService.swift
//  ToDoey
//
//  Created by Igor Cotrim on 06/03/25.
//

import Supabase
import Foundation

extension Notification.Name {
    static let authStateChanged = Notification.Name("authStateChanged")
}

@Observable
final class AuthService {
    // MARK: - Properties
    let auth = SupabaseClient(
        supabaseURL: URL(string: Constants.Supabase.url)!,
        supabaseKey: Constants.Supabase.apiKey
    )
    
    var session: Supabase.Session? {
        didSet {
            NotificationCenter.default.post(name: .authStateChanged, object: nil)
        }
    }
    
    static let shared = AuthService()
    
    // MARK: - Init
    private init() {
        Task {
            session = try? await auth.auth.session
        }
    }
    
    // MARK: - Functions
    func signIn(email: String, password: String) async throws {
        session = try await auth.auth.signIn(email: email, password: password)
    }
    
    func logout() async throws {
        try await auth.auth.signOut()
        session = nil
    }
}
