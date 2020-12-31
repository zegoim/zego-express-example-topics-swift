//
//  TestRoomModule.swift
//  ZegoExpressTests
//
//  Created by Patrick Fu on 2020/8/25.
//  Copyright © 2020 Zego. All rights reserved.
//

import XCTest
import ZegoExpressEngine

class TestRoomModule: XCTestCase {

    fileprivate let loginRoomID = "apple-test-room-module-roomid-1"
    fileprivate let loginUserID = "apple-test-room-module-userid-1"

    fileprivate let exceededLoginRoomID = "apple-test-room-module-roomid-too-long-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-total-129"
    fileprivate let exceededLoginUserID = "apple-test-room-module-userid-too-long-aaaaaaaaaaaaaaaaa-total-65"

    fileprivate let loginMultiRoomID = "apple-test-room-module-roomid-2"
    fileprivate let switchRoomID = "apple-test-room-module-roomid-3"
    fileprivate let switchMultiRoomID = "apple-test-room-module-roomid-4"

    fileprivate let roomExtraInfoKey = "apple-key"
    fileprivate let roomExtraInfoValue = "apple-test-room-module-room-extra-info-value"

    var expectation0: XCTestExpectation = XCTestExpectation(description: "Wait for callback")
    var expectation1: XCTestExpectation = XCTestExpectation(description: "Wait for callback")
    var expectation2: XCTestExpectation = XCTestExpectation(description: "Wait for callback")
    var expectation3: XCTestExpectation = XCTestExpectation(description: "Wait for callback")
    var expectation4: XCTestExpectation = XCTestExpectation(description: "Wait for callback")
    var expectation5: XCTestExpectation = XCTestExpectation(description: "Wait for callback")
    var expectation6: XCTestExpectation = XCTestExpectation(description: "Wait for callback")

    var eventHandler: RoomEventHandler = RoomEventHandler.init()

    class RoomEventHandler: NSObject, ZegoEventHandler {

        var closure: ((String)->Void)?

        var roomState: ZegoRoomState?
        var errorCode: Int32?
        var roomID: String?
        var funcName: String?
        var roomExtraInfoKey: String?
        var roomExtraInfoValue: String?

        func onDebugError(_ errorCode: Int32, funcName: String, info: String) {
            print("🔧 🚩 onDebugError, errorCode: \(errorCode), funcName: \(funcName), info: \(info)")
            self.errorCode = errorCode
            self.funcName = funcName
            closure?("onDebugError")
        }

        func onRoomStateUpdate(_ state: ZegoRoomState, errorCode: Int32, extendedData: [AnyHashable : Any]?, roomID: String) {
            print("🔧 🚩 onRoomStateUpdate, state: \(state.rawValue), errorCode: \(errorCode), extendedData: \(extendedData ?? ["": ""]), roomID: \(roomID)")
            self.roomState = state
            self.roomID = roomID
            self.errorCode = errorCode
            closure?("onRoomStateUpdate")
        }

        func onRoomUserUpdate(_ updateType: ZegoUpdateType, userList: [ZegoUser], roomID: String) {
            print("🔧 🚩 onRoomUserUpdate, updateType: \(updateType.rawValue), userList: \(userList), roomID: \(roomID)")
            self.roomID = roomID
            closure?("onRoomUserUpdate")
        }

        func onRoomStreamUpdate(_ updateType: ZegoUpdateType, streamList: [ZegoStream], roomID: String) {
            print("🔧 🚩 onRoomStreamUpdate, updateType: \(updateType.rawValue), streamList: \(streamList), roomID: \(roomID)")
            self.roomID = roomID
            closure?("onRoomStreamUpdate")
        }

        func onRoomExtraInfoUpdate(_ roomExtraInfoList: [ZegoRoomExtraInfo], roomID: String) {
            var allInfo = ""
            for info: ZegoRoomExtraInfo in roomExtraInfoList {
                allInfo += "k:\(info.key),v:\(info.value);"
            }
            print("🔧 🚩 onRoomExtraInfoUpdate, allInfo: \(allInfo), roomID: \(roomID)")
            self.roomID = roomID
            if (roomExtraInfoList.count >= 1) {
                self.roomExtraInfoKey = roomExtraInfoList[0].key
                self.roomExtraInfoValue = roomExtraInfoList[0].value
            }

            closure?("onRoomExtraInfoUpdate")
        }

