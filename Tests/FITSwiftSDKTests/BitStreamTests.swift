/////////////////////////////////////////////////////////////////////////////////////////////
// Copyright 2026 Garmin International, Inc.
// Licensed under the Flexible and Interoperable Data Transfer (FIT) Protocol License; you
// may not use this file except in compliance with the Flexible and Interoperable Data
// Transfer (FIT) Protocol License.
/////////////////////////////////////////////////////////////////////////////////////////////


import Testing
@testable import FITSwiftSDK

@Suite struct BitStreamTests {

    @Test func test_readBit_whenBitStreamFromByteArray_returnsExpectedValues() throws {
        let values: [UInt8] = [0xAA, 0xFF]
        let bitStream = try BitStream(values: values, baseTypeSize: 1)
        let expectedValues: [UInt8] = [0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1]
        
        for (index, expectedvalue) in expectedValues.enumerated() {
            #expect(bitStream.hasBitsAvailable())
            #expect(bitStream.bitsAvailable == expectedValues.count - index)

            let value = try bitStream.readBit()
            #expect(expectedvalue == value)
        }
    }
    
    @Test func test_readBit_whenBitStreamFromInteger_returnsExpectedValues() throws {
        let value: UInt16 = 0xAAFF
        let bitStream = try BitStream(value: value, baseTypeSize: 2)
        let expectedValues: [UInt8] = [1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1]
        
        for (index, expectedvalue) in expectedValues.enumerated() {
            #expect(bitStream.hasBitsAvailable())
            #expect(bitStream.bitsAvailable == expectedValues.count - index)

            let value = try bitStream.readBit()
            #expect(expectedvalue == value)
        }
    }

