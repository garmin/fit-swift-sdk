/////////////////////////////////////////////////////////////////////////////////////////////
// Copyright 2026 Garmin International, Inc.
// Licensed under the Flexible and Interoperable Data Transfer (FIT) Protocol License; you
// may not use this file except in compliance with the Flexible and Interoperable Data
// Transfer (FIT) Protocol License.
/////////////////////////////////////////////////////////////////////////////////////////////


import XCTest
import FITSwiftSDK

final class DecoderMesgBroadcasterTests: XCTestCase {

    /**
         Test decoding a FIT file using a MessageBroadcaster and MesgListener Protocols.
         - Note: This mimics the decoding paradigm used by other FIT SDKs.
         - Note: Implement the listener protocol for each message of interest, and connect it to the Broadcaster.
    */
    func testDecoderUsingMessageBroadcaster() throws {
        let filename = ""

        try XCTSkipIf(filename.count == 0, "Set the name of the file from the TestData directory to be decoded.")
        
        let fileURL = URL(string: filename , relativeTo: URL(fileURLWithPath: String(testDataPath)))
        let fileData = try Data(contentsOf: fileURL!)
    
        let stream = FITSwiftSDK.InputStream(data: fileData)

        let decoder = Decoder(stream: stream)

        let mesgBroadcaster = MesgBroadcaster()
        let mesgListener = ExampleMesgListener()
        mesgBroadcaster.addListener(mesgListener as FileIdMesgListener)
        
        decoder.addMesgListener(mesgBroadcaster)
        try decoder.read()
        
        XCTAssertEqual(mesgListener.fitMessages.fileIdMesgs.count, 1)
    }
    
    private class ExampleMesgListener: FitListener, FileIdMesgListener {
        
        func onMesg(_ mesg: FileIdMesg) {
            super.onMesg(mesg)
        }
    }
}
