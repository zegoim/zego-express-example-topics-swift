//
//  PublishStreamTopicManager.swift
//  ZegoExpressExample-iOS-Swift
//
//  Created by Patrick Fu on 2020/2/26.
//  Copyright © 2020 Zego. All rights reserved.
//

import UIKit
import ZegoExpressEngine

class PublishStreamTopicManager: NSObject, ObservableObject, ZegoEventHandler {
    
    let previewView: UIView
    
    init(previewView: UIView) {
        self.previewView = previewView
    }
    
    @Published var roomState = ZegoRoomState.disconnected
    @Published var publishState = ZegoPublisherState.noPublish
    
    @Published var videoSize = CGSize(width: 0, height: 0)
    @Published var videoCaptureFPS : Double = 0.0
    @Published var videoEncodeFPS : Double = 0.0
    @Published var videoSendFPS : Double = 0.0
    @Published var videoBitrate : Double = 0.0
    @Published var videoNetworkQuality = ""
    @Published var isHardwareEncode = false
    
    var videoConfig = ZegoVideoConfig(preset: .preset540P)
    var videoMirrorMode = ZegoVideoMirrorMode.onlyPreviewMirror
    var previewViewMode = ZegoViewMode.aspectFit
    
    var previewCanvas = ZegoCanvas()
    
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
        ZegoExpressEngine.shared().muteSpeaker(false)
        ZegoExpressEngine.shared().enableCamera(true)
        ZegoExpressEngine.shared().enableHardwareEncoder(false)
        
        videoConfig.fps = 30
        videoConfig.bitrate = 2400;
        ZegoExpressEngine.shared().setVideoConfig(videoConfig)
        
        ZegoExpressEngine.shared().setVideoMirrorMode(videoMirrorMode)
        
        previewCanvas.view = previewView
        previewCanvas.viewMode = previewViewMode
        
        NSLog(" 🔌 Start preview")
        ZegoExpressEngine.shared().startPreview(previewCanvas)
    }
    
    
    func startLive(roomID: String, streamID: String) {
        NSLog(" 🚪 Start login room, roomID: \(roomID)")
        ZegoExpressEngine.shared().loginRoom(roomID, user: ZegoUser(userID: userID))
        
        NSLog(" 📤 Start publishing stream, streamID: \(streamID)")
        ZegoExpressEngine.shared().startPublishingStream(streamID)
    }
    
    
    func stopLive(roomID: String) {
        NSLog(" 🚪 Logout room")
        ZegoExpressEngine.shared().logoutRoom(roomID)
        
        // Clear state
        videoSize = CGSize(width: 0, height: 0)
        videoCaptureFPS = 0.0
        videoEncodeFPS = 0.0
        videoSendFPS = 0.0
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
        
        // After logout room, the preview will stop. You need to re-start preview.
        if state == .disconnected {
            ZegoExpressEngine.shared().startPreview(previewCanvas)
        }
    }
    
    func onPublisherStateUpdate(_ state: ZegoPublisherState, errorCode: Int32, extendedData: [AnyHashable : Any]?, streamID: String) {
        NSLog(" 🚩 📤 Publisher state update, state: \(state.rawValue), errorCode: \(errorCode), streamID: \(streamID)")
        publishState = state
    }
    
    func onPublisherQualityUpdate(_ quality: ZegoPublishStreamQuality, streamID: String) {
        videoCaptureFPS = quality.videoCaptureFPS
        videoEncodeFPS = quality.videoEncodeFPS
        videoSendFPS = quality.videoSendFPS
        videoBitrate = quality.videoKBPS
        isHardwareEncode = quality.isHardwareEncode
        
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
    
    func onPublisherVideoSizeChanged(_ size: CGSize, channel: ZegoPublishChannel) {
        videoSize = size
    }
}
