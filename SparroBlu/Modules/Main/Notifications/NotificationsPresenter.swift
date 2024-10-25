//
//  NotificationsPresenter.swift
//  SparroBlu
//
//  Created by Thomas Rademaker on 8/27/23.
//

import SwiftUI

struct NotificationsPresenter: View {
    var body: some View {
        NavigationStack {
            NotificationsView()
        }
    }
}

struct NotificationsView: View {
    var body: some View {
        UnderConstructionView()
            .navBar()
            .fullScreenColorView()
    }
}

#Preview {
    NotificationsPresenter()
}
