//
//  TimelineListView.swift
//  atprosphere
//
//  Created by Thomas Rademaker on 10/30/23.
//

import SwiftUI
import SwiftData
import AtProtocol

struct TimelineListView: View {
    @Environment(HomeState.self) private var state
    @AppStorage(Constants.UserDefaults.currentSessionDid) private var currentSessionDid: String?
    @State var posts: [TimelineItem]
    @Namespace private var topID
    
    var body: some View {
        @Bindable var state = state
        
        List(posts) {
            PostCell(timelineItem: $0)
                .id($0 == posts.first ? topID : nil)
        }
        .scrollableToTop(scrollToTop: $state.scrollToTop, topID: topID)
        .listStyle(.plain)
        .commonView()
        .task {
//            if isCanvas {
//                posts = Timeline.preview.feed
//            } else {
//                guard let timeline = try? await AtProtocol.BskyLexicons().getTimeline(limit: 30) else { return }
//                posts = timeline.feed
//            }
//            #if DEBUG
//            posts = Timeline.preview.feed
//            #endif
        }
    }
}

fileprivate struct PostCell: View {
    @Environment(HomeState.self) private var state
    @State private var boosted = false
    var timelineItem: TimelineItem
    
    var body: some View {
        Button(action: openThread) {
            HStack(alignment: .top) {
                
                Button(action: openProfile) {
                    CommonImage(image: .url(url: timelineItem.post.author.avatar, sfSymbol: "person"))
                        .frame(width: 45, height: 45)
                        .clipShape(Circle())
                }
                .offset(y: boosted ? 20 : 0)
                
                VStack(alignment: .leading) {
                    if boosted {
                        BoostedByView()
                    }
                    
                    HStack {
                        Text(timelineItem.post.author.displayName ?? "")
                            .bold()
                            .fixedSize()
                        
                        Text(timelineItem.post.author.handle)
                            .foregroundStyle(.primaryBlack.opacity(0.8))
                            .truncationMode(.tail)
                        
                        Spacer()
                        
                        Text(timelineItem.post.indexedAt.toDate?.formatted ?? "")
                    }
                    .font(.system(size: 16))
                    .lineLimit(1)
                    .padding(.bottom, 2)
                    
                    Text(timelineItem.post.record.text)
                        .font(.system(size: 16))
                        .multilineTextAlignment(.leading)
                    
                    if let embed = timelineItem.post.embed {
                        EmbedView(embed: embed)
                            .padding(.vertical)
                    }
                    
                    PostActionsRowView(timelineItem: timelineItem)
                }
            }
        }
        .commonView()
        .listRowBackground(Color.clear)
    }
    
    private func openThread() {
        state.path.append(.thread)
    }
    
    private func openProfile() {
        state.path.append(.profile)
    }
}

fileprivate struct EmbedView: View {
    var embed: Embed
    
    private var normalizedType: String {
        let type = embed.type
        
        if let index = type.firstIndex(of: "#") {
            return String(type.prefix(upTo: index))
        } else {
            return type
        }
    }
    
    private var embedType: EmbedType? {
        EmbedType(rawValue: normalizedType)
    }
    
    var body: some View {
        switch embedType {
        case .image:  PostImagesView(embed: embed)
        case .record, .recordWithMedia: EmbeddedRecordView(embed: embed)
        case .external: ExternalEmbedView(embed: embed)
        case nil: EmptyView()
        }
    }
}

fileprivate struct PostImagesView: View {
    @Environment(HomeState.self) private var state
    var embed: Embed
    
    // TODO: this should handle multiple images not just .first?
    var body: some View {
        Button(action: openImagesFullScreen) {
            MediaView(timelineImage: embed.images?.first?.thumb)
                .scaledToFit()
                .frame(maxHeight: 200)
        }
    }
    
    private func openImagesFullScreen() {
        state.images = embed.images?.first?.thumb
    }
}

fileprivate struct EmbeddedRecordView: View {
    var embed: Embed
    
    var body: some View {
        Button(action: openThread) {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    CommonImage(image: .url(url: embed.record?.author?.avatar, sfSymbol: "person"))
                        .frame(width: 20, height: 20)
                        .clipShape(Circle())
                    
                    Text(embed.record?.author?.displayName ?? "")
                        .bold()
                        .fixedSize()
                    
                    Text(embed.record?.author?.handle ?? "")
                        .foregroundStyle(.primaryBlack.opacity(0.8))
                        .truncationMode(.tail)
                    
                    Spacer()
                    
                    Text(embed.record?.value?.createdAt.toDate?.formatted ?? "")
                }
                .font(.system(size: 16))
                .lineLimit(1)
                .padding(.bottom, 2)
                
                Text(embed.record?.value?.text ?? "")
                    .font(.system(size: 16))
                    .multilineTextAlignment(.leading)
                
                MediaView(timelineImage: embed.media?.images?.first?.thumb)
                    .scaledToFit()
                    .frame(maxHeight: 200)
            }
            .padding(8)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke()
            )
            .background(
                Rectangle()
                    .foregroundColor(.primaryWhite)
                    .shadow(radius: 4)
            )
            .frame(maxWidth: .infinity)
        }
    }
    
    private func openThread() {
        print("OPEN THREAD")
    }
}

