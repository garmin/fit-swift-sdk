/////////////////////////////////////////////////////////////////////////////////////////////
// Copyright 2026 Garmin International, Inc.
// Licensed under the Flexible and Interoperable Data Transfer (FIT) Protocol License; you
// may not use this file except in compliance with the Flexible and Interoperable Data
// Transfer (FIT) Protocol License.
/////////////////////////////////////////////////////////////////////////////////////////////


import XCTest
@testable import FITSwiftSDK

final class MesgBroadcasterTests: XCTestCase {
    var mesgBroadcaster = MesgBroadcaster()
    var mesgListener = TestMesgListener()
    
    override func setUp() {
        mesgBroadcaster = MesgBroadcaster()
        mesgListener = TestMesgListener()
    }
    
    func test_onMesg_whenPassedMesg_sendsMesgToGenericMesgListener() throws {
        mesgBroadcaster.addListener(mesgListener as RecordMesgListener)
        
        try mesgBroadcaster.onMesg(RecordMesg())
        
        XCTAssertEqual(mesgListener.recordMesgs.count, 1)
    }
    
    func test_onMesg_afterCallingRemoveListener_preventsListenerOnMesgCallback() throws {
        mesgBroadcaster.addListener(mesgListener as RecordMesgListener)
        
        try mesgBroadcaster.onMesg(RecordMesg())
        
        XCTAssertEqual(mesgListener.recordMesgs.count, 1)
        
        // Removing the listener and calling onMesg should show the listener is disconnected
        mesgBroadcaster.removeListener(mesgListener as RecordMesgListener)
        try mesgBroadcaster.onMesg(RecordMesg())
        
        XCTAssertEqual(mesgListener.recordMesgs.count, 1)
    }

    func test_onMesg_withMoreThanOneListenerSubscribed_propagatesMessagesToAllMatchingListeners() throws {
        mesgBroadcaster.addListener(mesgListener as FileIdMesgListener)
        mesgBroadcaster.addListener(mesgListener as RecordMesgListener)
        
        // No listeners for Session messages
        try mesgBroadcaster.onMesg(SessionMesg())
        
        XCTAssertEqual(mesgListener.fileIdMesgs.count, 0)
        XCTAssertEqual(mesgListener.recordMesgs.count, 0)
        
        try mesgBroadcaster.onMesg(RecordMesg())
        
        XCTAssertEqual(mesgListener.fileIdMesgs.count, 0)
        XCTAssertEqual(mesgListener.recordMesgs.count, 1)
        
        try mesgBroadcaster.onMesg(FileIdMesg())
        
        XCTAssertEqual(mesgListener.fileIdMesgs.count, 1)
        XCTAssertEqual(mesgListener.recordMesgs.count, 1)
    }
}

final class BufferedMesgBroadcasterTests: XCTestCase {
    class TestMesgBroadcastPlugin: MesgBroadcastPlugin {
        var broadcastMesgs = [Mesg]()
        var incomingMesgs = [Mesg]()

        func onBroadcast(mesgs: inout [Mesg]) throws {
            broadcastMesgs.append(SessionMesg())
        }

        func onIncomingMesg(mesg: Mesg) {
            incomingMesgs.append(mesg)
        }
    }

    var plugin = TestMesgBroadcastPlugin()
    var bufferedMesgBroadcaster = BufferedMesgBroadcaster()

    override func setUp() async throws {
        plugin = TestMesgBroadcastPlugin()
        bufferedMesgBroadcaster = BufferedMesgBroadcaster()
        bufferedMesgBroadcaster.registerMesgBroadcastPlugin(plugin)

        bufferedMesgBroadcaster.onMesg(RecordMesg())
        bufferedMesgBroadcaster.onMesg(LapMesg())
    }

    func test_broadcast_whenCalled_broadcastsBufferedMesgs() throws {
        try bufferedMesgBroadcaster.broadcast()

        XCTAssertEqual(plugin.broadcastMesgs.count, 1)
        XCTAssertEqual(plugin.broadcastMesgs.first!.mesgNum, Profile.MesgNum.session)
    }

    func test_onMesg_whenCalled_callsPluginOnMesg() throws {
        // Broadcast hasn't been called, so list of broadcast messages should be empty
        XCTAssertEqual(plugin.broadcastMesgs.count, 0)

        XCTAssertEqual(plugin.incomingMesgs.count, 2)
        XCTAssertEqual(plugin.incomingMesgs.first!.mesgNum, Profile.MesgNum.record)
        XCTAssertEqual(plugin.incomingMesgs.last!.mesgNum, Profile.MesgNum.lap)
    }
}

