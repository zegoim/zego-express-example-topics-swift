//
//  PlayStreamTopicManager.swift
//  ZegoExpressExample-iOS-Swift
//
//  Created by Patrick Fu on 2020/2/26.
//  Copyright © 2020 Zego. All rights reserved.
//

import UIKit
import ZegoExpressEngine

class PlayStreamTopicManager: NSObject, ObservableObject, ZegoEventHandler {
    
    let playView: UIView
    
    init(playView: UIView) {
        self.playView = playView
    }
    
    @Published var roomState = ZegoRoomState.disconnected
    @Published var playerState = ZegoPlayerState.noPlay
    
    @Published var videoSize = CGSize(width: 0, height: 0)
    @Published var videoFPS : Double = 0.0
    @Published var videoBitrate : Double = 0.0
    @Published var videoNetworkQuality = ""
    @Published var isHardwareDecode = false
    
    var playViewMode = ZegoViewMode.aspectFit
    
    var playCanvas = ZegoCanvas()
    
    let userID: String = String(UUID().uuidString.prefix(6))
    
    // MARK: - Actions
    
    func createEngine() {
        let appID: UInt32 = KeyCenter.appID
        let appSign: String = KeyCenter.appSign
        let isTestEnv: Bool = true
        let scenario: ZegoScenario = .general
        
        NSLog(" 🚀 Create ZegoExpressEngine")
        ZegoExpressEngine.createEngine(withAppID: appID, appSign: appSign, isTestEnv: isTestEnv, scenario: scenario, eventHandler: self)
        
        ZegoExpressEngine.shared().muteMicrophone(false)
        ZegoExpressEngine.shared().muteAudioOutput(false)
        ZegoExpressEngine.shared().enableCamera(true)
        ZegoExpressEngine.shared().enableHardwareEncoder(false)
        
        playCanvas.view = playView
        playCanvas.viewMode = playViewMode
        
    }
    
    func startLive(roomID: String, streamID: String) {
        NSLog(" 🚪 Start login room, roomID: \(roomID)")
        ZegoExpressEngine.shared().loginRoom(roomID, user: ZegoUser(userID: userID))
        
        NSLog(" 📥 Strat playing stream, streamID: \(streamID)")
        ZegoExpressEngine.shared().startPlayingStream(streamID, canvas: playCanvas)
    }
    
    
    func stopLive(roomID: String) {
        NSLog(" 🚪 Logout room")
        ZegoExpressEngine.shared().logoutRoom(roomID)
        
        // Clear state
        videoSize = CGSize(width: 0, height: 0)
        videoFPS = 0.0
        videoBitrate = 0.0
        videoNetworkQuality = ""
    }
    
    // MARK: Exit
    
    func destroyEngine() {
        NSLog(" 🏳️ Destroy ZegoExpressEngine")
        ZegoExpressEngine.destroy(nil)
    }
    
    // MARK: - ZegoEventHandler Delegate
    
    func onRoomStateUpdate(_ state: ZegoRoomState, errorCode: Int32, extendedData: [AnyHashable : Any]?, roomID: String) {
        NSLog(" 🚩 🚪 Room state update, state: \(state.rawValue), errorCode: \(errorCode), roomID: \(roomID)")
        roomState = state
    }
    
    func onPlayerStateUpdate(_ state: ZegoPlayerState, errorCode: Int32, extendedData: [AnyHashable : Any]?, streamID: String) {
        NSLog(" 🚩 📥 Player state update, state: \(state.rawValue), errorCode: \(errorCode), streamID: \(streamID)")
        playerState = state
    }
    
    func onPlayerQualityUpdate(_ quality: ZegoPlayStreamQuality, streamID: String) {
        videoFPS = quality.videoRecvFPS
        videoBitrate = quality.videoKBPS
        isHardwareDecode = quality.isHardwareDecode
        
        switch (quality.level) {
        case .excellent:
            videoNetworkQuality = "☀️"
            break
        case .good:
            videoNetworkQuality = "⛅️"
            break
        case .medium:
            videoNetworkQuality = "☁️"
            break
        case .bad:
            videoNetworkQuality = "🌧"
            break
        case .die:
            videoNetworkQuality = "❌"
            break
        default:
            break
        }
    }
    
    func onPlayerVideoSizeChanged(_ size: CGSize, streamID: String) {
        videoSize = size
    }

}
