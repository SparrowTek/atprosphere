//
//  CommonView.swift
//  atprosphere
//
//  Created by Thomas Rademaker on 8/27/23.
//

import SwiftUI

struct CommonView: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            Color.primaryWhite
                .ignoresSafeArea()
            content
        }
    }
}

extension View {
    func commonView() -> some View {
        modifier(CommonView())
    }
}

#Preview {
    Text("common view")
        .commonView()
        .foregroundStyle(.primaryBlack)
}
