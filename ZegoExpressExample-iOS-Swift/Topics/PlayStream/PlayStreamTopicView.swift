//
//  PlayStreamTopicView.swift
//  ZegoExpressExample-iOS-Swift
//
//  Created by Patrick Fu on 2020/2/26.
//  Copyright © 2020 Zego. All rights reserved.
//

import SwiftUI
import ZegoExpressEngine

struct PlayStreamTopicView: View {
    
    let playView: ZGView
    
    @ObservedObject var manager: PlayStreamTopicManager
    
    @State var roomID = ""
    @State var streamID = ""
    
    init() {
        playView = ZGView()
        manager = PlayStreamTopicManager(playView: playView.view)
    }
    
    var body: some View {
        ZStack {
            playView
            
            VStack {
                HStack {
                    
                    qualityView
                    
                    Spacer()
                }
                
                Spacer().frame(height: 50)
                
                if self.manager.playerState == .noPlay {
                    configView
                } else {
                    Spacer().layoutPriority(1)
                }
                
                Spacer().frame(height: 30)
                
                Button(action: {
                    if self.manager.playerState == .noPlay {
                        self.manager.startLive(roomID: self.roomID, streamID: self.streamID)
                    } else if self.manager.playerState == .playing {
                        self.manager.stopLive(roomID: self.roomID)
                    }
                }) {
                    Text("\(self.manager.playerState == .playing ? "Stop Live" : "Start Live")")
                        .padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .font(.headline)
                }
                
                Spacer(minLength: 50)
                
            }
        }
        .navigationBarTitle("Play Stream", displayMode: .inline)
        .onAppear {
            self.manager.createEngine()
        }
        .onDisappear{
            self.manager.destroyEngine()
        }
    }
    
    var qualityView: some View {
        VStack(alignment: .leading) {
            
            Spacer().frame(height: 5)
            
            Text("Resolution: \(Int(self.manager.videoSize.width)) x \(Int(self.manager.videoSize.height))").qualityStyle()
            
            Text("FPS: \(Int(self.manager.videoFPS)) fps").qualityStyle()
            
            Text("Bitrate: \(self.manager.videoBitrate, specifier: "%.2f") kb/s").qualityStyle()
            
            Text("HardwareDecode: \(self.manager.isHardwareDecode ? "✅" : "❎")").qualityStyle()
            
            Text("NetworkQuality: \(self.manager.videoNetworkQuality)").qualityStyle()
            
            Spacer().frame(height: 5)
            
        }
        .background(Color(UIColor.secondarySystemBackground).opacity(0.5))
    }

    
    var configView: some View {
        VStack(alignment: .leading, spacing: 5) {
            
            Text("Room ID:")
            
            TextField("Please enter room ID", text: self.$roomID)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Spacer().frame(height: 20)
            
            Text("Stream ID:")
            
            TextField("Please enter stream ID:", text: self.$streamID)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
        }
        .padding(20)
    }
}

#if DEBUG
struct PlayStreamTopicView_Previews: PreviewProvider {
    static var previews: some View {
        PlayStreamTopicView()
    }
}
#endif
