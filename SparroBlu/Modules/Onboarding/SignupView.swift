//
//  SignupView.swift
//  SparroBlu
//
//  Created by Thomas Rademaker on 8/28/23.
//

import SwiftUI

struct SignupView: View {
    var body: some View {
        Text("SIGN UP")
            .fullScreenColorView()
            .navBar(showBackButton: true)
    }
}

#Preview {
    NavigationStack {
        SignupView()
    }
}
