//
//  UINavigationController.swift
//  atprosphere
//
//  Created by Thomas Rademaker on 8/27/23.
//

import UIKit

// FIXME: Remove this UIKit extension once SwiftUI has the proper functionality

// When using the .navigationBarBackButtonHidden(true) view modifier (which is needed to have a custom back button)
// The swipe to go back functionality no longer works. This extension brings back the functionality

extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

