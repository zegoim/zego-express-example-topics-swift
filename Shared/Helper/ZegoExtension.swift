//
//  ZegoExtension.swift
//  ZegoExpressExample-iOS-Swift
//
//  Created by Patrick Fu on 2020/2/26.
//  Copyright © 2020 Zego. All rights reserved.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        #if canImport(UIKit)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        #endif
    }
}

// MARK: - NavigationBar
extension View {
    func navigationBarAutoTitle<S>(_ title: S) -> some View where S : StringProtocol {
        #if canImport(UIKit)
        return self.navigationBarTitle(title, displayMode: .automatic)
        #elseif os(OSX)
        return self.navigationTitle(title)
        #endif
    }

    func navigationBarInlineTitle<S>(_ title: S) -> some View where S : StringProtocol {
        #if canImport(UIKit)
        return self.navigationBarTitle(title, displayMode: .inline)
        #elseif os(OSX)
        return self.navigationTitle(title)
        #endif
    }

    func navigationBarLargeTitle<S>(_ title: S) -> some View where S : StringProtocol {
        #if canImport(UIKit)
        return self.navigationBarTitle(title, displayMode: .large)
        #elseif os(OSX)
        return self.navigationTitle(title)
        #endif
    }
}

extension Text {
    func qualityStyle() -> some View {
        self.padding(EdgeInsets(top: 3, leading: 10, bottom: 3, trailing: 10))
            .font(.footnote)
    }
}

extension View {
    func customBackgroundColor(opacity: Double) -> some View {
        #if canImport(UIKit)
        return self.background(Color(UIColor.secondarySystemBackground).opacity(opacity))
        #elseif os(OSX)
        return self.background(Color(NSColor.windowBackgroundColor).opacity(opacity))
        #endif
    }
}


extension Array {
    func chunked(into size:Int) -> [[Element]] {
        
        var chunkedArray = [[Element]]()
        
        for index in 0...self.count {
            if index % size == 0 && index != 0 {
                chunkedArray.append(Array(self[(index - size)..<index]))
            } else if(index == self.count) {
                chunkedArray.append(Array(self[index - 1..<index]))
            }
        }
        
        return chunkedArray
    }
}
