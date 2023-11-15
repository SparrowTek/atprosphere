//
//  ACState.swift
//
//
//  Created by Thomas Rademaker on 9/18/23.
//

import SwiftData
import AtProtocol

//public enum ACStateSchemaV1: VersionedSchema {
//    public static var versionIdentifier = Schema.Version(1, 0, 0)
//    
//    public static var models: [any PersistentModel.Type] {
//        [ACState.self]
//    }
    
    @Model
    public class ACState {
        public var currentSessionDid: String
        public var hostURL: String?
        
        public init(currentSessionDid: String, hostURL: String) {
            self.currentSessionDid = currentSessionDid
            self.hostURL = hostURL
        }
    }
//}

extension ACState {
    public static func setHostURL(_ hostURL: String?) {
        let context = ModelContext(ACModel.shared.container)
        
        guard let state = try? context.fetch(FetchDescriptor<ACState>()).first else { return }
        state.hostURL = hostURL
        try? context.save()
        AtProtocol.update(hostURL: hostURL)
    }
    
    public static var current: ACState {
        let context = ModelContext(ACModel.shared.container)
        guard let state = try? context.fetch(FetchDescriptor<ACState>()).first else { fatalError("State never initialized") }
        return state
    }
}
