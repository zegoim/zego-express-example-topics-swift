//
//  LogTextView.swift
//  ZegoExpressExample-iOS-Swift
//
//  Created by Patrick Fu on 2020/3/26.
//  Copyright © 2020 Zego. All rights reserved.
//

import SwiftUI

#if canImport(UIKit)
struct LogTextView: UIViewRepresentable {
    
    @Binding var text: String
    
    func makeUIView(context: UIViewRepresentableContext<LogTextView>) -> UITextView {
        let textView = UITextView()
        textView.isScrollEnabled = true
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.font = UIFont.systemFont(ofSize: 10.0)
        textView.backgroundColor = UIColor.secondarySystemBackground
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<LogTextView>) {
        uiView.text = text
        uiView.scrollRangeToVisible(NSMakeRange(text.count - 1, 1))
    }
}
#elseif os(OSX)
struct LogTextView: NSViewRepresentable {
    @Binding var text: String
    func makeNSView(context: Context) -> NSTextView {
        let textView = NSTextView()
        textView.isSelectable = true
        textView.font = NSFont.systemFont(ofSize: 10.0)
        textView.backgroundColor = NSColor.textBackgroundColor
        return textView
    }

    func updateNSView(_ nsView: NSTextView, context: Context) {
        nsView.string = text
    }
}
#endif
