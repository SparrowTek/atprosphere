//
//  SettingsPresenter.swift
//  atprosphere
//
//  Created by Thomas Rademaker on 8/27/23.
//

import SwiftUI

struct SettingsPresenter: View {
    var body: some View {
        SettingsView()
    }
}

struct SettingsView: View {
    @Environment(AppState.self) private var state
    @Environment(Services.self) private var services
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Text("SETTINGS")
            Button("Logout", action: {
                dismiss()
                Task { // TODO: this is temporary code otherwise use a taskTrigger
                    try? await services.run.logout()
                }
            })
        }
        .navBar()
        .fullScreenColorView()
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    SettingsPresenter()
        .environment(AppState())
}
