//
//  UIViewWrapper.swift
//  ZegoExpressExample-iOS-Swift
//
//  Created by Patrick Fu on 2020/2/22.
//  Copyright © 2020 Zego. All rights reserved.
//

import SwiftUI

struct UIViewWrapper: UIViewRepresentable {
    let view = UIView()
    
    func makeUIView(context: UIViewRepresentableContext<UIViewWrapper>) -> UIView {
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<UIViewWrapper>) {
    }
}
