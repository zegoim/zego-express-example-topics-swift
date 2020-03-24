//
//  AnyGestureRecognizer.swift
//  ZegoExpressExample-iOS-Swift
//
//  Created by Patrick Fu on 2020/2/22.
//  Copyright © 2020 Zego. All rights reserved.
//

import UIKit

class AnyGestureRecognizer: UIGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        state = .began
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       state = .ended
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        state = .cancelled
    }
}
