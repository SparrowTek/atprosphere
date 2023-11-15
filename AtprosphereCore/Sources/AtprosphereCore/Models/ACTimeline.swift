import SwiftData
import AtProtocol

//public enum ACTimelineSchemaV1: VersionedSchema {
//    public static var versionIdentifier = Schema.Version(1, 0, 0)
//    
//    public static var models: [any PersistentModel.Type] {
//        [ACTimeline.self]
//    }
    
    @Model
    public class ACTimeline {
        public var feed: [TimelineItem]
        public var cursor: String
        public var session: ACSession?
        
        init(feed: [TimelineItem], cursor: String, session: ACSession?) {
            self.feed = feed
            self.cursor = cursor
            self.session = session
        }
    }
//}
