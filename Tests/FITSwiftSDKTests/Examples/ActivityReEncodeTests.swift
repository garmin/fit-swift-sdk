/////////////////////////////////////////////////////////////////////////////////////////////
// Copyright 2025 Garmin International, Inc.
// Licensed under the Flexible and Interoperable Data Transfer (FIT) Protocol License; you
// may not use this file except in compliance with the Flexible and Interoperable Data
// Transfer (FIT) Protocol License.
/////////////////////////////////////////////////////////////////////////////////////////////


import XCTest
import FITSwiftSDK

final class ActivityReEncodeTests: XCTestCase {
    
    func testReEncodingActivity() throws {
        let filename = ""
        
        try XCTSkipIf(filename.count == 0, "Set the name of the file from the TestData directory to be re-encoded.")
        
        let fileURL = URL(string: filename , relativeTo: URL(fileURLWithPath: String(testDataPath)))
        let fileData = try Data(contentsOf: fileURL!)
        
        let stream = FITSwiftSDK.InputStream(data: fileData)
        
        let decoder = Decoder(stream: stream)
        let filter = RemoveExpandedComponentsFilter()
        let encoder = Encoder()

        decoder.addMesgListener(filter)
        filter.addMesgListener(encoder)

        try decoder.read()

        let encodedData = encoder.close()
        
        let reEncodedFileURL = URL(string: "ReEncoded" + filename , relativeTo: URL(fileURLWithPath: String(testDataPath)))
        try encodedData.write(to: reEncodedFileURL!)
    }
}

class RemoveExpandedComponentsFilter: MesgFilter {
    override public func onMesg(_ mesg: Mesg) throws {
        mesg.removeExpandedFields()
        try super.onMesg(mesg)
    }
}
    
