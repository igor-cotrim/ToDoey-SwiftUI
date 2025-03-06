//
//  LoginView.swift
//  ToDoey
//
//  Created by Igor Cotrim on 06/03/25.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to ToDoey")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.third)
            
            TextField("Email", text: $email)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding(.horizontal)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
            
            Button {
                login()
            } label: {
                Text("Login")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.main)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .bold()
            }
            
            Spacer()
        }
        .padding(.top, 50)
        .background(Color(.background).ignoresSafeArea())
    }
    
    func login() {
        Task {
            do {
                try await AuthService.shared.signIn(email: email, password: password)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    LoginView()
}
