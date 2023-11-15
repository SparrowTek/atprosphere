import SwiftData
import SwiftUI
import AtProtocol
import Vault

@Observable
public class Services {
    public static let shared = Services()
    private init() {}
    
    public func update(accessToken: String, refreshToken: String) {
        AtProtocol.updateTokens(access: accessToken, refresh: refreshToken)
    }
    
    public func login(identifier: String, password: String, error: Binding<ErrorMessage?>, requestInProgress: Binding<Bool>) async {
        await performAPIRequest(error: error, requestInProgress: requestInProgress) { [weak self] in
            let session = try await AtProtocol.AtProtoLexicons().login(identifier: identifier, password: password)
            try self?.updateSession(session)
        }
    }
    
    public func getCurrent() async {
        guard let session = try? await AtProtocol.AtProtoLexicons().getCurrent() else { return }
        try? updateSession(session)
    }
    
    private func updateSession(_ session: Session) throws {
        ACSession.update(did: session.did, handle: session.handle, email: session.email, accessJwt: session.accessJwt, refreshJwt: session.refreshJwt)
    }
    
    private func getProfile(for sessionID: PersistentIdentifier) async {
        let context = ModelContext(ACModel.shared.container)
        guard let session = context.model(for: sessionID) as? ACSession,
              let profile = try? await AtProtocol.BskyLexicons().getProfile(for: session.did) else { return }
        let acProfile = ACProfile(did: profile.did, handle: profile.handle, displayName: profile.displayName, profileDescription: profile.description, avatar: profile.avatar, banner: profile.banner, followsCount: profile.followsCount, followersCount: profile.followersCount, postsCount: profile.postsCount, indexedAt: profile.indexedAt, viewer: profile.viewer, labels: profile.labels)
        context.insert(acProfile)
        session.profile = acProfile
        await downloadMyAvatar(url: acProfile.avatar, profileID: acProfile.id)
    }
    
    public func setupMyProfile() async {
        let context = ModelContext(ACModel.shared.container)
        guard let sessions = try? context.fetch(FetchDescriptor<ACSession>()),
              let session = sessions.first else { return }
        let sessionID = session.id
        
        await withTaskGroup(of: Void.self) { [weak self] group in
            guard let self else { return }
            
            group.addTask { await self.getProfile(for: sessionID) }
            group.addTask { await self.getPreferences(for: sessionID) }
            
            await group.waitForAll()
        }
    }
    
    private func downloadMyAvatar(url: String, profileID: PersistentIdentifier) async {
        let context = ModelContext(ACModel.shared.container)
        guard let url = URL(string: url),
            let profile = context.model(for: profileID) as? ACProfile else { return }
        
        let request = URLRequest(url: url)
        guard let (data, response) = try? await URLSession.shared.data(for: request) else { return }
        guard let httpResponse = response as? HTTPURLResponse else { return }
        switch httpResponse.statusCode {
        case 200...299:
            profile.avatarOnDisk = data
        default:
            break
        }
    }
    
    private func getPreferences(for sessionID: PersistentIdentifier) async  {
        let context = ModelContext(ACModel.shared.container)
        guard let session = context.model(for: sessionID) as? ACSession,
              let preferences = try? await AtProtocol.BskyLexicons().getPreferences(), let preferences = preferences.preferences.first else { return }
        
        let saved: [String] = preferences.saved
        let pinned: [String] = preferences.pinned
        let acPreferences = ACPreferences(type: preferences.type)
        
        async let savedFeeds = getFeedGenerators(for: saved)
        async let pinnedFeeds = getFeedGenerators(for: pinned)
        
        acPreferences.pinned = await pinnedFeeds
        acPreferences.saved = await savedFeeds
        context.insert(acPreferences)
        session.preferences = acPreferences
    }
    
    private func getFeedGenerators(for feeds: [String]) async -> [ACFeed] {
        guard let feeds = try? await AtProtocol.BskyLexicons().getFeedGenerators(for: feeds) else { return [] }
        return feeds.feeds.map {
            ACFeed(uri: $0.uri, cid: $0.cid, did: $0.did, creator: $0.creator, name: $0.displayName, feedDescription: $0.description, avatar: $0.avatar, likeCount: $0.likeCount, viewer: $0.viewer, indexedAt: $0.indexedAt)
        }
    }
    
    public func getTimeline(for sessionID: PersistentIdentifier, limit: Int) async {
        let context = ModelContext(ACModel.shared.container)
        guard let session = context.model(for: sessionID) as? ACSession,
              let timeline = try? await AtProtocol.BskyLexicons().getTimeline(limit: limit) else { return }
        
        let acTimeline = ACTimeline(feed: timeline.feed, cursor: timeline.cursor, session: session)
        context.insert(acTimeline)
    }
}
