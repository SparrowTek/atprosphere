//
//  CommonButtonView.swift
//  SparroBlu
//
//  Created by Thomas Rademaker on 8/28/23.
//

import SwiftUI

struct CommonButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(.primaryBlack)
            .foregroundStyle(.primaryWhite)
            .cornerRadius(6)
            .font(.headline)
    }
}

extension ButtonStyle where Self == CommonButton {
    static var commonButton: Self { .init() }
}

#Preview {
    Button("Common Button", action: { })
        .buttonStyle(.commonButton)
}
