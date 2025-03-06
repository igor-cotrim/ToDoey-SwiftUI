//
//  LoginView.swift
//  ToDoey
//
//  Created by Igor Cotrim on 06/03/25.
//

import SwiftUI

struct LoginView: View {
    // MARK: - Properties
    @State private var viewModel = LoginViewModel()
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to ToDoey")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.third)
            
            TextField("Email", text: $viewModel.email)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding(.horizontal)
            
            SecureField("Password", text: $viewModel.password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
            
            Button {
                viewModel.login()
            } label: {
                if viewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Login")
                        .foregroundColor(.white)
                        .bold()
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.main)
            .cornerRadius(10)
            .padding(.horizontal)
            .disabled(viewModel.isLoading)
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .font(.caption)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
        .padding(.top, 50)
        .background(Color(.background).ignoresSafeArea())
    }
}

#Preview {
    LoginView()
}
