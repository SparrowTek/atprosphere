//
//  PreviewContainer.swift
//  atprosphere
//
//  Created by Thomas Rademaker on 10/19/24.
//

import Foundation
import SwiftData
import SwiftUI
import AtProtocol

#if DEBUG
struct SampleDataTimeline: PreviewModifier {
    
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

extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static var sampleTimeline: Self = .modifier(SampleDataTimeline())
}

fileprivate func object<c: Codable>(resourceName: String) -> c? {
    guard let file = Bundle.main.url(forResource: resourceName, withExtension: "json"),
          let data = try? Data(contentsOf: file) else { return nil }
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return try? decoder.decode(c.self, from: data)
}

#endif
