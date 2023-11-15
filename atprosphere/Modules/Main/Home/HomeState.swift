//
//  HomeState.swift
//  atprosphere
//
//  Created by Thomas Rademaker on 8/27/23.
//

import SwiftData
import AtProtocol

@Observable
class HomeState {
    enum Sheet: Int, Identifiable {
        case settings
        
        var id: Int { rawValue }
    }
    
    enum Path {
        case thread
        case profile
    }
    
    private unowned let parentState: AppState
    
    var scrollToTop = false
    var sheet: Sheet?
    var path: [Path] = []
    var images: TimelineImage?
    
    init(parentState: AppState) {
        self.parentState = parentState
    }
    
    func tabReSelected() {
        //        if some navigation path count > 0 {
        //        path = []
        //        else
        scrollToTop.toggle()
    }
}
