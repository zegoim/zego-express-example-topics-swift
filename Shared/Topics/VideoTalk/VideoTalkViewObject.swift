//
//  VideoTalkViewObject.swift
//  ZegoExpressExample-iOS-Swift
//
//  Created by Patrick Fu on 2020/3/25.
//  Copyright © 2020 Zego. All rights reserved.
//

import Foundation

class VideoTalkViewObject: NSObject, Identifiable {
    
    let isLocal: Bool
    let streamID: String
    let view: ViewWrapper
    
    let id: String
    
    init(isLocal: Bool, streamID: String, view: ViewWrapper) {
        self.isLocal = isLocal
        self.streamID = streamID
        self.view = view
        self.id = streamID
    }
}
