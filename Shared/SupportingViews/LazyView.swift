//
//  LazyView.swift
//  ZegoExpressExample-iOS-Swift
//
//  Created by Patrick Fu on 2020/2/22.
//  Copyright © 2020 Zego. All rights reserved.
//

/**
 Sources:
  - https://medium.com/better-programming/swiftui-navigation-links-and-the-common-pitfalls-faced-505cbfd8029b
 
 Example usage:
    struct ContentView: View {
        var body: some View {
            NavigationView {
                NavigationLink(destination: LazyView(Text("My details page")) {
                    Text("Go to details")
                }
            }
        }
    }
*/

import SwiftUI

public struct LazyView<Content: View>: View {
    private let build: () -> Content
    public init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    public var body: Content {
        build()
    }
}
