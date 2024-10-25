//
//  OnboardingState.swift
//  SparroBlu
//
//  Created by Thomas Rademaker on 8/28/23.
//

import SwiftData
import SwiftUI

@Observable
class OnboardingState {
    enum Destination {
        case login
        case signup
    }
    
    enum Server {
        case bluesky
        case staging
        
        var title: LocalizedStringResource {
            switch self {
            case .bluesky: "Bluesky.social"
            case .staging: "Staging"
            }
        }
        
        var hostURL: String {
            switch self {
            case .bluesky: "https://bsky.social"
            case .staging: "https://staging.bsky.dev"
            }
        }
    }
    
    private unowned let parentState: AppState
    
    var path: [Destination] = []
    
    init(parentState: AppState) {
        self.parentState = parentState
    }
    
    func goToCreateAccount() {
        path = []
        path.append(.signup)
    }
    
    // TODO: delete this method
    func login() {
        parentState.route = .main
    }
}
