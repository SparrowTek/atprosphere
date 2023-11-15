//
//  ATModel.swift
//  atprosphere
//
//  Created by Thomas Rademaker on 9/1/23.
//

import SwiftData

//public typealias ACFeed = ACFeedSchemaV1.ACFeed
//public typealias ACPreferences = ACPreferencesSchemaV1.ACPreferences
//public typealias ACProfile = ACProfileSchemaV1.ACProfile
//public typealias ACSession = ACSessionSchemaV1.ACSession
//public typealias ACState = ACStateSchemaV1.ACState
//public typealias ACTimeline = ACTimelineSchemaV1.ACTimeline

@MainActor
public class ACModel: Sendable {
    public static let shared = ACModel()
    public let container: ModelContainer = {
        do {
            return try ModelContainer(for: ACState.self, ACSession.self)
        } catch {
            fatalError("Could not create the ModelContainer")
        }
    }()
    
    private init() {}
}