        func onRoomStreamExtraInfoUpdate(_ streamList: [ZegoStream], roomID: String) {
            print("🔧 🚩 onRoomStreamExtraInfoUpdate, streamList: \(streamList), roomID: \(roomID)")
            self.roomID = roomID
            closure?("onRoomStreamExtraInfoUpdate")
        }

        func onRoomOnlineUserCountUpdate(_ count: Int32, roomID: String) {
            print("🔧 🚩 onRoomOnlineUserCountUpdate, count: \(count), roomID: \(roomID)")
            self.roomID = roomID
            closure?("onRoomOnlineUserCountUpdate")
        }
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        ZegoExpressEngine.createEngine(withAppID: KeyCenter.appID, appSign: KeyCenter.appSign, isTestEnv: false, scenario: ZegoScenario.general, eventHandler: eventHandler)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.

        ZegoExpressEngine.destroy {
            print("🔧 🚩 ZegoExpressEngine destroy ok")
            self.expectation0.fulfill()
        };
        wait(for: [expectation0], timeout: 1)
    }

    func testLoginRoomNormal() throws {

        var count = 0

        eventHandler.closure = { callbackName in
            if (callbackName == "onRoomStateUpdate") {
                XCTAssert(self.eventHandler.errorCode == 0, "errorCode should be 0")
                if (count == 0) {
                    XCTAssert(self.eventHandler.roomID == self.loginRoomID, "roomID should be same")
                    XCTAssert(self.eventHandler.roomState == ZegoRoomState.connecting, "roomState should be connecting in 1st callback")
                } else if (count == 1) {
                    XCTAssert(self.eventHandler.roomID == self.loginRoomID, "roomID should be same")
                    XCTAssert(self.eventHandler.roomState == ZegoRoomState.connected, "roomState should be connected in 2rd callback")
                    self.expectation1.fulfill()
                }
                count += 1
            }
        }

        print("🔧 🚪 loginRoom, roomid: \(loginRoomID), userid: \(loginUserID)")
        ZegoExpressEngine.shared().loginRoom(loginRoomID, user: ZegoUser.init(userID: loginUserID))

        wait(for: [expectation1], timeout: 5)
        print("🔧 🍺 [testLoginRoomNormal] OK!")
    }

    func testLoginRoomRoomIDExceed() throws {

        eventHandler.closure = { callbackName in
            if (callbackName == "onDebugError") {
                XCTAssert((self.eventHandler.errorCode ?? 0) == ZegoErrorCode.roomRoomidTooLong.rawValue, "roomID should not longer than 128 bytes")
                self.expectation1.fulfill()
            }
        }

        print("🔧 🚪 loginRoom, roomid: \(exceededLoginRoomID), userid: \(loginUserID)")
        ZegoExpressEngine.shared().loginRoom(exceededLoginRoomID, user: ZegoUser.init(userID: loginUserID))

        wait(for: [expectation1], timeout: 2)
        print("🔧 🍺 [testLoginRoomRoomIDExceed] OK!")
    }

    func testLoginRoomUserIDExceed() throws {

        eventHandler.closure = { callbackName in
            if (callbackName == "onDebugError") {
                XCTAssert((self.eventHandler.errorCode ?? 0) == ZegoErrorCode.roomUserIdTooLong.rawValue, "userID should not longer than 64 bytes")
                self.expectation1.fulfill()
            }
        }

        print("🔧 🚪 loginRoom, roomid: \(loginRoomID), userid: \(exceededLoginUserID)")
        ZegoExpressEngine.shared().loginRoom(loginRoomID, user: ZegoUser.init(userID: exceededLoginUserID))

        wait(for: [expectation1], timeout: 2)
        print("🔧 🍺 [testLoginRoomUserIDExceed] OK!")
    }

