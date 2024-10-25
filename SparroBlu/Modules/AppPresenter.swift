//
//  AppPresenter.swift
//  SparroBlu
//
//  Created by Thomas Rademaker on 8/27/23.
//

import SwiftUI

struct AppPresenter: View {
    @Environment(AppState.self) private var state
    
    var body: some View {
        Group {
            switch state.route {
            case .auth:
                OnboardingPresenter()
                    .environment(state.onboardingState)
            case .splash:
                SplashView()
                    .task {
                        try? await Task.sleep(nanoseconds: 500_000_000)
                        state.route = .auth
                    }
            case .main:
                MainTabPresenter()
            case .accountSetup:
                Text("LOADING")
            }
        }
        .appModel()
    }
}

#Preview {
    AppPresenter()
        .environment(AppState())
}
