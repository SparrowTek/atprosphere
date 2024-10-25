//
//  ProfileState.swift
//  SparroBlu
//
//  Created by Thomas Rademaker on 8/27/23.
//

import SwiftData

@Observable
class ProfileState {
    private unowned let parentState: AppState
    
    var scrollToTop = false
    
    init(parentState: AppState) {
        self.parentState = parentState
    }
    
    func tabReSelected() {
        scrollToTop.toggle()
    }
}
