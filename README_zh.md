# Zego Express Example Topics (Swift)

[English](README.md) | [中文](README_zh.md)

Zego Express (Swift) 示例专题 Demo (iOS + macOS)

## 下载 SDK

此 Repository 中缺少运行 Demo 工程所需的 SDK `ZegoExpressEngine.xcframework`，需要下载并放入 Demo 工程的 `Libs` 文件夹中

> 使用终端 (`Terminal`) 运行此目录下的 `DownloadSDK.sh` 脚本，脚本会自动下载最新版本的 SDK 并放入相应的目录下。

或者也可以手动通过下面的 URL 下载 SDK，解压后将 `ZegoExpressEngine.xcframework` 放在 `Libs` 目录下。

[https://storage.zego.im/express/video/apple/zego-express-video-apple.zip](https://storage.zego.im/express/video/apple/zego-express-video-apple.zip)

```tree
.
├── README.md
├── README_zh.md
├── ZegoExpressExample.xcodeproj
├── iOS
├── macOS
├── Shared
│   └── Libs
│       └── ZegoExpressEngine.xcframework
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

4. 修改开发者证书。

    打开 Xcode，点击左侧的项目 `ZegoExpressExample-iOS-Swift`

    <img src="https://storage.zego.im/sdk-doc/Pics/iOS/ZegoExpressEngine/Common/xcode-select-project-swift.png" width=50% height=50%>

    点击 `Signing & Capabilities` 选项卡，在 `Team` 中选择自己的开发者证书

    <img src="https://storage.zego.im/sdk-doc/Pics/iOS/ZegoExpressEngine/Common/team-signing-swift.png" width=90% height=90%>

    > 此示例源码自适应获取 TeamID 作为 Bundle Identifier 的后缀，开发者无需手动修改。

5. 下载的示例代码中缺少 SDK 初始化必须的 AppID 和 AppSign，请参考 [获取 AppID 和 AppSign 指引](https://doc.zego.im/API/HideDoc/GetExpressAppIDGuide/GetAppIDGuideline.html) 获取 AppID 和 AppSign。如果没有填写正确的 AppID 和 AppSign，源码无法正常跑起来，所以需要修改 `ZegoExpressExample-iOS-Swift/Helper` 目录下的 `KeyCenter.swift`，填写正确的 AppID 和 AppSign。

    <img src="https://storage.zego.im/sdk-doc/Pics/iOS/ZegoExpressEngine/Common/appid-appsign-swift.png" width=80% height=80%>

6. 将 iOS 设备连接到电脑，点击 Xcode 左上角的 `🔨 Generic iOS Device` 选择该 iOS 设备（或者模拟器）

    <img src="https://storage.zego.im/sdk-doc/Pics/iOS/ZegoExpressEngine/Common/xcode-select-device.png" width=80% height=80%>

    <img src="https://storage.zego.im/sdk-doc/Pics/iOS/ZegoExpressEngine/Common/xcode-select-real-device.png" width=80% height=80%>

7. 点击 Xcode 左上角的 Build 按钮进行编译和运行。

    <img src="https://storage.zego.im/sdk-doc/Pics/iOS/ZegoExpressEngine/Common/build-and-run-swift.png" width=50% height=50%>
