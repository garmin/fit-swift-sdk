/////////////////////////////////////////////////////////////////////////////////////////////
// Copyright 2025 Garmin International, Inc.
// Licensed under the Flexible and Interoperable Data Transfer (FIT) Protocol License; you
// may not use this file except in compliance with the Flexible and Interoperable Data
// Transfer (FIT) Protocol License.
/////////////////////////////////////////////////////////////////////////////////////////////


import XCTest
@testable import FITSwiftSDK

final class FitListenerTests: XCTestCase {
    
    func test_onMesg_whenPassedMessages_populatesFitMessages() throws {
        let fitListener = FitListener()
        
        let fileIdMesgGarmin = FileIdMesg()
        try fileIdMesgGarmin.setManufacturer(.garmin)
        fitListener.onMesg(fileIdMesgGarmin)
        
        let fileIdMesgDynastream = FileIdMesg()
        try fileIdMesgDynastream.setManufacturer(.dynastream)
        fitListener.onMesg(fileIdMesgDynastream)
        
        XCTAssertEqual(fileIdMesgGarmin, fitListener.fitMessages.fileIdMesgs[0])
        XCTAssertEqual(fileIdMesgDynastream, fitListener.fitMessages.fileIdMesgs[1])
    }
    
    func test_onDescription_whenPassedDeveloperFieldDescriptions_populatesFitMessages() throws {
        let fitListener = FitListener()
        
        let developerFieldDescription = DeveloperFieldDescription(developerDataIdMesg: DeveloperDataIdMesg(), fieldDescriptionMesg: FieldDescriptionMesg())
        fitListener.onDescription(developerFieldDescription)
        
        XCTAssertEqual(developerFieldDescription, fitListener.fitMessages.developerFieldDescriptionMesgs[0])
    }
}
