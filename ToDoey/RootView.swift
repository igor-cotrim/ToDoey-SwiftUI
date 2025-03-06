//
//  RootView.swift
//  ToDoey
//
//  Created by Igor Cotrim on 06/03/25.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        if let session = AuthService.shared.session {
            ContentView()
        } else {
            LoginView()
        }
    }
}

#Preview {
    RootView()
}
