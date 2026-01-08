/////////////////////////////////////////////////////////////////////////////////////////////
// Copyright 2025 Garmin International, Inc.
// Licensed under the Flexible and Interoperable Data Transfer (FIT) Protocol License; you
// may not use this file except in compliance with the Flexible and Interoperable Data
// Transfer (FIT) Protocol License.
/////////////////////////////////////////////////////////////////////////////////////////////


import XCTest
@testable import FITSwiftSDK

final class ArrayExtensionTests: XCTestCase {

    func test_toUuid_with16ByteArray_returnsValidUuid() throws {
        let byteArray: [UInt8] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
        
        let uuid = byteArray.toUuid()
        XCTAssertEqual(uuid?.uuidString, "00010203-0405-0607-0809-0A0B0C0D0E0F")
    }
    
    func test_toUuid_withNullable16ByteArray_returnsValidUuid() throws {
        let byteArray: [UInt8?] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
        
        let uuid = byteArray.toUuid()
        XCTAssertEqual(uuid?.uuidString, "00010203-0405-0607-0809-0A0B0C0D0E0F")
    }
    
    func test_toUuid_withByteArrayFewerThan16Bytes_returnsNil() throws {
        let byteArray: [UInt8] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        
        let uuid = byteArray.toUuid()
        XCTAssertNil(uuid)
    }
    
    func test_toUuid_withByteArrayMoreThan16Bytes_returnsNil() throws {
        let byteArray: [UInt8] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 17, 18]
        
        let uuid = byteArray.toUuid()
        XCTAssertNil(uuid)
    }
    
    func test_toUuid_whenArrayContainsNil_returnsNil() throws {
        let byteArray: [UInt8?] = [0, 1, 2, 3, 4, 5, 6, nil, 8, 9, 10, 11, 12, 13, 14, 15]
        
        let uuid = byteArray.toUuid()
        XCTAssertNil(uuid)
    }
}
