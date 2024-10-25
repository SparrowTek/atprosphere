//
//  ScrollToTopView.swift
//  SparroBlu
//
//  Created by Thomas Rademaker on 8/27/23.
//

import SwiftUI

fileprivate struct ScrollToTopView: ViewModifier {
    @Binding var shouldScrollToTop: Bool
    var topID: Namespace.ID
    var shouldAnimate: Bool
    
    func body(content: Content) -> some View {
        ScrollViewReader { proxy in
            content
                .onChange(of: shouldScrollToTop) {
                    if shouldAnimate {
                        withAnimation { proxy.scrollTo(topID) }
                    } else {
                        proxy.scrollTo(topID)
                    }
                }
        }
    }
}

extension View {
    func scrollableToTop(scrollToTop: Binding<Bool>, topID: Namespace.ID, shouldAnimate: Bool = true) -> some View {
        modifier(ScrollToTopView(shouldScrollToTop: scrollToTop, topID: topID, shouldAnimate: shouldAnimate))
    }
}
