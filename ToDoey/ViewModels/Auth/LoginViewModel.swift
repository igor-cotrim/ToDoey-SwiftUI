//
//  LoginViewModel.swift
//  ToDoey
//
//  Created by Igor Cotrim on 06/03/25.
//

import Foundation
import SwiftUI

@Observable
final class LoginViewModel {
    // MARK: - Properties
    var email: String = ""
    var password: String = ""
    var isLoading: Bool = false
    var errorMessage: String?
    
    // MARK: - Functions
    func login() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter both email and password"
            return
        }
        
        isLoading = true
        
        Task {
            do {
                try await AuthService.shared.signIn(email: email, password: password)
                await MainActor.run {
                    isLoading = false
                    errorMessage = nil
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isLoading = false
                }
            }
        }
    }
}
