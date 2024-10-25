//
//  AppModel.swift
//  SparroBlu
//
//  Created by Thomas Rademaker on 10/25/23.
//

import SwiftUI
import SwiftData

fileprivate struct AppModelViewModifier: ViewModifier {
    @Environment(AppState.self) private var state
    @Environment(Services.self) private var services
    @Query private var sessions: [ACSession]
    @State private var checkLoginStatusTrigger = PlainTaskTrigger()
    @AppStorage(Constants.UserDefaults.currentSessionDid) private var currentSessionDid: String?
    @AppStorage(Constants.UserDefaults.hostURL) private var hostURL: String?
    
    func body(content: Content) -> some View {
        ZStack {
            content
        }
        .onAppear(perform: triggerLoginStatusCheck)
        .onChange(of: sessions, triggerLoginStatusCheck)
        .task($checkLoginStatusTrigger) { await checkLoginStatus() }
    }
    
    private func checkLoginStatus() async {
        let did = currentSessionDid
        if let session = sessions.first(where: {$0.did == did }) {
            await services.run.setup(hostURL: hostURL, did: session.did)
            state.route = .accountSetup
            await services.run.getCurrent()
            state.route = .main
        } else {
            state.onboardingState.path = []
            state.route = .auth
        }
    }
    
    private func triggerLoginStatusCheck() {
        checkLoginStatusTrigger.trigger()
    }
}

extension View {
    func appModel() -> some View {
        modifier(AppModelViewModifier())
    }
}
