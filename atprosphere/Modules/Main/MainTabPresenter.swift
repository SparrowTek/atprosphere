//
//  MainTabPresenter.swift
//  atprosphere
//
//  Created by Thomas Rademaker on 8/27/23.
//

import SwiftUI
import SwiftData

struct MainTabPresenter: View {
    @Environment(AppState.self) private var state
    @State private var triggerSensoryFeedback = false
//    @Query private var profiles: [ACProfile]
//    @Query private var sessions: [ACSession]
    
    var body: some View {
        @Bindable var state = state
        
        ZStack {
            TabView(selection: $state.tab) {
                Group {
                    HomePresenter()
                        .environment(state.homeState)
                        .tag(AppState.Tab.home)
                    
                    SearchPresenter()
                        .environment(state.searchState)
                        .tag(AppState.Tab.search)
                    
                    NotificationsPresenter()
                        .environment(state.notificationsState)
                        .tag(AppState.Tab.notifications)
                    
                    ProfilePresenter()
                        .environment(state.profileState)
                        .tag(AppState.Tab.profile)
                }
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackground(Color.primaryWhite, for: .tabBar)
            }
            
            VStack(spacing: 0) {
                Spacer()
                
                HStack {
                    createTab(for: .home)
                    createTab(for: .search)
                    createTab(for: .notifications)
                    createTab(for: .profile)
                }
                .background(Color.primaryWhite)
            }
            .padding(.bottom)
            .ignoresSafeArea()
            
        }
        .onChange(of: state.tab) { triggerSensoryFeedback.toggle() }
        .sensoryFeedback(.selection, trigger: triggerSensoryFeedback)
    }
    
    @MainActor
    private func createTab(for tab: AppState.Tab) -> some View {
        Button(action: {
            withAnimation { state.tab = tab }
        }) {
            switch tab {
            case .home:
                ZStack {
                    
                    // TODO: this dot is only if unread
                    VStack {
                        Spacer()
                        Circle()
                            .fill(.accent)
                            .frame(width: 6)
                            .opacity(state.tab == tab ? 0 : 1)
                    }
                    
                    Image(systemName: "house")
                }
            case .search:
                Image(systemName: "magnifyingglass")
            case .notifications:
                Image(systemName: "bell")
            case .profile:
                ZStack {
                    Circle()
                        .frame(width: 32)
                    
                    #warning("get the profile for the logged in session DID")
                    
                        // TODO: get this working with avatarOnDisk
//                        CommonImage(image: .url(url: myProfile.avatar, sfSymbol: "person.fill"))
//                    let _ = print("### profiles: \(profiles)")
//                    let _ = print("### sessions: \(sessions)")
//                    let _ = print("### profile: \(String(describing: sessions.first?.profile?.handle))")
//                    CommonImage(image: .data(profiles.first?.avatarOnDisk, sfSymbol: "person.fill"))
//                        .frame(width: 30, height: 30)
//                        .scaledToFit()
//                        .clipShape(Circle())
                    
                    CommonImage(image: .url(url: "https://pbs.twimg.com/profile_images/1537799382677995521/BQSmUtMK_400x400.jpg", sfSymbol: "person.fill"))
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                }
            }
        }
        .font(.title2)
        .symbolVariant(state.tab == tab ? .fill : .none)
        .foregroundStyle(state.tab == tab ? .accent : .primaryBlack)
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .padding(.bottom)
        .animation(.default, value: state.tab)
    }
}

#Preview {
    MainTabPresenter()
        .environment(AppState())
}
