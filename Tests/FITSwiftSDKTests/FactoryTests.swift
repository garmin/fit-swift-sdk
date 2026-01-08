/////////////////////////////////////////////////////////////////////////////////////////////
// Copyright 2025 Garmin International, Inc.
// Licensed under the Flexible and Interoperable Data Transfer (FIT) Protocol License; you
// may not use this file except in compliance with the Flexible and Interoperable Data
// Transfer (FIT) Protocol License.
/////////////////////////////////////////////////////////////////////////////////////////////


import XCTest
@testable import FITSwiftSDK

final class FactoryTests: XCTestCase {
    
    func test_getMesg_whenMesgNumExists_returnsNewMesg() throws {
        let fileIdMesg = Factory.getMesg(mesgNum: Profile.MesgNum.fileId)
        
        XCTAssertNotNil(fileIdMesg)
        XCTAssertEqual(fileIdMesg.mesgNum, Profile.MesgNum.fileId)
        XCTAssertEqual(fileIdMesg.name, "FileId")
    }
    
    func test_getMesg_whenMesgNumUnknown_returnsNewUnknownMesg() throws {
        let mesg = Factory.getMesg(mesgNum: UInt16.max)
        
        XCTAssertNotNil(mesg)
        XCTAssertEqual(mesg.mesgNum, UInt16.max)
        XCTAssertEqual(mesg.name, "unknown")
        XCTAssertEqual(mesg.fields, [:])
    }
    
    func test_createField_whenFieldNumExistsInMesg_createsNewField() throws {
        let manufacturerField = Factory.createField(mesgNum: Profile.MesgNum.fileId, fieldNum: FileIdMesg.manufacturerFieldNum)
        
        XCTAssertNotNil(manufacturerField)
        XCTAssertEqual(manufacturerField?.name, "Manufacturer")
        XCTAssertEqual(manufacturerField?.baseType, BaseType.UINT16)
    }
    
    func test_createField_whenMesgNumUnknown_returnsNil() throws {
        let field = Factory.createField(mesgNum: UInt16.max, fieldNum: FileIdMesg.manufacturerFieldNum)
        
        XCTAssertNil(field)
    }
    
    func test_createField_whenFieldNumUnknown_returnsNil() throws {
        let field = Factory.createField(mesgNum: Profile.MesgNum.fileId, fieldNum: UInt8.max)
        
        XCTAssertNil(field)
    }
    
    func test_createDefaultField_withSpecificType_returnsDefaultFieldWithSpecifiedType() throws {
        let field = Factory.createDefaultField(fieldNum: UInt8.max, baseType: BaseType.STRING)
        
        XCTAssertNotNil(field)
        XCTAssertEqual(field.name, "unknown")
        XCTAssertEqual(field.baseType, BaseType.STRING)
    }
    
}
