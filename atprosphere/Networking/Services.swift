import SwiftData
import SwiftUI
import AtProtocol
import Vault


@Observable
class Services {
    let run: ServicesModelActor
    
    init(servicesModelActor: ServicesModelActor) {
        run = servicesModelActor
    }
}

@ModelActor
actor ServicesModelActor {
    @AppStorage(Constants.UserDefaults.currentSessionDid) private var currentSessionDid: String?
    @AppStorage(Constants.UserDefaults.hostURL) private var hostURL: String?
    
    private func performAPIRequest(request: @escaping () async throws -> Void) async -> ErrorMessage? {
        do {
            try await request()
            return nil
        } catch let atError as AtError {
            guard case .message(let errorMessage) = atError else {
                return ErrorMessage(error: "", message: "Something went wrong. please try again")
            }
            
            return errorMessage
        } catch _ {
            return ErrorMessage(error: "", message: "Something went wrong. please try again")
        }
    }
    
    func update(accessToken: String, refreshToken: String) {
        AtProtocol.updateTokens(access: accessToken, refresh: refreshToken)
    }
    
    func login(identifier: String, password: String) async -> ErrorMessage? {
        await performAPIRequest { [weak self] in
            let session = try await AtProtocol.AtProtoLexicons().login(identifier: identifier, password: password)
            try await self?.updateSession(session)
        }
    }
    
    func getCurrent() async {
        guard let session = try? await AtProtocol.AtProtoLexicons().getCurrent() else { return }
        try? updateSession(session)
    }
    
    private func updateSession(_ session: Session) throws {
        try updateSession(did: session.did, handle: session.handle, email: session.email, accessJwt: session.accessJwt, refreshJwt: session.refreshJwt)
    }
    
    private func getProfile(for sessionID: PersistentIdentifier) async {
//        guard let session = modelContext.model(for: sessionID) as? ACSession,
//              let profile = try? await AtProtocol.BskyLexicons().getProfile(for: session.did) else { return }
//        let acProfile = ACProfile(did: profile.did, handle: profile.handle, displayName: profile.displayName, profileDescription: profile.description, avatar: profile.avatar, banner: profile.banner, followsCount: profile.followsCount, followersCount: profile.followersCount, postsCount: profile.postsCount, indexedAt: profile.indexedAt, viewer: profile.viewer, labels: profile.labels)
//        modelContext.insert(acProfile)
//        session.profile = acProfile
//        try? modelContext.save()
//    
//        await self.downloadMyAvatar(url: acProfile.avatar, profileID: acProfile.id)
    }
    
    func setupMyProfile() async {
//        guard let sessions = try? modelContext.fetch(FetchDescriptor<ACSession>()),
//              let session = sessions.first else { return }
//        let sessionID = session.id
//        
//        await withTaskGroup(of: Void.self) { [weak self] group in
//            guard let self else { return }
//            group.addTask { await self.getProfile(for: sessionID) }
//            group.addTask { await self.getPreferences(for: sessionID) }
//            await group.waitForAll()
//        }
    }
    
    private func downloadMyAvatar(url: String, profileID: PersistentIdentifier) async {
//        guard let url = URL(string: url),
//            let profile = modelContext.model(for: profileID) as? ACProfile else { return }
//        
//        let request = URLRequest(url: url)
//        guard let (data, response) = try? await URLSession.shared.data(for: request) else { return }
//        guard let httpResponse = response as? HTTPURLResponse else { return }
//        switch httpResponse.statusCode {
//        case 200...299:
//            profile.avatarOnDisk = data
//            try? modelContext.save()
//        default:
//            break
//        }
    }
    
    private func getPreferences(for sessionID: PersistentIdentifier) async  {
//        guard let session = modelContext.model(for: sessionID) as? ACSession,
//              let preferences = try? await AtProtocol.BskyLexicons().getPreferences(), let preferences = preferences.preferences.first else { return }
//        
//        let saved: [String] = preferences.saved
//        let pinned: [String] = preferences.pinned
//        let acPreferences = ACPreferences(type: preferences.type)
//        
//        async let savedFeeds = getFeedGenerators(for: saved)
//        async let pinnedFeeds = getFeedGenerators(for: pinned)
//        
//        acPreferences.pinned = await pinnedFeeds
//        acPreferences.saved = await savedFeeds
//        modelContext.insert(acPreferences)
//        session.preferences = acPreferences
//        try? modelContext.save()
    }
    
//    private func getFeedGenerators(for feeds: [String]) async -> [ACFeed] {
//        guard let feeds = try? await AtProtocol.BskyLexicons().getFeedGenerators(for: feeds) else { return [] }
//        return feeds.feeds.map {
//            ACFeed(did: $0.did,uri: $0.uri, cid: $0.cid, creator: $0.creator, name: $0.displayName, feedDescription: $0.description, avatar: $0.avatar, likeCount: $0.likeCount, viewer: $0.viewer, indexedAt: $0.indexedAt)
//        }
//    }
    
    func getTimeline(for sessionID: PersistentIdentifier, limit: Int) async {
//        guard let session = modelContext.model(for: sessionID) as? ACSession,
//              let timeline = try? await AtProtocol.BskyLexicons().getTimeline(limit: limit) else { return }
//        
//        let acTimeline = ACTimeline(feed: timeline.feed, cursor: timeline.cursor, session: session)
//        modelContext.insert(acTimeline)
//        try? modelContext.save()
    }
    
    func setup(hostURL: String?, did: String) {
        let accessJwt = try? Vault.getPrivateKey(keychainConfiguration: KeychainConfiguration(serviceName: Constants.serviceName, accessGroup: nil, accountName: "\(Constants.accessJWT)\(did)"))
        let refreshJwt = try? Vault.getPrivateKey(keychainConfiguration: KeychainConfiguration(serviceName: Constants.serviceName, accessGroup: nil, accountName: "\(Constants.refreshJWT)\(did)"))
        AtProtocol.setup(hostURL: hostURL ?? "", accessJWT: accessJwt, refreshJWT: refreshJwt,  delegate: self)
    }
    
    func update(hostURL: String?) {
        self.hostURL = hostURL
        AtProtocol.update(hostURL: hostURL)
    }
    
    func logout() async throws {
        guard let did = currentSessionDid else { return }
        let sessions = try modelContext.fetch(FetchDescriptor<ACSession>(predicate: #Predicate { $0.did == did }))
        guard let currentSession = sessions.first else { return }
        modelContext.delete(currentSession)
        try? modelContext.save()
        update(hostURL: nil)
        AtProtocol.updateTokens(access: nil, refresh: nil)
        try? Vault.deletePrivateKey(keychainConfiguration: KeychainConfiguration(serviceName: Constants.serviceName, accessGroup: nil, accountName: "\(Constants.accessJWT)\(did)"))
        try? Vault.deletePrivateKey(keychainConfiguration: KeychainConfiguration(serviceName: Constants.serviceName, accessGroup: nil, accountName: "\(Constants.refreshJWT)\(did)"))
    }
    
    private func updateSession(did: String, handle: String, email: String?, accessJwt: String?, refreshJwt: String?) throws {
        let acSession: ACSession
        
        if let storedSession = try modelContext.fetch(FetchDescriptor<ACSession>(predicate: #Predicate { $0.did == did })).first {
            acSession = storedSession
        } else {
            acSession = ACSession(did: did, handle: handle, email: email)
            modelContext.insert(acSession)
        }
        
        acSession.handle = handle
        acSession.email = email
        try? modelContext.save()
        currentSessionDid = did
        
        if let accessJwt, let refreshJwt {
            try Vault.savePrivateKey(accessJwt, keychainConfiguration: KeychainConfiguration(serviceName: Constants.serviceName, accessGroup: nil, accountName: "\(Constants.accessJWT)\(did)"))
            try Vault.savePrivateKey(refreshJwt, keychainConfiguration: KeychainConfiguration(serviceName: Constants.serviceName, accessGroup: nil, accountName: "\(Constants.refreshJWT)\(did)"))
            
            AtProtocol.updateTokens(access: accessJwt, refresh: refreshJwt)
        }
    }
}

extension ServicesModelActor: ATProtocolDelegate {
    public func sessionUpdated(_ session: AtProtocol.Session) async {
        try? updateSession(did: session.did, handle: session.handle, email: session.email, accessJwt: session.accessJwt, refreshJwt: session.refreshJwt)
    }
}


struct ServicesViewModifier: ViewModifier {
    @Environment(\.modelContext) private var modelContext
    
    func body(content: Content) -> some View {
        content
            .environment(Services(servicesModelActor: ServicesModelActor(modelContainer: modelContext.container)))
    }
}

extension View {
    func setupServices() -> some View {
        modifier(ServicesViewModifier())
    }
}
