//
//  SplashView.swift
//  atprosphere
//
//  Created by Thomas Rademaker on 9/6/23.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack {
            Text("Atprosphere \(Image(systemName: "at"))\(Image(systemName: "cloud.sun"))")
                .font(.largeTitle)
                .foregroundStyle(.primaryBlack)
            
            Text("An AtProtocol client")
                .font(.title3)
                .foregroundStyle(.primaryBlack.opacity(0.85))
        }
        .commonView()
    }
}

#Preview {
    SplashView()
}
