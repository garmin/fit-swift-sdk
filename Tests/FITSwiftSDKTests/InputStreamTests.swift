/////////////////////////////////////////////////////////////////////////////////////////////
// Copyright 2025 Garmin International, Inc.
// Licensed under the Flexible and Interoperable Data Transfer (FIT) Protocol License; you
// may not use this file except in compliance with the Flexible and Interoperable Data
// Transfer (FIT) Protocol License.
/////////////////////////////////////////////////////////////////////////////////////////////


import XCTest
@testable import FITSwiftSDK

final class InputStreamTests: XCTestCase {
    
    func test_readNumericAndString_fromStream_returnsExpectedValues() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileShort)
        
        XCTAssertEqual(try stream.readNumeric(), 0x0E as UInt8)
        XCTAssertEqual(try stream.readNumeric(), 0x20 as UInt8)
        XCTAssertEqual(try stream.readNumeric(), 0x088B as UInt16)
        XCTAssertEqual(try stream.readNumeric(), 0x00000024 as UInt32)
        XCTAssertEqual(try stream.readString(size:4), ".FIT")
        XCTAssertEqual(try stream.readNumeric(), 0xA38E as UInt16)
        
        try stream.seek(position: 0x0E + 0x00000024)
        
        XCTAssertEqual(stream.hasBytesAvailable, true)
        XCTAssertEqual(try stream.readNumeric(), 0xF25D as UInt16)
        
        XCTAssertEqual(stream.hasBytesAvailable, false)
    }
    
    func test_readNumeric_whenNotEnoughBytesRemaining_throwsError() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileShort)
        
        XCTAssertEqual(try stream.readNumeric(), 0x0E as UInt8)
        XCTAssertEqual(try stream.readNumeric(), 0x20 as UInt8)
        XCTAssertEqual(try stream.readNumeric(), 0x088B as UInt16)
        XCTAssertEqual(try stream.readNumeric(), 0x00000024 as UInt32)
        XCTAssertEqual(try stream.readString(size:4), ".FIT")
        XCTAssertEqual(try stream.readNumeric(), 0xA38E as UInt16)
        
        try stream.seek(position: 0x0E + 0x00000024)
        
        XCTAssertEqual(stream.hasBytesAvailable, true)
        XCTAssertEqual(try stream.readNumeric(), 0xF25D as UInt16)
        
        XCTAssertEqual(stream.hasBytesAvailable, false)
        
        XCTAssertThrowsError(try stream.readNumeric() as UInt64) { (error) in
            switch error {
            case FITSwiftSDK.InputStream.InputStreamError.numberOfBytesProvidedIsLongerThanNumberOfBytesRemaining:
                return
            default:
                XCTFail("Unexpected error thrown")
            }
        }
    }
    
    func test_readString_returnsExpectedString() throws {
        let testStringData = Data(fitFileShort)
        let stream = FITSwiftSDK.InputStream(data: testStringData)
        try stream.seek(position: 8)
        
        XCTAssertEqual(try stream.readString(size:4), ".FIT")
    }
    
    func test_readString_whenNotEnoughBytesRemaining_throwsError() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileShort)
        
        XCTAssertEqual(try stream.readNumeric(), 0x0E as UInt8)
        XCTAssertEqual(try stream.readNumeric(), 0x20 as UInt8)
        XCTAssertEqual(try stream.readNumeric(), 0x088B as UInt16)
        XCTAssertEqual(try stream.readNumeric(), 0x00000024 as UInt32)
        XCTAssertEqual(try stream.readString(size:4), ".FIT")
        XCTAssertEqual(try stream.readNumeric(), 0xA38E as UInt16)
        
        try stream.seek(position: 0x0E + 0x00000024)
        
        XCTAssertEqual(stream.hasBytesAvailable, true)
        XCTAssertEqual(try stream.readNumeric(), 0xF25D as UInt16)
        
        XCTAssertEqual(stream.hasBytesAvailable, false)
        
        XCTAssertThrowsError(try stream.readString(size:4)) { (error) in
            switch error {
            case FITSwiftSDK.InputStream.InputStreamError.numberOfBytesProvidedIsLongerThanNumberOfBytesRemaining:
                return
            default:
                XCTFail("Unexpected error thrown")
            }
        }
    }
    
    func test_reset_whenPositionNot0_resetsStreamPosition() throws {
        let testStringData = Data(fitFileShort)
        let stream = FITSwiftSDK.InputStream(data: testStringData)
        
        XCTAssertEqual(try stream.readNumeric(), 0x0E as UInt8)
        XCTAssertEqual(stream.position, 1)

        try stream.reset()
        
        XCTAssertEqual(stream.position, 0)
        XCTAssertEqual(try stream.readNumeric(), 0x0E as UInt8)
    }
    
    func test_seek_whenWithinRange_setsStreamToExpectedPosition() throws {
        let testStringData = Data(fitFileShort)
        let stream = FITSwiftSDK.InputStream(data: testStringData)
        try stream.seek(position: 8)
        
        XCTAssertEqual(stream.position, 8)
        XCTAssertEqual(try stream.readNumeric(), 0x2E as UInt8)
    }
    
    func test_seek_whenPositionExceedsStreamSize_throwsError() throws {
        let testStringData = Data(fitFileShort)
        let stream = FITSwiftSDK.InputStream(data: testStringData)
        
        XCTAssertThrowsError( try stream.seek(position: 255)) { (error) in
            switch error {
            case FITSwiftSDK.InputStream.InputStreamError.positionIndexOutOfRange:
                return
            default:
                XCTFail("Unexpected error thrown")
            }
        }
    }
    
    func test_reset_afterSeek_resetsStreamPosition() throws {
        let testStringData = Data(fitFileShort)
        
        let stream = FITSwiftSDK.InputStream(data: testStringData)
        XCTAssertEqual(stream.position, 0)
        
        try stream.seek(position: 8)
        XCTAssertEqual(stream.position, 8)
        
        try stream.reset()
        XCTAssertEqual(stream.position, 0)
    }
    
    func test_hasBytesAvailable_whenEndOfFile_returnsFalse() throws {
        let stream = FITSwiftSDK.InputStream(data: Data([0x00, 0x01, 0x02, 0x03]))
        XCTAssertEqual(stream.hasBytesAvailable, true)
        
        try stream.seek(position: 3)
        XCTAssertEqual(stream.hasBytesAvailable, true)
        
        let _ = stream.peekByte()
        XCTAssertEqual(stream.hasBytesAvailable, true)
        
        let _ = try stream.readNumeric() as UInt8
        XCTAssertEqual(stream.hasBytesAvailable, false)
        
        try stream.reset()
        XCTAssertEqual(stream.hasBytesAvailable, true)
    }
    
    func test_readNumeric_whenValueIsInvalidEnum_baseTypeInvalidEqualsValueAndIsInvalid() throws {
        let stream = FITSwiftSDK.InputStream(data: Data(BaseType.ENUM.invalidBytes))
        
        let value: UInt8 = try stream.readNumeric()
        
        XCTAssertTrue(BaseType.ENUM.isInvalid(value))
        XCTAssertFalse(BaseType.ENUM.isValid(value))
        XCTAssertEqual(value,  BaseType.ENUM.invalidValue())
    }
    
    func test_readNumeric_whenValueIsInvalidUInt8_baseTypeInvalidEqualsValueAndIsInvalid() throws {
        let stream = FITSwiftSDK.InputStream(data: Data(BaseType.UINT8.invalidBytes))
        
        let value: UInt8 = try stream.readNumeric()
        
        XCTAssertTrue(BaseType.UINT8.isInvalid(value))
        XCTAssertFalse(BaseType.UINT8.isValid(value))
        XCTAssertEqual(value,  BaseType.UINT8.invalidValue())
    }
    
    func test_readNumeric_whenValueIsInvalidUInt16_baseTypeInvalidEqualsValueAndIsInvalid() throws {
        let stream = FITSwiftSDK.InputStream(data: Data(BaseType.UINT16.invalidBytes))
        
        let value: UInt16 = try stream.readNumeric()
        
        XCTAssertTrue(BaseType.UINT16.isInvalid(value))
        XCTAssertFalse(BaseType.UINT16.isValid(value))
        XCTAssertEqual(value,  BaseType.UINT16.invalidValue())
    }
    
    func test_readNumeric_whenValueIsInvalidUInt32_baseTypeInvalidEqualsValueAndIsInvalid() throws {
        let stream = FITSwiftSDK.InputStream(data: Data(BaseType.UINT32.invalidBytes))
        
        let value: UInt32 = try stream.readNumeric()
        
        XCTAssertTrue(BaseType.UINT32.isInvalid(value))
        XCTAssertFalse(BaseType.UINT32.isValid(value))
        XCTAssertEqual(value,  BaseType.UINT32.invalidValue())
    }
    
    func test_readNumeric_whenValueIsInvalidUInt64_baseTypeInvalidEqualsValueAndIsInvalid() throws {
        let stream = FITSwiftSDK.InputStream(data: Data(BaseType.UINT64.invalidBytes))
        
        let value: UInt64 = try stream.readNumeric()
        
        XCTAssertTrue(BaseType.UINT64.isInvalid(value))
        XCTAssertFalse(BaseType.UINT64.isValid(value))
        XCTAssertEqual(value,  BaseType.UINT64.invalidValue())
    }
    
    func test_readNumeric_whenValueIsInvalidInt8_baseTypeInvalidEqualsValueAndIsInvalid() throws {
        let stream = FITSwiftSDK.InputStream(data: Data(BaseType.SINT8.invalidBytes))
        
        let value: Int8 = try stream.readNumeric()
        
        XCTAssertTrue(BaseType.SINT8.isInvalid(value))
        XCTAssertFalse(BaseType.SINT8.isValid(value))
        XCTAssertEqual(value,  BaseType.SINT8.invalidValue())
    }
    
    func test_readNumeric_whenValueIsInvalidInt16_baseTypeInvalidEqualsValueAndIsInvalid() throws {
        let stream = FITSwiftSDK.InputStream(data: Data(BaseType.SINT16.invalidBytes))
        
        let value: Int16 = try stream.readNumeric()
        
        XCTAssertTrue(BaseType.SINT16.isInvalid(value))
        XCTAssertFalse(BaseType.SINT16.isValid(value))
        XCTAssertEqual(value,  BaseType.SINT16.invalidValue())
    }
    
    func test_readNumeric_whenValueIsInvalidInt32_baseTypeInvalidEqualsValueAndIsInvalid() throws {
        let stream = FITSwiftSDK.InputStream(data: Data(BaseType.SINT32.invalidBytes))
        
        let value: Int32 = try stream.readNumeric()
        
        XCTAssertTrue(BaseType.SINT32.isInvalid(value))
        XCTAssertFalse(BaseType.SINT32.isValid(value))
        XCTAssertEqual(value,  BaseType.SINT32.invalidValue())
    }
    
    func test_readNumeric_whenValueIsInvalidInt64_baseTypeInvalidEqualsValueAndIsInvalid() throws {
        let stream = FITSwiftSDK.InputStream(data: Data(BaseType.SINT64.invalidBytes))
        
        let value: Int64 = try stream.readNumeric()
        
        XCTAssertTrue(BaseType.SINT64.isInvalid(value))
        XCTAssertFalse(BaseType.SINT64.isValid(value))
        XCTAssertEqual(value,  BaseType.SINT64.invalidValue())
    }
    
    
    func test_readNumeric_whenValueIsInvalidFloat32_baseTypeInvalidEqualsValueAndIsInvalid() throws {
        let stream = FITSwiftSDK.InputStream(data: Data(BaseType.FLOAT32.invalidBytes))
        
        let value: Float32 = try stream.readNumeric()
        
        XCTAssertTrue(BaseType.FLOAT32.isInvalid(value))
        XCTAssertFalse(BaseType.FLOAT32.isValid(value))
        XCTAssertTrue(value.isNaN)
    }
    
    func test_readNumeric_whenValueIsInvalidFloat64_baseTypeInvalidEqualsValueAndIsInvalid() throws {
        let stream = FITSwiftSDK.InputStream(data: Data(BaseType.FLOAT64.invalidBytes))
        
        let value: Float64 = try stream.readNumeric()
        
        XCTAssertTrue(BaseType.FLOAT64.isInvalid(value))
        XCTAssertFalse(BaseType.FLOAT64.isValid(value))
        XCTAssertTrue(value.isNaN)
    }
    
    func test_readNumeric_equivalentLittleEndianAndBigEndianValues_AreEqual() throws {
        let stream = FITSwiftSDK.InputStream(data: Data([0xAB, 0xCD]))
        
        let littleEndianValue: UInt16 = 0xCDAB
        let bigEndianValue: UInt16 = 0xABCD
        
        var readValue = try stream.readNumeric(endianness: Endianness.little) as UInt16
        XCTAssertEqual(readValue, littleEndianValue)
        
        try stream.reset()
        
        readValue = try stream.readNumeric(endianness: Endianness.big) as UInt16
        XCTAssertEqual(readValue, bigEndianValue)
    }

    func test_count_whenStreamIsEmpty_returns0Bytes() throws {
        let stream = FITSwiftSDK.InputStream(data: Data([]))
        
        XCTAssertEqual(stream.count, 0)
    }
    
    func test_subscript_whenSingleIndex_returnsExpectedSingleValue() throws {
        let stream = FITSwiftSDK.InputStream(data: Data([0x00, 0x01, 0x02, 0x03]))
        
        XCTAssertEqual(stream[0], 0)
        XCTAssertEqual(stream[1], 1)
        XCTAssertEqual(stream[2], 2)
        XCTAssertEqual(stream[3], 3)
    }
    
    func test_subscript_whenRange_returnsExpectedSubStreams() throws {
        let stream = FITSwiftSDK.InputStream(data: Data([0x00, 0x01, 0x02, 0x03]))
        
        XCTAssertEqual(stream[0..<2], Data([0x00, 0x01]))
        XCTAssertEqual(stream[0..<3], Data([0x00, 0x01, 0x02]))
    }
    
    func test_subscript_whenClosedRange_returnsExpectedSubStreams() throws {
        let stream = FITSwiftSDK.InputStream(data: Data([0x00, 0x01, 0x02, 0x03]))
        
        XCTAssertEqual(stream[0...1], Data([0x00, 0x01]))
        XCTAssertEqual(stream[0...2], Data([0x00, 0x01, 0x02]))
    }
    
}
