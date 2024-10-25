//
//  ACProfile.swift
//
//
//  Created by Thomas Rademaker on 9/6/23.
//

//import Foundation
//import SwiftData
//import AtProtocol
//
//public enum ACProfileSchemaV1: VersionedSchema {
//    public static var versionIdentifier = Schema.Version(1, 0, 0)
//    
//    public static var models: [any PersistentModel.Type] {
//        [ACProfile.self]
//    }
//    
//    @Model
//    public class ACProfile {
//        @Attribute(.unique) public let did: String
//        public var handle: String
//        public var displayName: String
//        public var profileDescription: String
//        public var avatar: String
//        public var banner: String
//        public var followsCount: Int
//        public var followersCount: Int
//        public var postsCount: Int
//        public var indexedAt: Date
//        public var viewer: Viewer
//        public var labels: [String]
//        @Attribute(.externalStorage) public var avatarOnDisk: Data?
//        public var session: ACSession?
//        
//        public init(did: String, handle: String, displayName: String, profileDescription: String, avatar: String, banner: String, followsCount: Int, followersCount: Int, postsCount: Int, indexedAt: Date, viewer: Viewer, labels: [String]) {
//            self.did = did
//            self.handle = handle
//            self.displayName = displayName
//            self.profileDescription = profileDescription
//            self.avatar = avatar
//            self.banner = banner
//            self.followsCount = followsCount
//            self.followersCount = followersCount
//            self.postsCount = postsCount
//            self.indexedAt = indexedAt
//            self.viewer = viewer
//            self.labels = labels
//        }
//    }
//}
