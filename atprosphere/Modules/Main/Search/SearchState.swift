//
//  SearchState.swift
//  atprosphere
//
//  Created by Thomas Rademaker on 8/27/23.
//

import SwiftData

@Observable
class SearchState {
    private unowned let parentState: AppState
    
    var scrollToTop = false
    
    init(parentState: AppState) {
        self.parentState = parentState
    }
    
    func tabReSelected() {
        scrollToTop.toggle()
    }
}