    struct ArrayOfIntegersTestData: Sendable {
        let title: String
        let values: [any Numeric & Sendable]
        let nBitsToRead: [Int]
        let expected: [Int64]
        let baseTypeSize: Int
        let takesFastPath: Bool
    }
    @Test("ReadBits from array of integers returns expected values", arguments: [
        .init(title: "UInt8 [0xAB] - 8", values: [UInt8](arrayLiteral: 0xAB), nBitsToRead: [8], expected: [0xAB], baseTypeSize: 1, takesFastPath: true),
        .init(title: "UInt8 [0xAB] - 4,4", values: [UInt8](arrayLiteral: 0xAB), nBitsToRead: [4, 4], expected: [0xB, 0xA], baseTypeSize: 1, takesFastPath: false),
        .init(title: "UInt8 [0xAB] - 4,1,1,1,1", values: [UInt8](arrayLiteral: 0xAB), nBitsToRead: [4, 1, 1, 1, 1], expected: [0xB, 0x0, 0x1, 0x0, 0x1], baseTypeSize: 1, takesFastPath: false),
        .init(title: "UInt8 [0xAA, 0xCB] - 16", values: [UInt8](arrayLiteral: 0xAA, 0xCB), nBitsToRead: [16], expected: [0xCBAA], baseTypeSize: 1, takesFastPath: false),
        .init(title: "UInt8 [0xAA, 0xCB, 0xDE, 0xFF] - 16,16", values: [UInt8](arrayLiteral: 0xAA, 0xCB, 0xDE, 0xFF), nBitsToRead: [16, 16], expected: [0xCBAA, 0xFFDE], baseTypeSize: 1, takesFastPath: false),
        .init(title: "UInt8 [0xAA, 0xCB, 0xDE, 0xFF] - 32", values: [UInt8](arrayLiteral: 0xAA, 0xCB, 0xDE, 0xFF), nBitsToRead: [32], expected: [0xFFDECBAA], baseTypeSize: 1, takesFastPath: false),
        .init(title: "UInt8 [0xAA, 0xBB] - 8,8", values: [UInt8](arrayLiteral: 0xAA, 0xBB), nBitsToRead: [8, 8], expected: [0xAA, 0xBB], baseTypeSize: 1, takesFastPath: true),
        .init(title: "UInt16 [0xABCD, 0xEF01] - 16,16", values: [UInt16](arrayLiteral: 0xABCD, 0xEF01), nBitsToRead: [16, 16], expected: [0xABCD, 0xEF01], baseTypeSize: 2, takesFastPath: true),
        .init(title: "UInt16 [0xABCD, 0xEF01] - 32", values: [UInt16](arrayLiteral: 0xABCD, 0xEF01), nBitsToRead: [32], expected: [0xEF01ABCD], baseTypeSize: 2, takesFastPath: false),
        .init(title: "UInt32 [0xABCDEF01] - 32", values: [UInt32](arrayLiteral: 0xABCDEF01), nBitsToRead: [32], expected: [0xABCDEF01], baseTypeSize: 4, takesFastPath: true),
        .init(title: "UInt32 [0xABCDEF01, 0x12345678] - 32,32", values: [UInt32](arrayLiteral: 0xABCDEF01, 0x12345678), nBitsToRead: [32, 32], expected: [0xABCDEF01, 0x12345678], baseTypeSize: 4, takesFastPath: true),
        .init(title: "UInt64 [0x7BCDEF0123456789] - 64", values: [UInt64](arrayLiteral: 0x7BCDEF0123456789), nBitsToRead: [64], expected: [Int64(0x7BCDEF0123456789)], baseTypeSize: 8, takesFastPath: true),
        .init(title: "UInt64 [0xABCDEF0123456789] - 64", values: [UInt64](arrayLiteral: 0xABCDEF0123456789), nBitsToRead: [64], expected: [Int64(bitPattern: 0xABCDEF0123456789)], baseTypeSize: 8, takesFastPath: true),
        .init(title: "UInt64 [0x7BCDEF0123456789, 0x0BCDEF0123456789] - 64,64", values: [UInt64](arrayLiteral: 0x7BCDEF0123456789, 0x0BCDEF0123456789), nBitsToRead: [64, 64], expected: [Int64(bitPattern: 0x7BCDEF0123456789), Int64(bitPattern: 0x0BCDEF0123456789)], baseTypeSize: 8, takesFastPath: true),
        .init(title: "UInt64 [0xABCDEF0123456789] - 32", values: [UInt64](arrayLiteral: 0xABCDEF0123456789), nBitsToRead: [32], expected: [0x23456789], baseTypeSize: 8, takesFastPath: false),
        .init(title: "UInt64 [0xABCDEF0123456789] - 32,32", values: [UInt64](arrayLiteral: 0xABCDEF0123456789), nBitsToRead: [32,32], expected: [0x23456789, 0xABCDEF01], baseTypeSize: 8, takesFastPath: false)
    ] as [ArrayOfIntegersTestData])
    func test_readBits_fromArrayOfAnyIntegers_returnsExpectedValues(test: ArrayOfIntegersTestData) throws {
        let bitStream = try BitStream(values: test.values, baseTypeSize: test.baseTypeSize)
        try assertBitStreamReadBitsIsExpected(bitStream: bitStream, nBitsToRead: test.nBitsToRead, expected: test.expected)
        #expect(bitStream.bytes.isEmpty == test.takesFastPath)
    }

