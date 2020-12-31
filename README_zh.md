# Zego Express Example Topics (Swift)

[English](README.md) | [中文](README_zh.md)

Zego Express (Swift) 示例专题 Demo (iOS + macOS)

## 下载 SDK

此 Repository 中缺少运行 Demo 工程所需的 SDK `ZegoExpressEngine.framework`，需要下载并放入 Demo 工程的 `iOS/Libs` 以及 `macOS/Libs` 文件夹中

> 直接运行 Demo，编译前脚本若检测到对应文件夹下不存在 SDK Framework 时会自动下载 SDK。也可以自行下载 SDK 并放入对应文件夹中。

**iOS:** [https://storage.zego.im/express/video/ios/zego-express-video-ios.zip](https://storage.zego.im/express/video/ios/zego-express-video-ios.zip)

**macOS:** [https://storage.zego.im/express/video/mac-objc/zego-express-video-mac-objc.zip](https://storage.zego.im/express/video/mac-objc/zego-express-video-mac-objc.zip)

> 请注意，**iOS** 压缩包中有两个文件夹：`armv7-arm64` 和 `armv7-arm64-x86_64`，区别在于：

1. `armv7-arm64` 内的动态库仅包含真机的架构（armv7, arm64）。开发者在最终上架 App 时，需要使用此文件夹下的 `ZegoExpressEngine.framework`，否则可能被 App Store 拒绝。

2. `armv7-arm64-x86_64` 内的动态库包含了真机与模拟器架构（armv7, arm64, x86_64）。如果开发者需要使用到模拟器来开发调试，需要使用此文件夹下的 `ZegoExpressEngine.framework`。但是最终上架 App 时，要切换回 `armv7-arm64` 文件夹下的 Framework。（注：如果使用 CocoaPods 集成则无需担心包架构问题，CocoaPods 在 Archive 时会自动裁掉模拟器架构）

> 请解压缩对应平台的 `ZegoExpressEngine.framework` 并将其放在 `iOS/Libs` 或者 `macOS/Libs` 目录下

```tree
.
├── README.md
├── README_zh.md
├── ZegoExpressExample.xcodeproj
├── iOS
│   └── Libs
│       └── ZegoExpressEngine.framework
├── macOS
│   └── Libs
│       └── ZegoExpressEngine.framework
├── Shared
├── Tests iOS
├── Tests macOS
└── Tests Shared
```

## 运行示例代码

1. 安装 Xcode: 打开 `AppStore` 搜索 `Xcode` 并下载安装。

    <img src="https://storage.zego.im/sdk-doc/Pics/iOS/ZegoExpressEngine/Common/appstore-xcode.png" width=40% height=40%>

2. 使用 Xcode 打开 `ZegoExpressExample-iOS-Swift.xcodeproj`。

    打开 Xcode，点击左上角 `File` -> `Open...`

    <img src="https://storage.zego.im/sdk-doc/Pics/iOS/ZegoExpressEngine/Common/xcode-open-file.png" width=70% height=70%>

    找到第一步下载解压得到的示例代码文件夹中的 `ZegoExpressExample-iOS-Swift.xcodeproj`，并点击 `Open`。

    <img src="https://storage.zego.im/sdk-doc/Pics/iOS/ZegoExpressEngine/Common/xcode-select-file-swift.png" width=70% height=70%>

3. 登录 Apple ID 账号。

    打开 Xcode, 点击左上角 `Xcode` -> `Preference`，选择 `Account` 选项卡，点击左下角的 `+` 号，选择添加 Apple ID。

    <img src="https://storage.zego.im/sdk-doc/Pics/iOS/ZegoExpressEngine/Common/xcode-account.png" width=90% height=90%>

    输入 Apple ID 和密码以登录。

    <img src="https://storage.zego.im/sdk-doc/Pics/iOS/ZegoExpressEngine/Common/xcode-login-apple-id.png" width=70% height=70%>

4. 修改开发者证书和 Bundle Identifier。

    打开 Xcode，点击左侧的项目 `ZegoExpressExample-iOS-Swift`

    <img src="https://storage.zego.im/sdk-doc/Pics/iOS/ZegoExpressEngine/Common/xcode-select-project-swift.png" width=50% height=50%>

    在 `General` 选项卡中，更改 `Bundle Identifier`（可修改为 `com.your-name.ZegoExpressExample-iOS-Swift`）

    <img src="https://storage.zego.im/sdk-doc/Pics/iOS/ZegoExpressEngine/Common/bundle-identifier-swift.png" width=90% height=90%>

    点击 `Signing & Capabilities` 选项卡，在 `Team` 中选择自己的开发者证书

    <img src="https://storage.zego.im/sdk-doc/Pics/iOS/ZegoExpressEngine/Common/team-signing-swift.png" width=90% height=90%>

5. 下载的示例代码中缺少 SDK 初始化必须的 AppID 和 AppSign，请参考 [获取 AppID 和 AppSign 指引](https://doc.zego.im/API/HideDoc/GetExpressAppIDGuide/GetAppIDGuideline.html) 获取 AppID 和 AppSign。如果没有填写正确的 AppID 和 AppSign，源码无法正常跑起来，所以需要修改 `ZegoExpressExample-iOS-Swift/Helper` 目录下的 `KeyCenter.swift`，填写正确的 AppID 和 AppSign。

    <img src="https://storage.zego.im/sdk-doc/Pics/iOS/ZegoExpressEngine/Common/appid-appsign-swift.png" width=80% height=80%>

6. 将 iOS 设备连接到电脑，点击 Xcode 左上角的 `🔨 Generic iOS Device` 选择该 iOS 设备（或者模拟器）

    <img src="https://storage.zego.im/sdk-doc/Pics/iOS/ZegoExpressEngine/Common/xcode-select-device.png" width=80% height=80%>

    <img src="https://storage.zego.im/sdk-doc/Pics/iOS/ZegoExpressEngine/Common/xcode-select-real-device.png" width=80% height=80%>

7. 点击 Xcode 左上角的 Build 按钮进行编译和运行。

    <img src="https://storage.zego.im/sdk-doc/Pics/iOS/ZegoExpressEngine/Common/build-and-run-swift.png" width=50% height=50%>

## 常见问题

1. `The app ID "im.zego.ZegoExpressExample-iOS-OC" cannot be registered to your development team. Change your bundle identifier to a unique string to try again.`

    参考上面的 **修改开发者证书和 Bundle Identifier**，在 `Targets` -> `Signing & Capabilities` 中切换为自己的开发证书并修改 `Bundle Identifier` 后再运行。

2. `dyld: Library not loaded`

    此为 iOS 13.3.1 的 [bug](https://forums.developer.apple.com/thread/128435)，请升级至 iOS 13.4 或以上版本即可解决。
