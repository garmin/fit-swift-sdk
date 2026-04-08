/////////////////////////////////////////////////////////////////////////////////////////////
// Copyright 2026 Garmin International, Inc.
// Licensed under the Flexible and Interoperable Data Transfer (FIT) Protocol License; you
// may not use this file except in compliance with the Flexible and Interoperable Data
// Transfer (FIT) Protocol License.
/////////////////////////////////////////////////////////////////////////////////////////////


import Testing
import Foundation

@testable import FITSwiftSDK

@Suite struct InputStreamTests {

    @Test func test_readNumericAndString_fromStream_returnsExpectedValues() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileShort)

        #expect(try stream.readNumeric() == 0x0E as UInt8)
        #expect(try stream.readNumeric() ==  0x20 as UInt8)
        #expect(try stream.readNumeric() ==  0x088B as UInt16)
        #expect(try stream.readNumeric() ==  0x00000024 as UInt32)
        #expect(try stream.readString(size:4) ==  ".FIT")
        #expect(try stream.readNumeric() ==  0xA38E as UInt16)

        try stream.seek(position: 0x0E + 0x00000024)

        #expect(stream.hasBytesAvailable)
        #expect(try stream.readNumeric() ==  0xF25D as UInt16)

        #expect(!stream.hasBytesAvailable)
    }

    @Test func test_readNumeric_whenNotEnoughBytesRemaining_throwsError() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileShort)

        #expect(try stream.readNumeric() ==  0x0E as UInt8)
        #expect(try stream.readNumeric() ==  0x20 as UInt8)
        #expect(try stream.readNumeric() ==  0x088B as UInt16)
        #expect(try stream.readNumeric() ==  0x00000024 as UInt32)
        #expect(try stream.readString(size:4) ==  ".FIT")
        #expect(try stream.readNumeric() ==  0xA38E as UInt16)

        try stream.seek(position: 0x0E + 0x00000024)

        #expect(stream.hasBytesAvailable)
        #expect(try stream.readNumeric() == 0xF25D as UInt16)

        #expect(!stream.hasBytesAvailable)


        #expect(throws: FITSwiftSDK.InputStream.InputStreamError.numberOfBytesProvidedIsLongerThanNumberOfBytesRemaining, performing: {try stream.readNumeric() as UInt64})
    }

    @Test func test_readString_returnsExpectedString() throws {
        let testStringData = Data(fitFileShort)
        let stream = FITSwiftSDK.InputStream(data: testStringData)
        try stream.seek(position: 8)

        #expect(try stream.readString(size:4) == ".FIT")
    }

    @Test func test_readString_whenNotEnoughBytesRemaining_throwsError() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileShort)

        #expect(try stream.readNumeric() == 0x0E as UInt8)
        #expect(try stream.readNumeric() == 0x20 as UInt8)
        #expect(try stream.readNumeric() == 0x088B as UInt16)
        #expect(try stream.readNumeric() == 0x00000024 as UInt32)
        #expect(try stream.readString(size:4) == ".FIT")
        #expect(try stream.readNumeric() == 0xA38E as UInt16)

        try stream.seek(position: 0x0E + 0x00000024)

        #expect(stream.hasBytesAvailable)
        #expect(try stream.readNumeric() == 0xF25D as UInt16)

        #expect(!stream.hasBytesAvailable)

        #expect(throws: FITSwiftSDK.InputStream.InputStreamError.numberOfBytesProvidedIsLongerThanNumberOfBytesRemaining) {
            try stream.readString(size:4)
        }
    }

    @Test func test_reset_whenPositionNot0_resetsStreamPosition() throws {
        let testStringData = Data(fitFileShort)
        let stream = FITSwiftSDK.InputStream(data: testStringData)

        #expect(try stream.readNumeric() == 0x0E as UInt8)
        #expect(stream.position == 1)

        try stream.reset()

        #expect(stream.position == 0)
        #expect(try stream.readNumeric() == 0x0E as UInt8)
    }

    @Test func test_seek_whenWithinRange_setsStreamToExpectedPosition() throws {
        let testStringData = Data(fitFileShort)
        let stream = FITSwiftSDK.InputStream(data: testStringData)
        try stream.seek(position: 8)

        #expect(stream.position == 8)
        #expect(try stream.readNumeric() == 0x2E as UInt8)
    }

    @Test func test_seek_whenPositionExceedsStreamSize_throwsError() throws {
        let testStringData = Data(fitFileShort)
        let stream = FITSwiftSDK.InputStream(data: testStringData)

        #expect(throws: FITSwiftSDK.InputStream.InputStreamError.positionIndexOutOfRange) {
            try stream.seek(position: 255)
        }
    }

    @Test func test_reset_afterSeek_resetsStreamPosition() throws {
        let testStringData = Data(fitFileShort)

        let stream = FITSwiftSDK.InputStream(data: testStringData)
        #expect(stream.position == 0)

        try stream.seek(position: 8)
        #expect(stream.position == 8)

        try stream.reset()
        #expect(stream.position == 0)
    }

    @Test func test_hasBytesAvailable_whenEndOfFile_returnsFalse() throws {
        let stream = FITSwiftSDK.InputStream(data: Data([0x00, 0x01, 0x02, 0x03]))
        #expect(stream.hasBytesAvailable)

        try stream.seek(position: 3)
        #expect(stream.hasBytesAvailable)

        let _ = stream.peekByte()
        #expect(stream.hasBytesAvailable)

        let _ = try stream.readNumeric() as UInt8
        #expect(!stream.hasBytesAvailable)

        try stream.reset()
        #expect(stream.hasBytesAvailable)
    }

    @Test func test_readNumeric_whenValueIsInvalidEnum_baseTypeInvalidEqualsValueAndIsInvalid() throws {
        let stream = FITSwiftSDK.InputStream(data: Data(BaseType.ENUM.invalidBytes))

        let value: UInt8 = try stream.readNumeric()

        #expect(BaseType.ENUM.isInvalid(value))
        #expect(!BaseType.ENUM.isValid(value))
        #expect(value == BaseType.ENUM.invalidValue())
    }

    @Test func test_readNumeric_whenValueIsInvalidUInt8_baseTypeInvalidEqualsValueAndIsInvalid() throws {
        let stream = FITSwiftSDK.InputStream(data: Data(BaseType.UINT8.invalidBytes))

        let value: UInt8 = try stream.readNumeric()

        #expect(BaseType.UINT8.isInvalid(value))
        #expect(!BaseType.UINT8.isValid(value))
        #expect(value == BaseType.UINT8.invalidValue())
    }

    @Test func test_readNumeric_whenValueIsInvalidUInt16_baseTypeInvalidEqualsValueAndIsInvalid() throws {
        let stream = FITSwiftSDK.InputStream(data: Data(BaseType.UINT16.invalidBytes))

        let value: UInt16 = try stream.readNumeric()

        #expect(BaseType.UINT16.isInvalid(value))
        #expect(!BaseType.UINT16.isValid(value))
        #expect(value == BaseType.UINT16.invalidValue())
    }

    @Test func test_readNumeric_whenValueIsInvalidUInt32_baseTypeInvalidEqualsValueAndIsInvalid() throws {
        let stream = FITSwiftSDK.InputStream(data: Data(BaseType.UINT32.invalidBytes))

        let value: UInt32 = try stream.readNumeric()

        #expect(BaseType.UINT32.isInvalid(value))
        #expect(!BaseType.UINT32.isValid(value))
        #expect(value == BaseType.UINT32.invalidValue())
    }

    @Test func test_readNumeric_whenValueIsInvalidUInt64_baseTypeInvalidEqualsValueAndIsInvalid() throws {
        let stream = FITSwiftSDK.InputStream(data: Data(BaseType.UINT64.invalidBytes))

        let value: UInt64 = try stream.readNumeric()

        #expect(BaseType.UINT64.isInvalid(value))
        #expect(!BaseType.UINT64.isValid(value))
        #expect(value == BaseType.UINT64.invalidValue())
    }

    @Test func test_readNumeric_whenValueIsInvalidInt8_baseTypeInvalidEqualsValueAndIsInvalid() throws {
        let stream = FITSwiftSDK.InputStream(data: Data(BaseType.SINT8.invalidBytes))

        let value: Int8 = try stream.readNumeric()

        #expect(BaseType.SINT8.isInvalid(value))
        #expect(!BaseType.SINT8.isValid(value))
        #expect(value == BaseType.SINT8.invalidValue())
    }

    @Test func test_readNumeric_whenValueIsInvalidInt16_baseTypeInvalidEqualsValueAndIsInvalid() throws {
        let stream = FITSwiftSDK.InputStream(data: Data(BaseType.SINT16.invalidBytes))

        let value: Int16 = try stream.readNumeric()

        #expect(BaseType.SINT16.isInvalid(value))
        #expect(!BaseType.SINT16.isValid(value))
        #expect(value == BaseType.SINT16.invalidValue())
    }

    @Test func test_readNumeric_whenValueIsInvalidInt32_baseTypeInvalidEqualsValueAndIsInvalid() throws {
        let stream = FITSwiftSDK.InputStream(data: Data(BaseType.SINT32.invalidBytes))

        let value: Int32 = try stream.readNumeric()

        #expect(BaseType.SINT32.isInvalid(value))
        #expect(!BaseType.SINT32.isValid(value))
        #expect(value == BaseType.SINT32.invalidValue())
    }

    @Test func test_readNumeric_whenValueIsInvalidInt64_baseTypeInvalidEqualsValueAndIsInvalid() throws {
        let stream = FITSwiftSDK.InputStream(data: Data(BaseType.SINT64.invalidBytes))

        let value: Int64 = try stream.readNumeric()

        #expect(BaseType.SINT64.isInvalid(value))
        #expect(!BaseType.SINT64.isValid(value))
        #expect(value == BaseType.SINT64.invalidValue())
    }

    @Test func test_readNumeric_whenValueIsInvalidFloat32_baseTypeInvalidEqualsValueAndIsInvalid() throws {
        let stream = FITSwiftSDK.InputStream(data: Data(BaseType.FLOAT32.invalidBytes))

        let value: Float32 = try stream.readNumeric()

        #expect(BaseType.FLOAT32.isInvalid(value))
        #expect(!BaseType.FLOAT32.isValid(value))
        #expect(value.isNaN)
    }

    @Test func test_readNumeric_whenValueIsInvalidFloat64_baseTypeInvalidEqualsValueAndIsInvalid() throws {
        let stream = FITSwiftSDK.InputStream(data: Data(BaseType.FLOAT64.invalidBytes))

        let value: Float64 = try stream.readNumeric()

        #expect(BaseType.FLOAT64.isInvalid(value))
        #expect(!BaseType.FLOAT64.isValid(value))
        #expect(value.isNaN)
    }

    @Test func test_readNumeric_equivalentLittleEndianAndBigEndianValues_AreEqual() throws {
        let stream = FITSwiftSDK.InputStream(data: Data([0xAB, 0xCD]))

        let littleEndianValue: UInt16 = 0xCDAB
        let bigEndianValue: UInt16 = 0xABCD

        var readValue = try stream.readNumeric(endianness: Endianness.little) as UInt16
        #expect(readValue == littleEndianValue)

        try stream.reset()

        readValue = try stream.readNumeric(endianness: Endianness.big) as UInt16
        #expect(readValue == bigEndianValue)
    }

    @Test func test_count_whenStreamIsEmpty_returns0Bytes() throws {
        let stream = FITSwiftSDK.InputStream(data: Data([]))

        #expect(stream.count == 0)
    }

    @Test func test_subscript_whenSingleIndex_returnsExpectedSingleValue() throws {
        let stream = FITSwiftSDK.InputStream(data: Data([0x00, 0x01, 0x02, 0x03]))

        #expect(stream[0] == 0)
        #expect(stream[1] == 1)
        #expect(stream[2] == 2)
        #expect(stream[3] == 3)
    }

    @Test func test_subscript_whenRange_returnsExpectedSubStreams() throws {
        let stream = FITSwiftSDK.InputStream(data: Data([0x00, 0x01, 0x02, 0x03]))

        #expect(stream[0..<2] == Data([0x00, 0x01]))
        #expect(stream[0..<3] == Data([0x00, 0x01, 0x02]))
    }

    @Test func test_subscript_whenClosedRange_returnsExpectedSubStreams() throws {
        let stream = FITSwiftSDK.InputStream(data: Data([0x00, 0x01, 0x02, 0x03]))

        #expect(stream[0...1] == Data([0x00, 0x01]))
        #expect(stream[0...2] == Data([0x00, 0x01, 0x02]))
    }

    @Test func test_skip_whenSkippingBytes_skipsCorrectNumberOfBytes() throws {
        let stream = FITSwiftSDK.InputStream(data: Data([0x00, 0x01, 0x02, 0x03]))

        try stream.skip(2)
        #expect(stream.position == 2)
    }

    @Test func test_skip_whenSkippingPastEndOfData_throwsError() throws {
        let stream = FITSwiftSDK.InputStream(data: Data([0x00, 0x01, 0x02, 0x03]))

        #expect(throws: FITSwiftSDK.InputStream.InputStreamError.positionIndexOutOfRange, performing: {
            try stream.skip(10)
        })
    }

    @Test func test_skip_whenSkipCountIsNegative_throwsError() throws {
        let stream = FITSwiftSDK.InputStream(data: Data([0x00, 0x01, 0x02, 0x03]))

        #expect(throws: FITSwiftSDK.InputStream.InputStreamError.skipCountMustBePositive, performing: {
            try stream.skip(-1)
        })
    }

}
