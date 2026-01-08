/////////////////////////////////////////////////////////////////////////////////////////////
// Copyright 2025 Garmin International, Inc.
// Licensed under the Flexible and Interoperable Data Transfer (FIT) Protocol License; you
// may not use this file except in compliance with the Flexible and Interoperable Data
// Transfer (FIT) Protocol License.
/////////////////////////////////////////////////////////////////////////////////////////////


import XCTest
@testable import FITSwiftSDK

final class FileHeaderTests: XCTestCase {

    func test_constructor_whenPassedFileWithCrc_readsCrc() throws {
        let testData = Data([0x0E, 0x20, 0x8B, 0x08, 0x24, 0x00, 0x00, 0x00, 0x2E, 0x46, 0x49, 0x54, 0x8E, 0xA3])
        let stream = FITSwiftSDK.InputStream(data: testData)
       
        let fileHeader = try FileHeader(stream: stream)
        
        XCTAssertEqual(fileHeader.headerType, .withCRC)
        XCTAssertEqual(fileHeader.headerSize, UInt8(FIT.HEADER_WITH_CRC_SIZE))
        XCTAssertEqual(fileHeader.protocolVersion, .v20)
        XCTAssertEqual(fileHeader.profileVersion, 0x088B)
        XCTAssertEqual(fileHeader.dataSize, 0x00000024)
        XCTAssertEqual(fileHeader.dataType, .fit)
        XCTAssertEqual(fileHeader.crc, 0xA38E)
    }
    
    func test_constructor_whenPassedFileWithoutCrc_setsCrcTo0x0() throws {
        let testData = Data([0x0C, 0x20, 0x8B, 0x08, 0x24, 0x00, 0x00, 0x00, 0x2E, 0x46, 0x49, 0x54])
        let stream = FITSwiftSDK.InputStream(data: testData)
       
        let fileHeader = try FileHeader(stream: stream)
        
        XCTAssertEqual(fileHeader.headerType, .withoutCRC)
        XCTAssertEqual(fileHeader.headerSize, UInt8(FIT.HEADER_WITHOUT_CRC_SIZE))
        XCTAssertEqual(fileHeader.protocolVersion, .v20)
        XCTAssertEqual(fileHeader.profileVersion, 0x088B)
        XCTAssertEqual(fileHeader.dataSize, 0x00000024)
        XCTAssertEqual(fileHeader.dataType, .fit)
        XCTAssertEqual(fileHeader.crc, 0x0)
    }
    
    func test_constructor_whenFileHeaderIsInvalid_returnsInvalidHeaderTypeAndSize() throws {
        let testData = Data([0x0, 0x20, 0x8B, 0x08, 0x24, 0x00, 0x00, 0x00, 0x2E, 0x46, 0x49, 0x54])
        let stream = FITSwiftSDK.InputStream(data: testData)
        
        let fileHeader = try FileHeader(stream: stream)
        
        XCTAssertEqual(fileHeader.headerType, .invalid)
        XCTAssertEqual(fileHeader.headerSize, 0xFF)
    }
    
    func test_bytes_whenFileHeaderIsValid_returnsAllHeaderBytes() throws {
        let headerBytes: [UInt8] = [0x0E, 0x20, 0x8B, 0x08, 0x24, 0x00, 0x00, 0x00, 0x2E, 0x46, 0x49, 0x54, 0x8E, 0xA3]
        let testData = Data(headerBytes)
        let stream = FITSwiftSDK.InputStream(data: testData)
       
        let fileHeader = try FileHeader(stream: stream)
        
        XCTAssertEqual(fileHeader.bytes, headerBytes)
    }
}
