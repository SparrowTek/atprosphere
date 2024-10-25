//
//  ACPreferences.swift
//
//
//  Created by Thomas Rademaker on 9/15/23.
//

import SwiftData
//
//public enum ACPreferencesSchemaV1: VersionedSchema {
//    public static var versionIdentifier = Schema.Version(1, 0, 0)
//    
//    public static var models: [any PersistentModel.Type] {
//        [ACPreferences.self]
//    }
//
//@Model
//public class ACPreferences {
//    @Attribute(.unique) public var did: String
//    public var type: String
//    @Relationship(deleteRule: .cascade, inverse: \ACFeed.preferences) public var saved: [ACFeed] = []
//    @Relationship(deleteRule: .cascade, inverse: \ACFeed.preferences) public var pinned: [ACFeed] = []
//    public var session: ACSession?
//    
//    init(did: String, type: String) {
//        self.did = did
//        self.type = type
//    }
//}
//}
