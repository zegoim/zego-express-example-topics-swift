//
//  VideoTalkManager.swift
//  ZegoExpressExample-iOS-Swift
//
//  Created by Patrick Fu on 2020/3/25.
//  Copyright © 2020 Zego. All rights reserved.
//

import UIKit
import ZegoExpressEngine

class VideoTalkManager: NSObject, ObservableObject, ZegoEventHandler {
    
    @Published var active = false {
        didSet {
            self.active ? joinTalkRoom() : exitTalkRoom()
        }
    }
    
    @Published var roomState = ZegoRoomState.disconnected
    @Published var viewObjectList: [VideoTalkViewObject] = []
    
    @Published var isEnableCamera: Bool = true {
        didSet {
            toggleCameraSwitch()
        }
    }
    
    @Published var isEnableMic: Bool = true {
        didSet {
            toggleMicSwitch()
        }
    }
    
    @Published var isEnableSpeaker: Bool = true {
        didSet {
            toggleSpeakerSwitch()
        }
    }
    
    let roomID = "VideoTalkRoom-1"
    let localStreamID: String
    let localUserID: String
    let localUserViewObject: VideoTalkViewObject
    
    override init() {
        localUserID = String(UUID().uuidString.prefix(6))
        localStreamID = "s-\(localUserID)"
        localUserViewObject = VideoTalkViewObject(isLocal: true, streamID: localStreamID, view: UIViewWrapper())
    }
    
    // MARK: - Actions
    
    private func joinTalkRoom() {
        
        // Create engine
        NSLog(" 🚀 Create ZegoExpressEngine")
        ZegoExpressEngine.createEngine(withAppID: KeyCenter.appID, appSign: KeyCenter.appSign, isTestEnv: true, scenario: .general, eventHandler: self)

        // Login room
        NSLog(" 🚪 Login room, roomID: \(roomID)")
        ZegoExpressEngine.shared().loginRoom(roomID, user: ZegoUser(userID: localUserID))
        
        // Set the publish video configuration
        ZegoExpressEngine.shared().setVideoConfig(ZegoVideoConfig(preset: .preset720P))
        
        // Get the local user's preview view and start preview
        let previewCanvas = ZegoCanvas(view: localUserViewObject.view.view)
        previewCanvas.viewMode = .aspectFill
        NSLog(" 🔌 Start preview")
        ZegoExpressEngine.shared().startPreview(previewCanvas)
        
        // Local user start publishing
        NSLog(" 📤 Start publishing stream, streamID: \(localStreamID)")
        ZegoExpressEngine.shared().startPublishingStream(localStreamID)
        
        viewObjectList.append(localUserViewObject)
        
    }
    
    
    private func exitTalkRoom() {
        // It is recommended to logout room when stopping the video call.
        NSLog(" 🚪 Logout room, roomID: \(roomID)")
        ZegoExpressEngine.shared().logoutRoom(roomID)
        
        // And you can destroy the engine when there is no need to call.
        NSLog(" 🏳️ Destroy ZegoExpressEngine")
        ZegoExpressEngine.destroy(nil);
    }
    
    private func toggleCameraSwitch() {
        ZegoExpressEngine.shared().enableCamera(isEnableCamera)
    }
    
    private func toggleMicSwitch() {
        ZegoExpressEngine.shared().muteMicrophone(!isEnableMic)
    }
    
    private func toggleSpeakerSwitch() {
        ZegoExpressEngine.shared().muteSpeaker(!isEnableSpeaker)
    }
    
    // MARK: - ViewObject Methods
    
    private func getViewObjectWithStreamID(streamID: String) -> VideoTalkViewObject? {
        for object in viewObjectList {
            if object.streamID == streamID {
                return object
            }
        }
        return nil
    }
    
    /// Add a view of user who has entered the room and play the user stream
    private func addRemoteViewObjectIfNeedWithStreamID(streamID: String) {
        let viewObject = getViewObjectWithStreamID(streamID: streamID)
            ?? VideoTalkViewObject(isLocal: false, streamID: streamID, view: UIViewWrapper())
        
        viewObjectList.append(viewObject)
        
        let playCanvas = ZegoCanvas(view: viewObject.view.view)
        playCanvas.viewMode = .aspectFill
        
        NSLog(" 📥 Start playing stream, streamID: \(streamID)")
        ZegoExpressEngine.shared().startPlayingStream(streamID, canvas: playCanvas)
    }
    
    /// Remove view of user who has left the room and stop playing stream
    private func removeViewObjectWithStreamID(streamID: String) {
        NSLog(" 📥 Stop playing stream, streamID: \(streamID)")
        ZegoExpressEngine.shared().stopPlayingStream(streamID)
        
        guard let viewObject = getViewObjectWithStreamID(streamID: streamID) else {
            return
        }
        
        if let index = viewObjectList.firstIndex(of: viewObject) {
            viewObjectList.remove(at: index)
        }
    }
    
    // MARK: - ZegoEventHandler Delegate
    
    func onRoomStateUpdate(_ state: ZegoRoomState, errorCode: Int32, extendedData: [AnyHashable : Any]?, roomID: String) {
        NSLog(" 🚩 🚪 Room state update, state: \(state.rawValue), errorCode: \(errorCode), roomID: \(roomID)")
        roomState = state
    }
    
    func onRoomStreamUpdate(_ updateType: ZegoUpdateType, streamList: [ZegoStream], roomID: String) {
        NSLog(" 🚩 🌊 Room stream update, type: \(updateType == .add ? "Add" : "Delete"), streamsCount: \(streamList.count), roomID: \(roomID)")
        
        let allStreamIDList = viewObjectList.map{ $0.streamID }
        
        if updateType == .add {
            for stream in streamList {
                NSLog(" 🚩 🌊 --- [Add] StreamID: \(stream.streamID), UserID: \(stream.user.userID)")
                if !allStreamIDList.contains(stream.streamID) {
                    addRemoteViewObjectIfNeedWithStreamID(streamID: stream.streamID)
                }
            }
        } else if updateType == .delete {
            for stream in streamList {
                NSLog(" 🚩 🌊 --- [Delete] StreamID: \(stream.streamID), UserID: \(stream.user.userID)")
                removeViewObjectWithStreamID(streamID: stream.streamID)
            }
        }
    }
}
