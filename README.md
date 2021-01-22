# Zego Express Example Topics (Swift)

[English](README.md) | [中文](README_zh.md)

Zego Express (Swift) Example Topics Demo (iOS + macOS)

## Download SDK

The SDK `ZegoExpressEngine.xcframework` required to run the Demo project is missing from this Repository, and needs to be downloaded and placed in the `Libs` folder of the Demo project

> You can use `Terminal` to run the `DownloadSDK.sh` script in this directory, it will automatically download the latest SDK and move it to the corresponding directory.

Or, manually download the SDK from the URL below, unzip it and put the `ZegoExpressEngine.xcframework` under `Libs`

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

## Running the sample code

1. Install Xcode: Open `AppStore`, search `Xcode`, download and install.

    <img src="https://storage.zego.im/sdk-doc/Pics/iOS/ZegoExpressEngine/Common/appstore-xcode.png" width=40% height=40%>

2. Open `ZegoExpressExample.xcodeproj` with Xcode.

    Open Xcode, and click `File` -> `Open...` in the upper left corner.

    <img src="https://storage.zego.im/sdk-doc/Pics/iOS/ZegoExpressEngine/Common/xcode-open-file.png" width=70% height=70%>

    Find the `ZegoExpressExample.xcodeproj` in the sample code folder downloaded and unzipped in the first step, and click `Open`.

    <img src="https://storage.zego.im/sdk-doc/Pics/iOS/ZegoExpressEngine/Common/xcode-select-file-swift.png" width=70% height=70%>

3. Sign in Apple ID account.

    Open Xcode, click `Xcode` -> `Preference` in the upper left corner, select the `Account` tab, click the `+` sign in the lower left corner, and select Apple ID.

    <img src="https://storage.zego.im/sdk-doc/Pics/iOS/ZegoExpressEngine/Common/xcode-account.png" width=90% height=90%>

    Enter your Apple ID and password to sign in.

    <img src="https://storage.zego.im/sdk-doc/Pics/iOS/ZegoExpressEngine/Common/xcode-login-apple-id.png" width=70% height=70%>

4. Modify Bundle Identifier and Apple Developer Certificate.

    Open Xcode, click the `ZegoExpressExample` project in left side.

    <img src="https://storage.zego.im/sdk-doc/Pics/iOS/ZegoExpressEngine/Common/xcode-select-project-swift.png" width=50% height=50%>

    Click on the `Signing & Capabilities` tab and select your developer certificate in `Team`.

    <img src="https://storage.zego.im/sdk-doc/Pics/iOS/ZegoExpressEngine/Common/team-signing-swift.png" width=90% height=90%>

    > This project adaptively obtains TeamID as the suffix of Bundle Identifier, developers do not need to modify Bundle Identifier manually.

5. The AppID and AppSign required for SDK initialization are missing from the downloaded Demo source. Please refer to [Instructions for getting AppID and AppSign](https://doc.zego.im/API/HideDoc/GetExpressAppIDGuide/GetAppIDGuideline.html) to get AppID and AppSign. If you don't fill in the correct AppID and AppSign, the source code will not run properly, so you need to modify `KeyCenter.swift` under the directory `ZegoExpressExample/Helper` to fill in the correct AppID and AppSign.

    <img src="https://storage.zego.im/sdk-doc/Pics/iOS/ZegoExpressEngine/Common/appid-appsign-swift.png" width=80% height=80%>

6. Connect your iOS device to the computer, click `🔨 Generic iOS Device` in the upper left corner of Xcode to select the iOS device (or Simulator)

    <img src="https://storage.zego.im/sdk-doc/Pics/iOS/ZegoExpressEngine/Common/xcode-select-device.png" width=80% height=80%>

    <img src="https://storage.zego.im/sdk-doc/Pics/iOS/ZegoExpressEngine/Common/xcode-select-real-device.png" width=80% height=80%>

7. Click the Build button to compile and run.

    <img src="https://storage.zego.im/sdk-doc/Pics/iOS/ZegoExpressEngine/Common/build-and-run-swift.png" width=50% height=50%>
