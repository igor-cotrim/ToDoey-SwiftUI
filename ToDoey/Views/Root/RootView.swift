//
//  RootView.swift
//  ToDoey
//
//  Created by Igor Cotrim on 06/03/25.
//

import SwiftUI

struct RootView: View {
    @State private var isAuthenticated: Bool = AuthService.shared.session != nil
    
    var body: some View {
        Group {
            if isAuthenticated {
                TodoListView()
            } else {
                LoginView()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .authStateChanged)) { _ in
            isAuthenticated = AuthService.shared.session != nil
        }
    }
}

#Preview {
    RootView()
}