    struct SingleIntegerTestData: Sendable {
        let title: String
        let value: any Numeric & Sendable
        let nBitsToRead: [Int]
        let expected: [Int64]
        let baseTypeSize: Int
        let takesFastPath: Bool
    }
    @Test("ReadBits from single integer returns expected values", arguments: [
        .init(title: "UInt8 0xAB - 8", value: UInt8(0xAB), nBitsToRead: [8], expected: [0xAB], baseTypeSize: 1, takesFastPath: true),
        .init(title: "UInt8 0xAB - 4,4", value: UInt8(0xAB), nBitsToRead: [4, 4], expected: [0xB, 0xA], baseTypeSize: 1, takesFastPath: false),
        .init(title: "UInt8 0xAB - 4,1,1,1,1", value: UInt8(0xAB), nBitsToRead: [4, 1, 1, 1, 1], expected: [0xB, 0x0, 0x1, 0x0, 0x1], baseTypeSize: 1, takesFastPath: false),
        .init(title: "UInt16 0xAACB - 16", value: UInt16(0xAACB), nBitsToRead: [16], expected: [0xAACB], baseTypeSize: 2, takesFastPath: true),
        .init(title: "UInt32 0xABCDEF01 - 16,16", value: UInt32(0xABCDEF01), nBitsToRead: [16, 16], expected: [0xEF01, 0xABCD], baseTypeSize: 4, takesFastPath: false),
        .init(title: "UInt32 0xABCDEF01 - 32", value: UInt32(0xABCDEF01), nBitsToRead: [32], expected: [0xABCDEF01], baseTypeSize: 4, takesFastPath: true),
        .init(title: "UInt64 0x7BCDEF0123456789 - 64", value: UInt64(0x7BCDEF0123456789), nBitsToRead: [64], expected: [0x7BCDEF0123456789], baseTypeSize: 8, takesFastPath: true),
        .init(title: "UInt64 0xABCDEF0123456789 - 64", value: UInt64(0xABCDEF0123456789), nBitsToRead: [64], expected: [Int64(bitPattern: 0xABCDEF0123456789)], baseTypeSize: 8, takesFastPath: true),
        .init(title: "UInt64 0xABCDEF0123456789 - 32", value: UInt64(0xABCDEF0123456789), nBitsToRead: [32], expected: [0x23456789], baseTypeSize: 8, takesFastPath: false),
        .init(title: "UInt64 0xABCDEF0123456789 - 32,32", value: UInt64(0xABCDEF0123456789), nBitsToRead: [32, 32], expected: [0x23456789, 0xABCDEF01], baseTypeSize: 8, takesFastPath: false)
    ] as [SingleIntegerTestData])
    func test_readBits_fromAnyIntegers_returnsExpectedValues(test: SingleIntegerTestData) throws {
        let bitStream = try BitStream(value: test.value, baseTypeSize: test.baseTypeSize)
        try assertBitStreamReadBitsIsExpected(bitStream: bitStream, nBitsToRead: test.nBitsToRead, expected: test.expected)
        #expect(bitStream.bytes.isEmpty == test.takesFastPath)
    }

    func assertBitStreamReadBitsIsExpected(bitStream: BitStream, nBitsToRead: [Int], expected: [Int64]) throws {
        for (index, expectedValue) in expected.enumerated() {
            let actualValue = try bitStream.readBits(nBitsToRead[index])
            #expect(expectedValue == actualValue)
        }
    }

    // MARK: ReadBit and ReadBits Error Tests
    @Test func test_readBits_whenNoBitsAvailable_throwsError() throws {
        let value: UInt32 = 0xABCDEFFF
        
        let bitStream = try BitStream(value: value, baseTypeSize: 4)
        _ = try bitStream.readBits(32)

        #expect(throws: (any Error).self) {
            try bitStream.readBits(2)
        }
    }
    
    @Test func test_readBit_whenNoBitsAvailable_throwsError() throws {
        let value: UInt8 = 0xAB
        
        let bitStream = try BitStream(value: value, baseTypeSize: 1)
        _ = try bitStream.readBits(8)
        
        #expect(throws: (any Error).self) {
            try bitStream.readBit()
        }
    }
    
    @Test func test_readBits_whenLengthToReadExceeds64Bits_throwsError() throws {
        let values: [UInt64] = [UInt64.max, UInt64.max]
        
        let bitStream = try BitStream(values: values, baseTypeSize: 8)

        #expect(throws: (any Error).self) {
            try bitStream.readBits(65)
        }
    }

    @Test func test_init_whenBaseTypeSizeIsZero_throwsError() {
        #expect(throws: (any Error).self) {
            try BitStream(value: UInt8(0), baseTypeSize: 0)
        }
    }

    @Test func test_init_whenBaseTypeSizeIsNegative_throwsError() {
        #expect(throws: (any Error).self) {
            try BitStream(value: UInt8(0), baseTypeSize: -1)
        }
    }
}
