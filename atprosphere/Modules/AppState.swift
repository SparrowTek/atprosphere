//
//  AppState.swift
//  atprosphere
//
//  Created by Thomas Rademaker on 8/27/23.
//

import SwiftData

@Observable
class AppState {
    enum Route {
        case auth
        case main
        case splash
        case accountSetup
    }
    
    enum Tab {
        case home
        case search
        case notifications
        case profile
    }
    
    var route: Route = .splash
    var tab: Tab = .home {
        didSet { tabChanged(oldValue: oldValue, newValue: tab) }
    }

    @ObservationIgnored
    lazy var homeState = HomeState(parentState: self)
    @ObservationIgnored
    lazy var searchState = SearchState(parentState: self)
    @ObservationIgnored
    lazy var notificationsState = NotificationsState(parentState: self)
    @ObservationIgnored
    lazy var profileState = ProfileState(parentState: self)
    @ObservationIgnored
    lazy var onboardingState = OnboardingState(parentState: self)
    
//    func logout(did: String?) async throws {
//        try await services.logout()
//    }
    
    private func tabChanged(oldValue: Tab, newValue: Tab) {
        guard newValue == oldValue else { return }
        
        switch newValue {
        case .home:
            homeState.tabReSelected()
        case .search:
            searchState.tabReSelected()
        case .notifications:
            notificationsState.tabReSelected()
        case .profile:
            profileState.tabReSelected()
        }
    }
}
