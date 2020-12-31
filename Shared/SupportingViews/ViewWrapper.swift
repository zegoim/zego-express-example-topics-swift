//
//  ViewWrapper.swift
//  ZegoExpressTests
//
//  Created by Patrick Fu on 2020/8/15.
//  Copyright © 2020 Zego. All rights reserved.
//

import SwiftUI

#if canImport(UIKit)

struct ViewWrapper: UIViewRepresentable {
    let view = UIView()

    func makeUIView(context: Context) -> some UIView {
        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
    }

}

#elseif os(OSX)

struct ViewWrapper: NSViewRepresentable {

    let view = NSView()

    func makeNSView(context: Context) -> some NSView {
        return view
    }

    func updateNSView(_ nsView: NSViewType, context: Context) {
    }
}

#endif
