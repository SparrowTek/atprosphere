//
//  atprosphereApp.swift
//  atprosphere
//
//  Created by Thomas Rademaker on 8/27/23.
//

import SwiftUI
import SwiftData

@main
struct atprosphereApp: App {
    @State private var state = AppState()
    
    var body: some Scene {
        WindowGroup {
            AppPresenter()
                .environment(state)
                .setupServices()
                .setupModel()
        }
    }
}
