/////////////////////////////////////////////////////////////////////////////////////////////
// Copyright 2025 Garmin International, Inc.
// Licensed under the Flexible and Interoperable Data Transfer (FIT) Protocol License; you
// may not use this file except in compliance with the Flexible and Interoperable Data
// Transfer (FIT) Protocol License.
/////////////////////////////////////////////////////////////////////////////////////////////


import Testing
@testable import FITSwiftSDK

@Suite struct EncoderTests {

    @Test func test_close_encoderHasReceivedNoMesgs_writesFileData() throws {
        let encoder = Encoder();
        let data = encoder.close()
        
        #expect(data.count == 16)
    }
    
    @Test func test_close_encoderHasReceivedOneMesg_writesFileData() throws {
        let encoder = Encoder();
        
        let fileIdMesg = FileIdMesg()
        try fileIdMesg.setType(.activity)
        try fileIdMesg.setTimeCreated(DateTime())
        try fileIdMesg.setProductName("Product Name")

        encoder.onMesg(fileIdMesg)
        let data = encoder.close()

        #expect(data.count == 50)
    }
}