    func testLoginRoomAndLoginMultiRoomAndLogout() throws {

        var count = 0

        eventHandler.closure = { callbackName in
            if (callbackName == "onRoomStateUpdate") {
                XCTAssert(self.eventHandler.errorCode == 0, "errorCode should be 0")
                switch count {
                case 0:
                    XCTAssert(self.eventHandler.roomID == self.loginRoomID, "roomID should be same")
                    XCTAssert(self.eventHandler.roomState == ZegoRoomState.connecting, "roomState should be connecting in 1st callback")
                case 1:
                    XCTAssert(self.eventHandler.roomID == self.loginRoomID, "roomID should be same")
                    XCTAssert(self.eventHandler.roomState == ZegoRoomState.connected, "roomState should be connected in 2rd callback")
                    self.expectation1.fulfill()
                case 2:
                    // multi room
                    XCTAssert(self.eventHandler.roomID == self.loginMultiRoomID, "roomID should be same")
                    XCTAssert(self.eventHandler.roomState == ZegoRoomState.connecting, "roomState should be connecting in 1st callback")
                case 3:
                    // multi room
                    XCTAssert(self.eventHandler.roomID == self.loginMultiRoomID, "roomID should be same")
                    XCTAssert(self.eventHandler.roomState == ZegoRoomState.connected, "roomState should be connected in 2rd callback")
                    self.expectation2.fulfill()
                default:
                    print("⚠️ Unhandled count for `onRoomStateUpdate` in `testSwitchMainRoom`")
                }
                count += 1
            }
        }

        print("🔧 🚪 loginRoom, roomid: \(loginRoomID), userid: \(loginUserID)")
        ZegoExpressEngine.shared().loginRoom(loginRoomID, user: ZegoUser.init(userID: loginUserID))

        wait(for: [expectation1], timeout: 5)

        print("🔧 🚪 loginMultiRoom, roomid: \(loginMultiRoomID), userid: \(loginUserID)")
        ZegoExpressEngine.shared().loginMultiRoom(loginMultiRoomID, config: nil)

        wait(for: [expectation2], timeout: 5)
        print("🔧 🍺 [testLoginRoomAndLoginMultiRoomAndLogout] OK!")
    }

    func testOnlyLoginMultiRoom() throws {

        eventHandler.closure = { callbackName in
            if (callbackName == "onDebugError") {
                XCTAssert((self.eventHandler.errorCode ?? 0) == ZegoErrorCode.roomWrongLoginSequence.rawValue, "You must log in to the main room with [loginRoom] before logging in to multi room")
                self.expectation1.fulfill()
            }
        }

        print("🔧 🚪 loginMultiRoom, roomid: \(loginMultiRoomID), userid: \(loginUserID)")
        ZegoExpressEngine.shared().loginMultiRoom(loginMultiRoomID, config: nil)

        wait(for: [expectation1], timeout: 5)
        print("🔧 🍺 [testOnlyLoginMultiRoom] OK!")
    }

    func testLogoutRoomFirstWhenInMultiRoom() throws {

        eventHandler.closure = { callbackName in
            if (callbackName == "onDebugError") {
                XCTAssert((self.eventHandler.errorCode ?? 0) == ZegoErrorCode.roomWrongLogoutSequence.rawValue, "You must log out of the multi room before logging out of the main room")
                self.expectation1.fulfill()
            }
        }

        print("🔧 🚪 loginRoom, roomid: \(loginRoomID), userid: \(loginUserID)")
        ZegoExpressEngine.shared().loginRoom(loginRoomID, user: ZegoUser.init(userID: loginUserID))

        print("🔧 🚪 loginMultiRoom, roomid: \(loginMultiRoomID), userid: \(loginUserID)")
        ZegoExpressEngine.shared().loginMultiRoom(loginMultiRoomID, config: nil)

        print("🔧 🚪 logoutMultiRoom, roomid: \(loginRoomID), userid: \(loginUserID)")
        ZegoExpressEngine.shared().logoutRoom(loginRoomID)

        wait(for: [expectation1], timeout: 5)
        print("🔧 🍺 [testLogoutRoomFirstWhenInMultiRoom] OK!")
    }