fileprivate struct ExternalEmbedView: View {
    @Environment(\.openURL) private var openURL
    private var hasImage: Bool { embed.external?.thumb != nil }
    private var mediaHeight: Double = 175
    
    var embed: Embed
    
    init(embed: Embed) {
        self.embed = embed
    }
    
    var body: some View {
        ZStack {
            VStack {
                MediaView(timelineImage: embed.external?.thumb)
                    .scaledToFill()
                    .frame(height: mediaHeight)
                    .clipped()
                    .clipShape(RoundedCorners(radius: 4, corners: [.topLeft, .topRight]))
                Spacer()
            }
            
            Button(action: openLink) {
                VStack {
                    if hasImage {
                        Spacer()
                            .frame(height: mediaHeight)
                    }
                    
                    HStack {
                        Text(embed.external?.title ?? "")
                            .font(.system(size: 16))
                            .bold()
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Text(embed.external?.externalDescription ?? "")
                            .font(.system(size: 12))
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    .padding(.horizontal)
                }
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [10, 5]))
        )
        .background(
            Rectangle()
                .foregroundColor(.primaryWhite)
                .shadow(radius: 4)
        )
        .frame(maxWidth: .infinity)
    }
    
    private func openLink() {
        guard let uri = embed.external?.uri, let url = URL(string: uri) else { return } // TODO: should this alert the user?
        openURL(url)
    }
}

fileprivate struct MediaView: View {
    var timelineImage: TimelineImage?
    
    var body: some View {
        // TODO: This code has a lot of TODOs
        // 1. it needs to support multiple images (Horizontal Scroll view)
        // 2. is thumb the correct image?
        // 3. if thumb is an embeddedImage object, how do I get the image?

        switch timelineImage {
        case .string(let url):
            CommonImage(image: .url(url: url , sfSymbol: "photo"))
        case .image(let embeddedImage):
            Color.red
                .frame(width: 300, height: 300)
            
        case nil:
            EmptyView()
        }
    }
}

fileprivate struct PostActionsRowView: View {
    var timelineItem: TimelineItem
    
    var body: some View {
        HStack {
            Button(action: comment) {
                HStack {
                    Image(systemName: "bubble.middle.bottom")
                    Text("\(timelineItem.post.replyCount)")
                }
                .font(.footnote)
                .foregroundStyle(.accent)
            }
            
            Spacer()
            
            Button(action: repost) {
                HStack {
                    Image(systemName: "arrow.2.squarepath")
                    Text("\(timelineItem.post.repostCount)")
                }
                .font(.footnote)
                .foregroundStyle(.accent)
            }
            
            Spacer()
            
            Button(action: favorite) {
                HStack {
                    Image(systemName: "heart")
                    Text("\(timelineItem.post.likeCount)")
                }
                .font(.footnote)
                .foregroundStyle(.accent)
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "square.and.arrow.up")
                    .font(.footnote)
                    .foregroundStyle(.accent)
            }
            
//            ShareLink("", item: "Yo")
            
            Spacer()
            
            Button(action: moreOptions) {
                Image(systemName: "ellipsis")
                    .font(.footnote)
                    .foregroundStyle(.accent)
            }
            
            Spacer()
        }
        .padding(.top, 2)
    }
    
    private func comment() { }
    private func repost() {}
    private func favorite() {}
    private func moreOptions() {}
}

fileprivate struct BoostedByView: View {
    var body: some View {
        ZStack {
            Capsule()
                .fill(Color.primaryBlack.opacity(0.7))
                .frame(height: 20)
            
            HStack {
                CommonImage(image: .url(url: "https://pbs.twimg.com/profile_images/1537799382677995521/BQSmUtMK_400x400.jpg", sfSymbol: "person"))
                    .frame(width: 20, height: 20)
                    .clipShape(Circle())
                
                Text("Thomas Rademaker")
                
                Image(systemName: "arrow.2.squarepath")
            }
        }
    }
}

#Preview(traits: .sampleTimeline) {
    @Previewable @Query var timeline: [ACTimeline]
    
    TimelineListView(posts: timeline.flatMap { $0.feed } )
        .environment(HomeState(parentState: .init()))
}
