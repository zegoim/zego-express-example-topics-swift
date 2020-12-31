//
//  TestEngineModule.swift
//  ZegoExpressTests
//
//  Created by Patrick Fu on 2020/9/1.
//  Copyright © 2020 Zego. All rights reserved.
//

import XCTest
import ZegoExpressEngine

class TestEngineModule: XCTestCase {

    fileprivate let loginRoomID = "apple-test-engine-module-roomid-1"
    fileprivate let loginUserID = "apple-test-engine-module-userid-1"

    var expectation1: XCTestExpectation = XCTestExpectation(description: "Wait for callback")
    var expectation2: XCTestExpectation = XCTestExpectation(description: "Wait for callback")

    var eventHandler: EngineEventHandler = EngineEventHandler.init()
    var eventHandlerSub: EngineEventHandler = EngineEventHandler.init()

    class EngineEventHandler: NSObject, ZegoEventHandler {

        var closure: ((String)->Void)?
        var errorCode: Int32?
        var funcName: String?
        var roomID: String?
        var engineState: ZegoEngineState?
        var roomState: ZegoRoomState?

        func onDebugError(_ errorCode: Int32, funcName: String, info: String) {
            print("🔧 🚩 onDebugError, errorCode: \(errorCode), funcName: \(funcName), info: \(info)")
            self.errorCode = errorCode
            self.funcName = funcName
            closure?("onDebugError")
        }

        func onEngineStateUpdate(_ state: ZegoEngineState) {
            print("🔧 🚩 onEngineStateUpdate, state: \(state.rawValue)")
            self.engineState = state
            closure?("onEngineStateUpdate")
        }

        func onRoomStateUpdate(_ state: ZegoRoomState, errorCode: Int32, extendedData: [AnyHashable : Any]?, roomID: String) {
            print("🔧 🚩 onRoomStateUpdate, state: \(state.rawValue), errorCode: \(errorCode), extendedData: \(extendedData ?? ["": ""]), roomID: \(roomID)")
            self.roomState = state
            self.roomID = roomID
            self.errorCode = errorCode
            closure?("onRoomStateUpdate")
        }
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        ZegoExpressEngine.destroy(nil)
    }

    func testGetVersion() throws {
        let version = ZegoExpressEngine.getVersion()
        print("🔧 Version: \(version)")
        XCTAssert(version.starts(with: "1."), "version should start with `1.`")
    }

    func testCreateEngine() throws {

        print("🔧 createEngine, appID: \(KeyCenter.appID), appSign: \(KeyCenter.appSign)")
        ZegoExpressEngine.createEngine(withAppID: KeyCenter.appID, appSign: KeyCenter.appSign, isTestEnv: true, scenario: ZegoScenario.general, eventHandler: eventHandler)

        ZegoExpressEngine.destroy {
            // if engine create failed, it would not recv the destroy callback
            print("🔧 🚩 ZegoExpressEngine destroy ok")
            self.expectation1.fulfill()
        };
        wait(for: [expectation1], timeout: 1)
    }

    func testCreateEngineZeroAppID() throws {

        eventHandler.closure = { callbackName in
            if (callbackName == "onDebugError") {
                XCTAssert((self.eventHandler.errorCode ?? 0) == ZegoErrorCode.engineAppidZero.rawValue, "AppID cannot be zero")
                self.expectation1.fulfill()
            }
        }

        print("🔧 createEngine, appID: \(0), appSign: \(KeyCenter.appSign)")
        ZegoExpressEngine.createEngine(withAppID: 0, appSign: KeyCenter.appSign, isTestEnv: true, scenario: ZegoScenario.general, eventHandler: eventHandler)

        wait(for: [expectation1], timeout: 1)
    }

