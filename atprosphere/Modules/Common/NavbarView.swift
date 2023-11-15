//
//  NavbarView.swift
//  atprosphere
//
//  Created by Thomas Rademaker on 8/27/23.
//

import SwiftUI

struct NavbarView: ViewModifier {
    enum Title {
        case localized(LocalizedStringResource)
        case string(String)
    }
    
    @Environment(\.dismiss) private var dismiss
    var title: Title
    var showBackButton: Bool
    
    private var titleString: String {
        switch title {
        case .localized(let title): String(localized: title)
        case .string(let title): title
        }
    }
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .navigationTitle(titleString)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.primaryWhite, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if showBackButton {
                        Button(action: { dismiss() }) {
                            Image(systemName: "arrow.left")
                        }
                    }
                }
            }
    }
}

extension View {
    func navBar(title: NavbarView.Title = .string(""), showBackButton: Bool = false) -> some View {
        modifier(NavbarView(title: title, showBackButton: showBackButton))
    }
}

#Preview {
    NavigationStack {
        Text("Test")
            .navBar(title: .string("View"), showBackButton: true)
            .commonView()
            .foregroundStyle(.primaryBlack)
    }
}
