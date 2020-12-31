//
//  ZegoExpressExampleApp.swift
//  Shared
//
//  Created by Patrick Fu on 2020/12/29.
//  Copyright © 2020 Zego. All rights reserved.
//

import SwiftUI

@main
struct ZegoExpressExampleApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }.commands {
            CommandGroup(after: CommandGroupPlacement.appInfo) {
                NavigationLink(destination: AppGlobalConfigView()) {
                    Text("Preferences")
                }.keyboardShortcut(",")
            }
        }

        WindowGroup("Preference") {
            AppGlobalConfigView()
        }.handlesExternalEvents(matching: Set(arrayLiteral: "*"))
    }
}
