//
//  AppGlobalConfigView.swift
//  ZegoExpressExample-iOS-Swift
//
//  Created by Patrick Fu on 2020/7/21.
//  Copyright © 2020 Zego. All rights reserved.
//

import SwiftUI
import ZegoExpressEngine

let objcDemoURL = "https://github.com/zegoim/zego-express-example-topics-ios-oc"

struct AppGlobalConfigView: View {
    var body: some View {
        List {
            Section(header: Text("Version")) {
                VStack(alignment: .leading, spacing: 5.0) {
                    Text("ZegoExpressEngine Version:")
                    HStack {
                        Text("\(ZegoExpressEngine.getVersion())")
                        Spacer()
                        Button(action: {
                            #if canImport(UIKit)
                            UIPasteboard.general.string = ZegoExpressEngine.getVersion()
                            #elseif os(OSX)
                            NSPasteboard.general.clearContents()
                            NSPasteboard.general.setString(ZegoExpressEngine.getVersion(), forType: .string)
                            #endif
                        }) {
                            Text("Copy").foregroundColor(.blue)
                        }
                    }
                }

                Text("Demo Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String) (beta)")

                Text("Demo BuildNumber: \(Bundle.main.infoDictionary?["CFBundleVersion"] as! String)")
            }

            Section(header: Text("Note")) {
                Text("This Swift demo is a beta version, please refer to Objective-C demo for more functions").font(.footnote)

                Button(action: {
                    if let url = URL(string: objcDemoURL) {
                        #if canImport(UIKit)
                        UIApplication.shared.open(url)
                        #elseif os(OSX)
                        NSWorkspace.shared.open(url)
                        #endif
                    }
                }) {
                    Text("\(objcDemoURL)").foregroundColor(.blue).font(.footnote)
                }
            }
        }
        .navigationBarLargeTitle("Setting")
    }
}

struct AppGlobalConfigView_Previews: PreviewProvider {
    static var previews: some View {
        AppGlobalConfigView()
    }
}
