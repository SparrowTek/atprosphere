//
//  SplashView.swift
//  SparroBlu
//
//  Created by Thomas Rademaker on 9/6/23.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack {
            Text("Sparro Blu \(Image(systemName: "at"))\(Image(systemName: "cloud.sun"))")
                .font(.largeTitle)
                .foregroundStyle(.primaryBlack)
            
            Text("An AtProtocol client")
                .font(.title3)
                .foregroundStyle(.primaryBlack.opacity(0.85))
        }
        .fullScreenColorView()
    }
}

#Preview {
    SplashView()
}
