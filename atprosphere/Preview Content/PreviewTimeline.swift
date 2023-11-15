//
//  PreviewTimeline.swift
//  atprosphere
//
//  Created by Thomas Rademaker on 10/27/23.
//

import Foundation
import AtProtocol

#warning("this is temporary for previews until the SwiftData situation improves and we just have a preview container object")
extension Timeline {
    static let preview: Timeline = {
        
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let timelineFile = Bundle.main.url(forResource: "timeline", withExtension: "json")!
            let data = try Data(contentsOf: timelineFile)
            let timeline = try decoder.decode(Timeline.self, from: data)
            return timeline
            
        } catch {
            fatalError("Preview Timeline error: \(error)")
        }
//        guard let timelineFile = Bundle.main.url(forResource: "timeline", withExtension: "json") else { fatalError("No Timeline.json file") }
//        guard let data = try? Data(contentsOf: timelineFile) else { fatalError("corrupt data in Timeline.json file") }
//        guard let timeline = try? decoder.decode(Timeline.self, from: data) else { fatalError("Failed to create Timeline object from data") }
//        return timeline
    }()
}
