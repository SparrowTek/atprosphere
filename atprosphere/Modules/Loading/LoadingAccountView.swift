//
//  LoadingAccountView.swift
//  atprosphere
//
//  Created by Thomas Rademaker on 9/17/23.
//

import SwiftUI

struct LoadingAccountView: View {
    var body: some View {
        VStack {
            Text("Atprosphere \(Image(systemName: "at"))\(Image(systemName: "cloud.sun"))")
                .font(.largeTitle)
                .foregroundStyle(.primaryBlack)
            
            HStack {
                Text("Loading... ")
                    .font(.title3)
                    .foregroundStyle(.primaryBlack.opacity(0.85))
                    .padding(.trailing)
                
                ProgressView()
            }
        }
        .commonView()
    }
}

#Preview {
    LoadingAccountView()
}