    func testSwitchMainRoom() throws {
        var count = 0

        eventHandler.closure = { callbackName in
            if (callbackName == "onRoomStateUpdate") {
                XCTAssert(self.eventHandler.errorCode == 0, "errorCode should be 0")
                switch count {
                case 0:
                    // login main room
                    XCTAssert(self.eventHandler.roomID == self.loginRoomID, "roomID should be previous room")
                    XCTAssert(self.eventHandler.roomState == ZegoRoomState.connecting, "roomState should be connecting in 1st callback")
                case 1:
                    // login main room
                    XCTAssert(self.eventHandler.roomID == self.loginRoomID, "roomID should be previous room")
                    XCTAssert(self.eventHandler.roomState == ZegoRoomState.connected, "roomState should be connected in 2rd callback")
                    self.expectation1.fulfill()
                case 2:
                    // switch main room, will disconnect the previous room first
                    XCTAssert(self.eventHandler.roomID == self.loginRoomID, "roomID should be the previous room")
                    XCTAssert(self.eventHandler.roomState == ZegoRoomState.disconnected, "roomState should be disconnected in 3st callback")
                case 3:
                    // switch main room, will connecting the new room
                    XCTAssert(self.eventHandler.roomID == self.switchRoomID, "roomID should be the new room")
                    XCTAssert(self.eventHandler.roomState == ZegoRoomState.connecting, "roomState should be connected in 2rd callback")
                case 4:
                    // switch main room, new room will be connected
                    XCTAssert(self.eventHandler.roomID == self.switchRoomID, "roomID should be the new room")
                    XCTAssert(self.eventHandler.roomState == ZegoRoomState.connected, "roomState should be connected in 2rd callback")
                    self.expectation2.fulfill()
                default:
                    print("⚠️ Unhandled count for `onRoomStateUpdate` in `testSwitchMainRoom`")
                }
                count += 1
            }
        }

        print("🔧 🚪 loginRoom, roomid: \(loginRoomID), userid: \(loginUserID)")
        ZegoExpressEngine.shared().loginRoom(loginRoomID, user: ZegoUser.init(userID: loginUserID))

        wait(for: [expectation1], timeout: 5)

        print("🔧 🚪 switchRoom, fromRoomID: \(loginRoomID), toRoomID: \(switchRoomID)")
        ZegoExpressEngine.shared().switchRoom(loginRoomID, toRoomID: switchRoomID)

        wait(for: [expectation2], timeout: 5)
        print("🔧 🍺 [testSwitchMainRoom] OK!")
    }

