//
//  HomePresenter.swift
//  atprosphere
//
//  Created by Thomas Rademaker on 8/27/23.
//

import SwiftUI
import SwiftData

struct HomePresenter: View {
    @Environment(HomeState.self) private var state
    
    var body: some View {
        @Bindable var state = state
        
        NavigationStack(path: $state.path) {
            HomeView()
                .sheet(item: $state.sheet) {
                    switch $0 {
                    case .settings:
                        SettingsPresenter()
                    }
                }
                .navigationDestination(for: HomeState.Path.self) {
                    switch $0 {
                    case .profile:
                        Text("PROFILE")
                    case .thread:
                        Text("THREAD")
                    }
                }
                .fullScreenCover(item: $state.images) {
                    switch $0 {
                    case .image(let image):
                        Text("IMAGE")
                    case .string(let url):
                        CommonImage(image: .url(url: url, sfSymbol: "photo"))
                            .contentShape(Rectangle())
                            .onTapGesture { state.images = nil }
                    }
                }
        }
    }
}

struct HomeView: View {
    @Environment(HomeState.self) private var state

    var body: some View {
        TimelineListView()
            .navBar()
            .fullScreenColorView()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: openSettings) {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    HomeFeedFilter()
                }
            }
    }
    
    private func openSettings() {
        print("### open settings")
        state.sheet = .settings
    }
}

fileprivate struct HomeFeedFilter: View {
    @Environment(HomeState.self) private var state
//    @Query private var sessions: [ACSession]
//    @State private var feed: ACFeed?
//    @AppStorage(Constants.UserDefaults.currentSessionDid) private var currentSessionDid: String?
    
    var body: some View {
        
        Menu {
//            Picker(selection: $feed, label: Text("Feed filter options")) {
//                ForEach((try? sessions.filter(#Predicate { $0.did == currentSessionDid ?? "" }).first?.preferences?.pinned) ?? []) {
//                    cellForFeed($0)
//                }
//            }
//            
//            Menu("Saved Feeds") {
//                Picker(selection: $feed, label: Text("Saved Feeds filter options")) {
//                    ForEach((try? sessions.filter(#Predicate { $0.did == currentSessionDid ?? "" }).first?.preferences?.saved) ?? []) {
//                        cellForFeed($0)
//                    }
//                }
//            }
            
        } label: {
            HStack {
//                Text(feed?.name ?? "")
                Text("Following")
                    .font(.headline)
                Image(systemName: "chevron.down")
                    .font(.caption2)
                    .bold()
            }
            .foregroundStyle(.primaryBlack)
        }
        .onAppear(perform: setupFirstFeed)
    }
    
    private func setupFirstFeed() {
//        guard feed == nil else { return }
//        feed = feeds.first
    }
    
//    private func cellForFeed(_ feed: ACFeed) -> some View {
//        HStack {
//            Text(feed.name)
//            Spacer()
//            CommonImage(image: .url(url: feed.avatar, sfSymbol: "checkmark"))
//        }
//        .padding(.horizontal)
//        .tag(feed)
//    }
}

#if DEBUG
#Preview(traits: .sampleTimeline, .sampleSession) {
    HomePresenter()
        .environment(HomeState(parentState: .init()))
        .environment(AppState())
        .setupServices()
}
#endif
