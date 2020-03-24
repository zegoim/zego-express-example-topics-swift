//
//  ZGView.swift
//  ZegoExpressExample-iOS-Swift
//
//  Created by Patrick Fu on 2020/2/22.
//  Copyright © 2020 Zego. All rights reserved.
//

import SwiftUI

struct ZGView: UIViewRepresentable {
    var view = UIView()
    
    func makeUIView(context: UIViewRepresentableContext<ZGView>) -> UIView {
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<ZGView>) {
    }
}
