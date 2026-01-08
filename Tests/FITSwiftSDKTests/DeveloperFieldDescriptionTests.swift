/////////////////////////////////////////////////////////////////////////////////////////////
// Copyright 2025 Garmin International, Inc.
// Licensed under the Flexible and Interoperable Data Transfer (FIT) Protocol License; you
// may not use this file except in compliance with the Flexible and Interoperable Data
// Transfer (FIT) Protocol License.
/////////////////////////////////////////////////////////////////////////////////////////////


import Foundation

import XCTest
@testable import FITSwiftSDK

final class DeveloperFieldDescriptionTests: XCTestCase {

    func test_equatable_whenMesgsAreIdentical_returnsTrue() throws {
        let developerFieldDescription = DeveloperFieldDescription(developerDataIdMesg: DeveloperDataIdMesg(), fieldDescriptionMesg: FieldDescriptionMesg())
        
        let developerFieldDescriptionIdentical = DeveloperFieldDescription(developerDataIdMesg: DeveloperDataIdMesg(), fieldDescriptionMesg: FieldDescriptionMesg())
        
        XCTAssertTrue(developerFieldDescription == developerFieldDescriptionIdentical)
    }
    
    func test_equatable_whenFieldDescriptionMesgsAreDifferent_returnsFalse() throws {
        let developerFieldDescription = DeveloperFieldDescription(developerDataIdMesg: DeveloperDataIdMesg(), fieldDescriptionMesg: FieldDescriptionMesg())
        
        let fieldDescriptionMesgDifferentField = FieldDescriptionMesg()
        try fieldDescriptionMesgDifferentField.setFieldValue(fieldNum: 0, value: 10)
        let developerFieldDescriptionDifferentFieldDescriptionMesg = DeveloperFieldDescription(developerDataIdMesg:DeveloperDataIdMesg(), fieldDescriptionMesg: fieldDescriptionMesgDifferentField)
        
        XCTAssertFalse(developerFieldDescription == developerFieldDescriptionDifferentFieldDescriptionMesg)
    }
    
    func test_equatable_whenDeveloperDataIdMesgsAreDifferent_returnsFalse() throws {
        let developerFieldDescription = DeveloperFieldDescription(developerDataIdMesg: DeveloperDataIdMesg(), fieldDescriptionMesg: FieldDescriptionMesg())
        
        let developerFieldDescriptionIdentical = DeveloperFieldDescription(developerDataIdMesg: DeveloperDataIdMesg(), fieldDescriptionMesg: FieldDescriptionMesg())
        
        XCTAssertTrue(developerFieldDescription == developerFieldDescriptionIdentical)
        
        let developerDataIdMesgDifferentField = DeveloperDataIdMesg()
        try developerDataIdMesgDifferentField.setFieldValue(fieldNum: 0, value: 10)
        let developerFieldDescriptionDifferentDeveloperDataIdMesg = DeveloperFieldDescription(developerDataIdMesg: developerDataIdMesgDifferentField, fieldDescriptionMesg: FieldDescriptionMesg())
        
        XCTAssertFalse(developerFieldDescription == developerFieldDescriptionDifferentDeveloperDataIdMesg)
    }
    
    func test_getApplicationId_whenDescriptionContainsValidUuid_returnsUuid() throws {
        let developerDataIdMesg = DeveloperDataIdMesg()
        let fieldDescriptionMesg = FieldDescriptionMesg()
        let developerFieldDescription = DeveloperFieldDescription(developerDataIdMesg: developerDataIdMesg, fieldDescriptionMesg: fieldDescriptionMesg)
        
        let expectedUuid = NSUUID(uuidString: "6957fe68-83fe-4ed6-8613-413f70624bb5")
        var bytes: [UInt8] = [UInt8](repeating: 0, count: 16)
        expectedUuid?.getBytes(&bytes)
        
        for (index, value) in bytes.enumerated() {
            try developerDataIdMesg.setApplicationId(index: index, value: value)
        }
                
        let uuid = developerFieldDescription.applicationId
        
        XCTAssertEqual(uuid, expectedUuid! as UUID)
    }

    func test_getApplicationId_whenLengthOfApplicationIdIsNot16_returnsNil() throws {
        let developerDataIdMesg = DeveloperDataIdMesg()
        let fieldDescriptionMesg = FieldDescriptionMesg()
        let developerFieldDescription = DeveloperFieldDescription(developerDataIdMesg: developerDataIdMesg, fieldDescriptionMesg: fieldDescriptionMesg)
        
        for i in 0...10 {
            try developerDataIdMesg.setApplicationId(index: i, value: UInt8(i))
        }
                
        let uuid = developerFieldDescription.applicationId
        
        XCTAssertNil(uuid)
    }
}
