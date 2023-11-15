//
//  ATModel.swift
//  atprosphere
//
//  Created by Thomas Rademaker on 9/1/23.
//

import SwiftUI
import SwiftData

//public typealias ACFeed = ACFeedSchemaV1.ACFeed
//public typealias ACPreferences = ACPreferencesSchemaV1.ACPreferences
//public typealias ACProfile = ACProfileSchemaV1.ACProfile
public typealias ACSession = ACSessionSchemaV1.ACSession
//public typealias ACTimeline = ACTimelineSchemaV1.ACTimeline
public typealias ACModel = ACModelSchemaV1.ACModel

public enum ACModelSchemaV1: VersionedSchema {
    public static var versionIdentifier = Schema.Version(1, 0, 0)
    
    public static var models: [any PersistentModel.Type] {
        [ACSession.self]
    }
    
    @Model
    public class ACModel {
        public init() {}
    }
}

public extension ACModel {
    static let schema = SwiftData.Schema([
        ACModel.self,
//        ACFeed.self,
//        ACPreferences.self,
//        ACProfile.self,
        ACSession.self,
//        ACTimeline.self,
    ])
}

struct AtprosphereDataContainerViewModifier: ViewModifier {
    let container: ModelContainer
    
    init(inMemory: Bool) {
        do {
            container = try ModelContainer(for: ACModel.schema, configurations: [ModelConfiguration(isStoredInMemoryOnly: inMemory)])
        } catch {
            fatalError("Failed to create ModelContainer")
        }
    }
    
    func body(content: Content) -> some View {
        content
            .modelContainer(container)
    }
}

//struct ACModelViewModifier: ViewModifier {
//    @Environment(\.modelContext) private var modelContext
//    
//    func body(content: Content) -> some View {
//        content.onAppear {
//            DataGeneration.generateAllData(modelContext: modelContext)
//        }
//    }
//}

public extension View {
    func setupModel(inMemory: Bool = ACModelOptions.inMemoryPersistence) -> some View {
        modifier(AtprosphereDataContainerViewModifier(inMemory: inMemory))
    }
}