    func testSwitchMainAndMultiRoomAndRecvRoomExtraInfo() throws {
        var count = 0
        eventHandler.closure = { callbackName in
            if (callbackName == "onRoomStateUpdate") {
                XCTAssert(self.eventHandler.errorCode == 0, "errorCode should be 0")
                switch count {
                case 0:
                    // login main room
                    XCTAssert(self.eventHandler.roomID == self.loginRoomID, "roomID should be previous room")
                    XCTAssert(self.eventHandler.roomState == ZegoRoomState.connecting, "roomState should be connecting in 1st callback")
                case 1:
                    // login main room
                    XCTAssert(self.eventHandler.roomID == self.loginRoomID, "roomID should be previous room")
                    XCTAssert(self.eventHandler.roomState == ZegoRoomState.connected, "roomState should be connected in 2rd callback")
                    self.expectation1.fulfill()

                case 2:
                    // login multi room
                    XCTAssert(self.eventHandler.roomID == self.loginMultiRoomID, "roomID should be same")
                    XCTAssert(self.eventHandler.roomState == ZegoRoomState.connecting, "roomState should be connecting in 1st callback")
                case 3:
                    // login multi room
                    XCTAssert(self.eventHandler.roomID == self.loginMultiRoomID, "roomID should be same")
                    XCTAssert(self.eventHandler.roomState == ZegoRoomState.connected, "roomState should be connected in 2rd callback")
                    self.expectation3.fulfill()

                case 4:
                    // switch main room, will disconnect the previous room first
                    XCTAssert(self.eventHandler.roomID == self.loginRoomID, "roomID should be the previous room")
                    XCTAssert(self.eventHandler.roomState == ZegoRoomState.disconnected, "roomState should be disconnected in 3st callback")
                case 5:
                    // switch main room, will connecting the new room
                    XCTAssert(self.eventHandler.roomID == self.switchRoomID, "roomID should be the new room")
                    XCTAssert(self.eventHandler.roomState == ZegoRoomState.connecting, "roomState should be connected in 2rd callback")
                case 6:
                    // switch main room, new room will be connected
                    XCTAssert(self.eventHandler.roomID == self.switchRoomID, "roomID should be the new room")
                    XCTAssert(self.eventHandler.roomState == ZegoRoomState.connected, "roomState should be connected in 2rd callback")
                    self.expectation4.fulfill()

                case 7:
                    // switch multi room, will disconnect the previous room first
                    XCTAssert(self.eventHandler.roomID == self.loginMultiRoomID, "roomID should be the previous room")
                    XCTAssert(self.eventHandler.roomState == ZegoRoomState.disconnected, "roomState should be disconnected in 3st callback")
                case 8:
                    // switch multi room, will connecting the new room
                    XCTAssert(self.eventHandler.roomID == self.loginRoomID, "roomID should be the new room")
                    XCTAssert(self.eventHandler.roomState == ZegoRoomState.connecting, "roomState should be connected in 2rd callback")
                case 9:
                    // switch multi room, new room will be connected
                    XCTAssert(self.eventHandler.roomID == self.loginRoomID, "roomID should be the new room")
                    XCTAssert(self.eventHandler.roomState == ZegoRoomState.connected, "roomState should be connected in 2rd callback")
                    self.expectation5.fulfill()
                default:
                    print("⚠️ Unhandled count for `onRoomStateUpdate` in `testSwitchRoomWhenInMultiRoom`")
                }
                count += 1
            } else if (callbackName == "onRoomExtraInfoUpdate") {
                XCTAssert(self.eventHandler.roomExtraInfoKey == self.roomExtraInfoKey)
                XCTAssert(self.eventHandler.roomExtraInfoValue == self.roomExtraInfoValue)
                self.expectation6.fulfill()
            }
        }

        print("🔧 🚪 loginRoom, roomid: \(loginRoomID), userid: \(loginUserID)")
        ZegoExpressEngine.shared().loginRoom(loginRoomID, user: ZegoUser.init(userID: loginUserID))

        wait(for: [expectation1], timeout: 5)

        print("🔧 💭 setRoomExtraInfo, key: \(self.roomExtraInfoKey), value: \(self.roomExtraInfoValue)")
        ZegoExpressEngine.shared().setRoomExtraInfo(roomExtraInfoValue, forKey: roomExtraInfoKey, roomID: loginRoomID) { (errorCode) in
            print("🔧 🚩 💭 setRoomExtraInfo result, errorCode: \(errorCode)")
            self.expectation2.fulfill()
        }

        wait(for: [expectation2], timeout: 5)

        print("🔧 🚪 loginMultiRoom, roomid: \(loginMultiRoomID), userid: \(loginUserID)")
        ZegoExpressEngine.shared().loginMultiRoom(loginMultiRoomID, config: nil)

        wait(for: [expectation3], timeout: 5)

        print("🔧 🚪 switchRoom, fromRoomID: \(loginRoomID), toRoomID: \(switchRoomID)")
        ZegoExpressEngine.shared().switchRoom(loginRoomID, toRoomID: switchRoomID)

        wait(for: [expectation4], timeout: 5)

        // Switch multi room to origin main room, expect to receive the previous room extra info
        print("🔧 🚪 switchMultiRoom, fromRoomID: \(loginMultiRoomID), toRoomID: \(loginRoomID)")
        ZegoExpressEngine.shared().switchRoom(loginMultiRoomID, toRoomID: loginRoomID)

        wait(for: [expectation5, expectation6], timeout: 5)

        print("🔧 🍺 [testSwitchMainAndMultiRoomAndRecvRoomExtraInfo] OK!")
    }
}
