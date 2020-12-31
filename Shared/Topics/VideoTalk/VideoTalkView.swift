//
//  VideoTalkView.swift
//  ZegoExpressExample-iOS-Swift
//
//  Created by Patrick Fu on 2020/3/25.
//  Copyright © 2020 Zego. All rights reserved.
//

import SwiftUI

struct VideoTalkView: View {
    
    @ObservedObject var manager: VideoTalkManager
    
    init() {
        manager = VideoTalkManager()
        
        manager.active = true
    }
    
    var body: some View {
        VStack(spacing: 0) {
            roomInfoView()

            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                    ForEach(self.manager.viewObjectList, id: \.self) { viewObject in
                        ZStack {
                            viewObject.view.aspectRatio(0.7, contentMode: .fit)
                        }
                    }
                }.padding(10.0)
            }
            
            togglesView().padding(.vertical, 10)
        }
        .navigationBarInlineTitle("Video Talk")
        .onDisappear{
            self.manager.active = false
        }
    }
    
    func roomInfoView() -> some View {
        HStack {
            Text("RoomID: \(self.manager.roomID)")
                .font(.footnote)
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 1, trailing: 5))
            
            Spacer()
            
            roomStateText()
                .font(.footnote)
                .padding(EdgeInsets(top: 10, leading: 5, bottom: 1, trailing: 10))
        }
    }
    
    func roomStateText() -> some View {
        switch manager.roomState {
        case .connected:
            return Text("Connected 🟢")
        case .connecting:
            return Text("Connecting 🟡")
        case .disconnected:
            return Text("Disconnected 🔴")
        default:
            return Text("Error")
        }
    }
    
    func togglesView() -> some View {
        HStack(alignment: .center, spacing: 10) {
            VStack(alignment: .center, spacing: 5) {
                Text("Camera")
                Toggle("Turn camara on", isOn: $manager.isEnableCamera).labelsHidden()
            }.frame(minWidth: 0, maxWidth: .infinity)
            
            VStack(alignment: .center, spacing: 5) {
                Text("Microphone")
                Toggle("Turn microphone on", isOn: $manager.isEnableMic).labelsHidden()
            }.frame(minWidth: 0, maxWidth: .infinity)
            
            VStack(alignment: .center, spacing: 5) {
                Text("Speaker")
                Toggle("Turn speaker on", isOn: $manager.isEnableSpeaker).labelsHidden()
            }.frame(minWidth: 0, maxWidth: .infinity)
        }
    }
}

#if DEBUG
struct VideoTalkView_Previews: PreviewProvider {
    static var previews: some View {
        VideoTalkView()
    }
}
#endif
