//
//  ViewExtension.swift
//  ZegoExpressExample-iOS-Swift
//
//  Created by Patrick Fu on 2020/2/26.
//  Copyright © 2020 Zego. All rights reserved.
//

import SwiftUI

extension Text {
    func qualityStyle() -> some View {
        self.padding(EdgeInsets(top: 3, leading: 10, bottom: 3, trailing: 10))
            .font(.footnote)
    }
}
