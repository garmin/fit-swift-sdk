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
        let bitStream = try BitStream(values: values, baseType: .UINT8)
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
        let bitStream = try BitStream(value: value, baseType: .UINT16)
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
        let baseType: BaseType
        let takesFastPath: Bool
        var signed: Bool = false
    }
    private static let arrayOfIntegersTestCases: [ArrayOfIntegersTestData] = [
        .init(title: "UInt8 [0xAB] - 8", values: [UInt8](arrayLiteral: 0xAB), nBitsToRead: [8], expected: [0xAB], baseType: .UINT8, takesFastPath: true),
        .init(title: "UInt8 [0xAB] - 4,4", values: [UInt8](arrayLiteral: 0xAB), nBitsToRead: [4, 4], expected: [0xB, 0xA], baseType: .UINT8, takesFastPath: false),
        .init(title: "UInt8 [0xAB] - 4,1,1,1,1", values: [UInt8](arrayLiteral: 0xAB), nBitsToRead: [4, 1, 1, 1, 1], expected: [0xB, 0x0, 0x1, 0x0, 0x1], baseType: .UINT8, takesFastPath: false),
        .init(title: "UInt8 [0xAA, 0xCB] - 16", values: [UInt8](arrayLiteral: 0xAA, 0xCB), nBitsToRead: [16], expected: [0xCBAA], baseType: .UINT8, takesFastPath: false),
        .init(title: "UInt8 [0xAA, 0xCB, 0xDE, 0xFF] - 16,16", values: [UInt8](arrayLiteral: 0xAA, 0xCB, 0xDE, 0xFF), nBitsToRead: [16, 16], expected: [0xCBAA, 0xFFDE], baseType: .UINT8, takesFastPath: false),
        .init(title: "UInt8 [0xAA, 0xCB, 0xDE, 0xFF] - 32", values: [UInt8](arrayLiteral: 0xAA, 0xCB, 0xDE, 0xFF), nBitsToRead: [32], expected: [0xFFDECBAA], baseType: .UINT8, takesFastPath: false),
        .init(title: "UInt8 [0xAA, 0xBB] - 8,8", values: [UInt8](arrayLiteral: 0xAA, 0xBB), nBitsToRead: [8, 8], expected: [0xAA, 0xBB], baseType: .UINT8, takesFastPath: true),
        .init(title: "UInt16 [0xABCD, 0xEF01] - 16,16", values: [UInt16](arrayLiteral: 0xABCD, 0xEF01), nBitsToRead: [16, 16], expected: [0xABCD, 0xEF01], baseType: .UINT16, takesFastPath: true),
        .init(title: "UInt16 [0xABCD, 0xEF01] - 32", values: [UInt16](arrayLiteral: 0xABCD, 0xEF01), nBitsToRead: [32], expected: [0xEF01ABCD], baseType: .UINT16, takesFastPath: false),
        .init(title: "UInt32 [0xABCDEF01] - 32", values: [UInt32](arrayLiteral: 0xABCDEF01), nBitsToRead: [32], expected: [0xABCDEF01], baseType: .UINT32, takesFastPath: true),
        .init(title: "UInt32 [0xABCDEF01, 0x12345678] - 32,32", values: [UInt32](arrayLiteral: 0xABCDEF01, 0x12345678), nBitsToRead: [32, 32], expected: [0xABCDEF01, 0x12345678], baseType: .UINT32, takesFastPath: true),
        .init(title: "UInt64 [0x7BCDEF0123456789] - 64", values: [UInt64](arrayLiteral: 0x7BCDEF0123456789), nBitsToRead: [64], expected: [Int64(0x7BCDEF0123456789)], baseType: .UINT64, takesFastPath: true),
        .init(title: "UInt64 [0xABCDEF0123456789] - 64", values: [UInt64](arrayLiteral: 0xABCDEF0123456789), nBitsToRead: [64], expected: [Int64(bitPattern: 0xABCDEF0123456789)], baseType: .UINT64, takesFastPath: true),
        .init(title: "UInt64 [0x7BCDEF0123456789, 0x0BCDEF0123456789] - 64,64", values: [UInt64](arrayLiteral: 0x7BCDEF0123456789, 0x0BCDEF0123456789), nBitsToRead: [64, 64], expected: [Int64(bitPattern: 0x7BCDEF0123456789), Int64(bitPattern: 0x0BCDEF0123456789)], baseType: .UINT64, takesFastPath: true),
        .init(title: "UInt64 [0xABCDEF0123456789] - 32", values: [UInt64](arrayLiteral: 0xABCDEF0123456789), nBitsToRead: [32], expected: [0x23456789], baseType: .UINT64, takesFastPath: false),
        .init(title: "UInt64 [0xABCDEF0123456789] - 32,32", values: [UInt64](arrayLiteral: 0xABCDEF0123456789), nBitsToRead: [32,32], expected: [0x23456789, 0xABCDEF01], baseType: .UINT64, takesFastPath: false),
        .init(title: "Int8 [127] - 8", values: [Int8](arrayLiteral: 127), nBitsToRead: [8], expected: [127], baseType: .SINT8, takesFastPath: true),
        .init(title: "Int8 [-1] - 8", values: [Int8](arrayLiteral: -1), nBitsToRead: [8], expected: [-1], baseType: .SINT8, takesFastPath: true, signed: true),
        .init(title: "Int8 [-1] - 4,4", values: [Int8](arrayLiteral: -1), nBitsToRead: [4, 4], expected: [15, 15], baseType: .SINT8, takesFastPath: false),
        .init(title: "Int8 [127, -1] - 8,8", values: [Int8](arrayLiteral: 127, -1), nBitsToRead: [8, 8], expected: [127, -1], baseType: .SINT8, takesFastPath: true, signed: true),
        .init(title: "Int16 [-1] - 16", values: [Int16](arrayLiteral: -1), nBitsToRead: [16], expected: [-1], baseType: .SINT16, takesFastPath: true, signed: true),
        .init(title: "Int32 [-1] - 32", values: [Int32](arrayLiteral: -1), nBitsToRead: [32], expected: [-1], baseType: .SINT32, takesFastPath: true, signed: true),
        .init(title: "Int64 [-1] - 64", values: [Int64](arrayLiteral: -1), nBitsToRead: [64], expected: [-1], baseType: .SINT64, takesFastPath: true, signed: true),
        // Pairs showing signed reads sign-extend at any width; unsigned reads preserve raw bits
        .init(title: "Int8 [-56] - 8",       values: [Int8](arrayLiteral: -56), nBitsToRead: [8],     expected: [-56],          baseType: .SINT8, takesFastPath: true, signed: true),
        .init(title: "Int8 [-56] - 4,4",     values: [Int8](arrayLiteral: -56), nBitsToRead: [4, 4],  expected: [8, 12],        baseType: .SINT8, takesFastPath: false),
        .init(title: "Int16 [-256] - 16",    values: [Int16](arrayLiteral: -256), nBitsToRead: [16],   expected: [-256],         baseType: .SINT16, takesFastPath: true, signed: true),
        .init(title: "Int16 [-256] - 8,8",   values: [Int16](arrayLiteral: -256), nBitsToRead: [8, 8], expected: [0, 255],       baseType: .SINT16, takesFastPath: false),
        .init(title: "Int32 [-1] - 16,16",   values: [Int32](arrayLiteral: -1),   nBitsToRead: [16, 16], expected: [65535, 65535], baseType: .SINT32, takesFastPath: false),
        .init(title: "Int64 [-1] - 32,32",   values: [Int64](arrayLiteral: -1),   nBitsToRead: [32, 32], expected: [4294967295, 4294967295], baseType: .SINT64, takesFastPath: false),
        // Float32: fast path uses rawBits; no sign extension for floating-point types
        .init(title: "Float32 [1.0] - 32",   values: [Float32(1.0)],              nBitsToRead: [32],   expected: [1065353216],  baseType: .FLOAT32, takesFastPath: true),
        .init(title: "Float32 [1.0] - 16,16",values: [Float32(1.0)],              nBitsToRead: [16, 16], expected: [0, 16256],  baseType: .FLOAT32, takesFastPath: false)
    ]
    @Test("ReadBits from array of integers returns expected values", arguments: arrayOfIntegersTestCases)
    func test_readBits_fromArrayOfAnyIntegers_returnsExpectedValues(test: ArrayOfIntegersTestData) throws {
        let bitStream = try BitStream(values: test.values, baseType: test.baseType)
        try assertBitStreamReadBitsIsExpected(bitStream: bitStream, nBitsToRead: test.nBitsToRead, expected: test.expected, signed: test.signed)
        #expect(bitStream.bytes.isEmpty == test.takesFastPath)
    }

    struct SingleIntegerTestData: Sendable {
        let title: String
        let value: any Numeric & Sendable
        let nBitsToRead: [Int]
        let expected: [Int64]
        let baseType: BaseType
        let takesFastPath: Bool
        var signed: Bool = false
    }
    private static let singleIntegerTestCases: [SingleIntegerTestData] = [
        .init(title: "UInt8 0xAB - 8", value: UInt8(0xAB), nBitsToRead: [8], expected: [0xAB], baseType: .UINT8, takesFastPath: true),
        .init(title: "UInt8 0xAB - 4,4", value: UInt8(0xAB), nBitsToRead: [4, 4], expected: [0xB, 0xA], baseType: .UINT8, takesFastPath: false),
        .init(title: "UInt8 0xAB - 4,1,1,1,1", value: UInt8(0xAB), nBitsToRead: [4, 1, 1, 1, 1], expected: [0xB, 0x0, 0x1, 0x0, 0x1], baseType: .UINT8, takesFastPath: false),
        .init(title: "UInt16 0xAACB - 16", value: UInt16(0xAACB), nBitsToRead: [16], expected: [0xAACB], baseType: .UINT16, takesFastPath: true),
        .init(title: "UInt32 0xABCDEF01 - 16,16", value: UInt32(0xABCDEF01), nBitsToRead: [16, 16], expected: [0xEF01, 0xABCD], baseType: .UINT32, takesFastPath: false),
        .init(title: "UInt32 0xABCDEF01 - 32", value: UInt32(0xABCDEF01), nBitsToRead: [32], expected: [0xABCDEF01], baseType: .UINT32, takesFastPath: true),
        .init(title: "UInt64 0x7BCDEF0123456789 - 64", value: UInt64(0x7BCDEF0123456789), nBitsToRead: [64], expected: [0x7BCDEF0123456789], baseType: .UINT64, takesFastPath: true),
        .init(title: "UInt64 0xABCDEF0123456789 - 64", value: UInt64(0xABCDEF0123456789), nBitsToRead: [64], expected: [Int64(bitPattern: 0xABCDEF0123456789)], baseType: .UINT64, takesFastPath: true),
        .init(title: "UInt64 0xABCDEF0123456789 - 32", value: UInt64(0xABCDEF0123456789), nBitsToRead: [32], expected: [0x23456789], baseType: .UINT64, takesFastPath: false),
        .init(title: "UInt64 0xABCDEF0123456789 - 32,32", value: UInt64(0xABCDEF0123456789), nBitsToRead: [32, 32], expected: [0x23456789, 0xABCDEF01], baseType: .UINT64, takesFastPath: false),
        .init(title: "Int8 127 - 8", value: Int8(127), nBitsToRead: [8], expected: [127], baseType: .SINT8, takesFastPath: true),
        .init(title: "Int8 -1 - 8", value: Int8(-1), nBitsToRead: [8], expected: [-1], baseType: .SINT8, takesFastPath: true, signed: true),
        .init(title: "Int8 -1 - 4,4", value: Int8(-1), nBitsToRead: [4, 4], expected: [15, 15], baseType: .SINT8, takesFastPath: false),
        .init(title: "Int16 -1 - 16", value: Int16(-1), nBitsToRead: [16], expected: [-1], baseType: .SINT16, takesFastPath: true, signed: true),
        .init(title: "Int32 -1 - 32", value: Int32(-1), nBitsToRead: [32], expected: [-1], baseType: .SINT32, takesFastPath: true, signed: true),
        .init(title: "Int64 -1 - 64", value: Int64(-1), nBitsToRead: [64], expected: [-1], baseType: .SINT64, takesFastPath: true, signed: true),
        // Pairs showing signed reads sign-extend at any width; unsigned reads preserve raw bits
        .init(title: "Int8 -56 - 8",       value: Int8(-56),    nBitsToRead: [8],      expected: [-56],          baseType: .SINT8, takesFastPath: true, signed: true),
        .init(title: "Int8 -56 - 4,4",     value: Int8(-56),    nBitsToRead: [4, 4],   expected: [8, 12],        baseType: .SINT8, takesFastPath: false),
        .init(title: "Int16 -256 - 16",    value: Int16(-256),  nBitsToRead: [16],     expected: [-256],         baseType: .SINT16, takesFastPath: true, signed: true),
        .init(title: "Int16 -256 - 8,8",   value: Int16(-256),  nBitsToRead: [8, 8],   expected: [0, 255],       baseType: .SINT16, takesFastPath: false),
        .init(title: "Int32 -1 - 16,16",   value: Int32(-1),    nBitsToRead: [16, 16], expected: [65535, 65535], baseType: .SINT32, takesFastPath: false),
        .init(title: "Int64 -1 - 32,32",   value: Int64(-1),    nBitsToRead: [32, 32], expected: [4294967295, 4294967295], baseType: .SINT64, takesFastPath: false),
        // Float32: fast path uses rawBits; no sign extension for floating-point types
        .init(title: "Float32 1.0 - 32",   value: Float32(1.0), nBitsToRead: [32],     expected: [1065353216],  baseType: .FLOAT32, takesFastPath: true),
        .init(title: "Float32 1.0 - 16,16",value: Float32(1.0), nBitsToRead: [16, 16], expected: [0, 16256],    baseType: .FLOAT32, takesFastPath: false)
    ]
    @Test("ReadBits from single integer returns expected values", arguments: singleIntegerTestCases)
    func test_readBits_fromAnyIntegers_returnsExpectedValues(test: SingleIntegerTestData) throws {
        let bitStream = try BitStream(value: test.value, baseType: test.baseType)
        try assertBitStreamReadBitsIsExpected(bitStream: bitStream, nBitsToRead: test.nBitsToRead, expected: test.expected, signed: test.signed)
        #expect(bitStream.bytes.isEmpty == test.takesFastPath)
    }

    func assertBitStreamReadBitsIsExpected(bitStream: BitStream, nBitsToRead: [Int], expected: [Int64], signed: Bool = false) throws {
        for (index, expectedValue) in expected.enumerated() {
            let actualValue = try bitStream.readBits(nBitsToRead[index], signed: signed)
            #expect(expectedValue == actualValue)
        }
    }

    // MARK: ReadBit and ReadBits Error Tests
    @Test func test_readBits_whenNoBitsAvailable_throwsError() throws {
        let value: UInt32 = 0xABCDEFFF
        
        let bitStream = try BitStream(value: value, baseType: .UINT32)
        _ = try bitStream.readBits(32, signed: false)

        #expect(throws: (any Error).self) {
            try bitStream.readBits(2, signed: false)
        }
    }
    
    @Test func test_readBit_whenNoBitsAvailable_throwsError() throws {
        let value: UInt8 = 0xAB
        
        let bitStream = try BitStream(value: value, baseType: .UINT8)
        _ = try bitStream.readBits(8, signed: false)
        
        #expect(throws: (any Error).self) {
            try bitStream.readBit()
        }
    }
    
    @Test func test_readBits_whenLengthToReadExceeds64Bits_throwsError() throws {
        let values: [UInt64] = [UInt64.max, UInt64.max]
        
        let bitStream = try BitStream(values: values, baseType: .UINT64)

        #expect(throws: (any Error).self) {
            try bitStream.readBits(65, signed: false)
        }
    }

}