    func testCreateEngineWrongAppID() throws {

        var count = 0
        eventHandler.closure = { callbackName in

            if (callbackName == "onRoomStateUpdate") {
                if (count == 0) {
                    XCTAssert(self.eventHandler.errorCode == 0, "errorCode should be 0 in 1st callback")
                    XCTAssert(self.eventHandler.roomState == ZegoRoomState.connecting, "roomState should be connecting in 1st callback")
                } else if (count == 1) {
                    XCTAssert((self.eventHandler.errorCode ?? 0) == ZegoErrorCode.engineAppidIncorrectOrNotOnline.rawValue, "AppID incorrect")
                    XCTAssert(self.eventHandler.roomState == ZegoRoomState.disconnected, "roomState should be disconnected in 2st callback")
                    self.expectation1.fulfill()
                }
                count += 1
            }
        }

        print("🔧 createEngine, appID: \(KeyCenter.appID * 2), appSign: \(KeyCenter.appSign)")
        ZegoExpressEngine.createEngine(withAppID: KeyCenter.appID * 2, appSign: KeyCenter.appSign, isTestEnv: true, scenario: ZegoScenario.general, eventHandler: eventHandler)

        ZegoExpressEngine.shared().loginRoom(loginRoomID, user: ZegoUser.init(userID: loginUserID))

        wait(for: [expectation1], timeout: 1)
    }

    func testCreateEngineAppSignInvalidLength() throws {
        var count = 0
        eventHandler.closure = { callbackName in
            if (callbackName == "onDebugError") {
                XCTAssert((self.eventHandler.errorCode ?? 0) == ZegoErrorCode.engineAppsignInvalidLength.rawValue, "AppSign length must be 64 bytes")
                if (count == 0) {
                    self.expectation1.fulfill()
                } else if (count == 1) {
                    self.expectation2.fulfill()
                }
                count += 1
            }
        }

        var appSign = KeyCenter.appSign
        appSign.removeLast(1)

        print("🔧 createEngine, appID: \(KeyCenter.appID), appSign: \(appSign)")
        ZegoExpressEngine.createEngine(withAppID: KeyCenter.appID, appSign: appSign, isTestEnv: true, scenario: ZegoScenario.general, eventHandler: eventHandler)

        wait(for: [expectation1], timeout: 1)

        ZegoExpressEngine.destroy(nil)

        appSign = KeyCenter.appSign.appending("a")
        print("🔧 createEngine, appID: \(KeyCenter.appID), appSign: \(appSign)")
        ZegoExpressEngine.createEngine(withAppID: KeyCenter.appID, appSign: appSign, isTestEnv: true, scenario: ZegoScenario.general, eventHandler: eventHandler)

        wait(for: [expectation2], timeout: 5)
    }

    func testCreateEngineAppSignInvalidCharacter() throws {
        var count = 0
        eventHandler.closure = { callbackName in
            if (callbackName == "onDebugError") {
                XCTAssert((self.eventHandler.errorCode ?? 0) == ZegoErrorCode.engineAppsignInvalidCharacter.rawValue, "AppSign length must be 64 bytes")
                if (count == 0) {
                    self.expectation1.fulfill()
                } else if (count == 1) {
                    self.expectation2.fulfill()
                }
                count += 1
            }
        }

        var appSign = KeyCenter.appSign
        appSign.removeLast(1)
        appSign.append("@")

        print("🔧 createEngine, appID: \(KeyCenter.appID), appSign: \(appSign)")
        ZegoExpressEngine.createEngine(withAppID: KeyCenter.appID, appSign: appSign, isTestEnv: true, scenario: ZegoScenario.general, eventHandler: eventHandler)

        wait(for: [expectation1], timeout: 1)

        ZegoExpressEngine.destroy(nil)

        appSign.removeLast(1)
        appSign.append("&")
        print("🔧 createEngine, appID: \(KeyCenter.appID), appSign: \(appSign)")
        ZegoExpressEngine.createEngine(withAppID: KeyCenter.appID, appSign: appSign, isTestEnv: true, scenario: ZegoScenario.general, eventHandler: eventHandler)

        wait(for: [expectation2], timeout: 5)
    }

