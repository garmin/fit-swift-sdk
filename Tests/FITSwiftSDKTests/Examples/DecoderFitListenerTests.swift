/////////////////////////////////////////////////////////////////////////////////////////////
// Copyright 2025 Garmin International, Inc.
// Licensed under the Flexible and Interoperable Data Transfer (FIT) Protocol License; you
// may not use this file except in compliance with the Flexible and Interoperable Data
// Transfer (FIT) Protocol License.
/////////////////////////////////////////////////////////////////////////////////////////////


import XCTest
import FITSwiftSDK

final class DecoderFitListenerTests: XCTestCase {

   /**
     Test decoding a FIT file using the FitListener and FitMessages classes.
     - Note: FitListener implements each message type's delegate.
     - Note: FitMessages contains a mutable array for each message type.
     - Attention: FitListener routes the decoded messages to their corresponding array in FitMessages. After the file is decoded, all of the messages will be in an instance of a FitMessages class.
     */
    
    func testDecoder() throws {
        let filename = ""

        try XCTSkipIf(filename.count == 0, "Set the name of the file from the TestData directory to be decoded.")
        
        let fileURL = URL(string: filename , relativeTo: URL(fileURLWithPath: String(testDataPath)))
        let fileData = try Data(contentsOf: fileURL!)
    
        let stream = FITSwiftSDK.InputStream(data: fileData)

        let decoder = Decoder(stream: stream)
        let fitListener = FitListener()
        decoder.addMesgListener(fitListener)

        try decoder.read();

        XCTAssertEqual(fitListener.fitMessages.fileIdMesgs.count, 1)
    }
}
