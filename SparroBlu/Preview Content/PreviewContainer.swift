//
//  PreviewContainer.swift
//  SparroBlu
//
//  Created by Thomas Rademaker on 10/19/24.
//

import Foundation
import SwiftData
import SwiftUI
import AtProtocol

#if DEBUG
fileprivate struct SampleDataTimeline: PreviewModifier {
    
    static func makeSharedContext() throws -> ModelContainer {
        let container = try ModelContainer(for: ACTimeline.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
        if let timeline: Timeline = object(resourceName: "timeline") {
            let acTimeline = ACTimeline(feed: timeline.feed, cursor: timeline.cursor, session: nil)
            container.mainContext.insert(acTimeline)
        }
        
        try container.mainContext.save()
        return container
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}

fileprivate struct SampleDataSession: PreviewModifier {
    static func makeSharedContext() async throws -> ModelContainer {
        let container = try ModelContainer(for: ACSession.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
        return container
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}

//fileprivate struct SampleDataFeeds: PreviewModifier {
//    static func makeSharedContext() async throws -> ModelContainer {
//        let container = try ModelContainer(for: ACFeed.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
//        let feed = ACFeed(did: "1", uri: "1", cid: "1", name: "iOS", feedDescription: "wow", avatar: nil, likeCount: 23, indexedAt: .now)
//        let feed2 = ACFeed(did: "2", uri: "2", cid: "2", name: "Bitcoid", feedDescription: "$$$", avatar: nil, likeCount: 21, indexedAt: .now)
//        container.mainContext.insert(feed)
//        container.mainContext.insert(feed2)
//        try container.mainContext.save()
//        return container
//    }
//    
//    func body(content: Content, context: ModelContainer) -> some View {
//        content.modelContainer(context)
//    }
//}

extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static var sampleTimeline: Self = .modifier(SampleDataTimeline())
    @MainActor static var sampleSession: Self = .modifier(SampleDataSession())
//    @MainActor static var sampleFeeds: Self = .modifier(SampleDataFeeds())
}

fileprivate func object<c: Codable>(resourceName: String) -> c? {
    guard let file = Bundle.main.url(forResource: resourceName, withExtension: "json"),
          let data = try? Data(contentsOf: file) else { return nil }
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return try? decoder.decode(c.self, from: data)
}

#endif