    func testCreateEngineWrongAppSign() throws {
        var count = 0
        eventHandler.closure = { callbackName in

            if (callbackName == "onRoomStateUpdate") {
                if (count == 0) {
                    XCTAssert(self.eventHandler.errorCode == 0, "errorCode should be 0 in 1st callback")
                    XCTAssert(self.eventHandler.roomState == ZegoRoomState.connecting, "roomState should be connecting in 1st callback")
                } else if (count == 1) {
                    XCTAssert((self.eventHandler.errorCode ?? 0) == ZegoErrorCode.engineAppsignIncorrect.rawValue, "AppSign incorrect")
                    XCTAssert(self.eventHandler.roomState == ZegoRoomState.disconnected, "roomState should be disconnected in 2st callback")
                    self.expectation1.fulfill()
                }
                count += 1
            }
        }

        var appSign = KeyCenter.appSign
        appSign.removeLast()
        appSign.append("m")
        print("🔧 createEngine, appID: \(KeyCenter.appID), appSign: \(appSign)")
        ZegoExpressEngine.createEngine(withAppID: KeyCenter.appID, appSign: appSign, isTestEnv: true, scenario: ZegoScenario.general, eventHandler: eventHandler)

        ZegoExpressEngine.shared().loginRoom(loginRoomID, user: ZegoUser.init(userID: loginUserID))

        wait(for: [expectation1], timeout: 1)
    }

    func testMultipleInvokeCreateEngine() throws {
        print("🔧 🚀 Invoke createEngine 100 * 10 times")
        measure {
            for _ in 1...100 {
                ZegoExpressEngine.createEngine(withAppID: KeyCenter.appID, appSign: KeyCenter.appSign, isTestEnv: true, scenario: ZegoScenario.general, eventHandler: eventHandler)
            }
        }
    }

    func testMultipleInvokeDestroyEngine() throws {
        print("🔧 🧨 Invoke destroyEngine 100 * 10 times")
        measure {
            for _ in 1...100 {
                ZegoExpressEngine.destroy(nil)
            }
        }
    }

    func testMultipleInvokeCreateAndDestroyEngine() throws {
        print("🔧 🔄 Invoke create/destroy 5 * 10 times")
        measure {
            for _ in 1...5 {
                ZegoExpressEngine.createEngine(withAppID: KeyCenter.appID, appSign: KeyCenter.appSign, isTestEnv: true, scenario: ZegoScenario.general, eventHandler: eventHandler)
                ZegoExpressEngine.destroy(nil)
            }
        }
    }

    func testMultipleInvokeCreateAndDestroyEngineWithWaitCallback() throws {
        print("🔧 🔄 Invoke create/destroy with wait destroy callback 5 * 10 times")
        measure {
            for _ in 1...5 {
                ZegoExpressEngine.createEngine(withAppID: KeyCenter.appID, appSign: KeyCenter.appSign, isTestEnv: true, scenario: ZegoScenario.general, eventHandler: eventHandler)
                let destroyExpectation = XCTestExpectation(description: "Wait for destroyEngine finish callback")
                ZegoExpressEngine.destroy {
                    destroyExpectation.fulfill()
                }
                wait(for: [destroyExpectation], timeout: 0.3)
            }
        }
    }

    func testMultipleInvokeSetEventHandler() throws {
        print("🔧 🧷 Invoke setEventHandler with sharedEngine 200 * 10 times")
        ZegoExpressEngine.createEngine(withAppID: KeyCenter.appID, appSign: KeyCenter.appSign, isTestEnv: true, scenario: ZegoScenario.general, eventHandler: nil)
        measure {
            for _ in 1...200 {
                ZegoExpressEngine.shared().setEventHandler(eventHandler)
                ZegoExpressEngine.shared().setEventHandler(nil)
            }
        }
    }

    func testRepeatSetEventHandler() throws {
        eventHandler.closure = { callbackName in
            if (callbackName == "onDebugError") {
                XCTAssert((self.eventHandler.errorCode ?? 0) == ZegoErrorCode.commonEventHandlerExists.rawValue, "Dont repeat set event handler")
                self.expectation1.fulfill()
            }
        }

        ZegoExpressEngine.createEngine(withAppID: KeyCenter.appID, appSign: KeyCenter.appSign, isTestEnv: true, scenario: ZegoScenario.general, eventHandler: eventHandler)
        print("🔧 🧷 setEventHandler")
        ZegoExpressEngine.shared().setEventHandler(eventHandler)

        wait(for: [expectation1], timeout: 1)
    }

}
