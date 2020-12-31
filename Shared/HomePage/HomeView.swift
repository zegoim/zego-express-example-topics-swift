//
//  HomeView.swift
//  ZegoExpressExample-iOS-Swift
//
//  Created by Patrick Fu on 2020/2/22.
//  Copyright © 2020 Zego. All rights reserved.
//

import SwiftUI


struct HomeView: View {
    
    let topics = [
        "QuickStart",
        "PublishStream",
        "PlayStream",
        "VideoTalk"
    ]
    
    func containedView(topic: String) -> AnyView {
        switch topic {
        case "QuickStart":
            return AnyView(QuickStartView())
        case "PublishStream":
            return AnyView(PublishStreamTopicView())
        case "PlayStream":
            return AnyView(PlayStreamTopicView())
        case "VideoTalk":
            return AnyView(VideoTalkView())
        default:
            return AnyView(Text("None"))
        }
    }

    var body: some View {
        NavigationView {
            contentView()
                .navigationBarLargeTitle("ZegoExpressExample")
                .toolbar {
                    ToolbarItem(placement: ToolbarItemPlacement.automatic) {
                        #if canImport(UIKit)
                        NavigationLink(destination: AppGlobalConfigView()) {
                            Image(systemName: "gearshape.fill")
                        }
                        #elseif os(OSX)
                        Button {
                            if let url = URL(string: "zegoexpress://Preference") {
                                NSWorkspace.shared.open(url)
                            }
                        } label: {
                            Image(systemName: "gearshape.fill")
                        }
                        #endif
                    }
                }
        }
    }

    func contentView() -> some View {
        List(topics, id: \.self) { topic in
            NavigationLink(destination: LazyView(self.containedView(topic: topic))) {
                HStack {
                    Text(topic)
                }
            }
        }
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
#endif
