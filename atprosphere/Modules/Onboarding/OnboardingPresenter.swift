//
//  OnboardingPresenter.swift
//  atprosphere
//
//  Created by Thomas Rademaker on 8/28/23.
//

import SwiftUI

struct OnboardingPresenter: View {
    @Environment(OnboardingState.self) private var state
    
    var body: some View {
        @Bindable var state = state
        NavigationStack(path: $state.path) {
            OnboardingView()
                .navigationDestination(for: OnboardingState.Destination.self) {
                    switch $0 {
                    case .login:
                        LoginView()
                    case .signup:
                        SignupView()
                    }
                }
        }
    }
}

struct OnboardingView: View {
    @Environment(OnboardingState.self) private var state
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Atprosphere \(Image(systemName: "at"))\(Image(systemName: "cloud.sun"))")
                .font(.largeTitle)
                .foregroundStyle(.primaryBlack)
            
            Text("An AtProtocol client")
                .font(.title3)
                .foregroundStyle(.primaryBlack.opacity(0.85))
            
            Spacer()
            
            HStack(spacing: 16) {
                Button("login", action: login)
                Button("create account", action: signup)
            }
            .buttonStyle(.commonButton)
            .padding()
        }
        .commonView()
    }
    
    private func login() {
        state.path.append(.login)
    }
    
    private func signup() {
        state.path.append(.signup)
    }
}

#Preview {
    OnboardingPresenter()
        .environment(OnboardingState(parentState: .init()))
}
