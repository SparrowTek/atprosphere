//
//  View.swift
//  atprosphere
//
//  Created by Thomas Rademaker on 11/10/23.
//

import SwiftUI

extension View {
    var isCanvas: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
