//
//  ACFeed.swift
//
//
//  Created by Thomas Rademaker on 9/16/23.
//

import Foundation
import SwiftData
import AtProtocol
//
//public enum ACFeedSchemaV1: VersionedSchema {
//    public static var versionIdentifier = Schema.Version(1, 0, 0)
//
//    public static var models: [any PersistentModel.Type] {
//        [ACFeed.self]
//    }
//
@Model
public class ACFeed {
    @Attribute(.unique) public var did: String
    public var uri: String
    public var cid: String
    //        public var creator: Creator
    public var name: String
    public var feedDescription: String
    public var avatar: String?
    public var likeCount: Int
    //        public var viewer: Viewer
    public var indexedAt: Date
    public var preferences: ACPreferences?
    
    init(did: String, uri: String, cid: String/*, creator: Creator*/, name: String, feedDescription: String, avatar: String?, likeCount: Int, /*viewer: Viewer,*/ indexedAt: Date) {
        self.did = did
        self.uri = uri
        self.cid = cid
        //            self.creator = creator
        self.name = name
        self.feedDescription = feedDescription
        self.avatar = avatar
        self.likeCount = likeCount
        //            self.viewer = viewer
        self.indexedAt = indexedAt
    }
}
//}
