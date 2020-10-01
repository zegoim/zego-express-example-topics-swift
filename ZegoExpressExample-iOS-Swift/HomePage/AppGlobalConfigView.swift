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
                            UIPasteboard.general.string = ZegoExpressEngine.getVersion()
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
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("\(objcDemoURL)").foregroundColor(.blue).font(.footnote)
                }
            }
        }
        .navigationBarTitle("Setting", displayMode: .large)
    }
}

struct AppGlobalConfigView_Previews: PreviewProvider {
    static var previews: some View {
        AppGlobalConfigView()
    }
}
