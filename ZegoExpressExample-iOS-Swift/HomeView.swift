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
        "PlayStream"
    ]
    
    func containedView(topic: String) -> AnyView {
        switch topic {
        case "QuickStart":
            return AnyView(QuickStartView())
        case "PublishStream":
            return AnyView(PublishStreamTopicView())
        case "PlayStream":
            return AnyView(PlayStreamTopicView())
        default:
            return AnyView(Text("None"))
        }
    }
    
    var body: some View {
        NavigationView {
            List(topics, id: \.self) { topic in
                NavigationLink(destination: LazyView(self.containedView(topic: topic))) {
                    HStack {
                        Text(topic)
                    }
                }
            }
            .navigationBarTitle("ZegoExpressExample", displayMode: .large)
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
