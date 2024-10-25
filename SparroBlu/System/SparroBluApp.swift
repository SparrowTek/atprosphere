//
//  SparroBluApp.swift
//  SparroBlu
//
//  Created by Thomas Rademaker on 10/25/24.
//

import SwiftUI
import SwiftData

@main
struct SparroBluApp: App {
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
