/////////////////////////////////////////////////////////////////////////////////////////////
// Copyright 2026 Garmin International, Inc.
// Licensed under the Flexible and Interoperable Data Transfer (FIT) Protocol License; you
// may not use this file except in compliance with the Flexible and Interoperable Data
// Transfer (FIT) Protocol License.
/////////////////////////////////////////////////////////////////////////////////////////////


import Foundation
import Testing
@testable import FITSwiftSDK

@Suite struct BaseTypeTests {

    static let stringTestData: [(String, Bool, String)] = [
        ("String - Valid", true, "This is a somewhat long string"),
        ("String - 255 bytes + NULL Terminator - Invalid", false, "AS4EgyRNHimg4Pw3bUiFQwGyOttIQti8kHzPcfoUQ1kxi4PGVpwuE7MVlfnA0PjvIdWYn"
         + "L5yDX4LmULwXFTt8jGqfafPSoL3CXmYVGaTHuB1ILbjdVtPGPm0FQPyS6NVeJ97cBYI6PoVI7wmRnc7MLS903ckhJephd"
         + "Y1OdBKJ4YRWTmhrR712BSl59SEwDs6uLHLUvWnA6JE6aVPkN2LJbI11QAtKzXNORWcK2ggsWqtsAzxSsdGyXCs6qs6CDx"),
        ("String 254 bytes + NULL Terminator - Valid", true, "这套动作由两组 4 分钟的 Tabata 训练组成，中间休息"
         + "1 分钟。对于每组 Tabata 训练，在 训练的 20 秒内尽可能多地重复完成动作，休息 "
         + "10 秒，然后重复动作总共 8 组。在 Tabata 训练中间，还有 1 分"),
        ("String 255 bytes + NULL Terminator - Invalid", false, "这套动作由两组 4 分钟的 Tabata 训练组成，中间休息"
         + "1 分钟。对于每组 Tabata 训练，在 训练的 20 秒内尽可能多地重复完成动作，休息 "
         + "10 秒，然后重复动作总共 8 组。在 Tabata 训练中间，还有 1 分."),
        ("Empty String - Invalid", false, ""),
    ]

    @Test("BaseType String validation", arguments: stringTestData)
    func isValid_whenBaseTypeIsString2(title: String, valid: Bool, string: String) {
        let baseType = BaseType.STRING

        #expect(baseType.isValid(string) == valid)
        #expect(baseType.isInvalid(string) != valid)
    }

    static let oneByteTestData: [(String, BaseType, Float64, Float64)] = [
        ("Byte Valid", BaseType.BYTE, 10.0, 10.0),
        ("Byte Max Invalid", BaseType.BYTE, Float64(UInt8.max) + 1, Float64(BaseType.BYTE.invalidValue() as UInt8)),
        ("Byte Min Invalid", BaseType.BYTE, Float64(UInt8.min) - 1, Float64(BaseType.BYTE.invalidValue() as UInt8)),
        ("Enum Valid", BaseType.ENUM, 10.0, 10.0),
        ("Enum Max Invalid", BaseType.ENUM, Float64(UInt8.max) + 1, Float64(BaseType.ENUM.invalidValue() as UInt8)),
        ("Enum Min Invalid", BaseType.ENUM, Float64(UInt8.min) - 1, Float64(BaseType.ENUM.invalidValue() as UInt8)),
        ("SInt8 Valid", BaseType.SINT8, -10.0, -10.0),
        ("SInt8 Max Invalid", BaseType.SINT8, Float64(Int8.max) + 1, Float64(BaseType.SINT8.invalidValue() as Int8)),
        ("SInt8 Min Invalid", BaseType.SINT8, Float64(Int8.min) - 1, Float64(BaseType.SINT8.invalidValue() as Int8)),
        ("UInt8 Valid", BaseType.UINT8, 10.0, 10.0),
        ("UInt8 Max Invalid", BaseType.UINT8, Float64(UInt8.max) + 1, Float64(BaseType.UINT8.invalidValue() as UInt8)),
        ("UInt8 Min Invalid", BaseType.UINT8, Float64(UInt8.min) - 1, Float64(BaseType.UINT8.invalidValue() as UInt8)),
    ]

    @Test("BaseType 1-byte validation", arguments: oneByteTestData)
    func test_correctRangeAndType_whenTypeIs1Byte(title: String, baseType: BaseType, value: Float64, expectedValue: Float64) {
        assertCorrectRangeAndTypeIsExpectedValue(baseType: baseType, value: value, expectedValue: expectedValue)
    }

    static let twoByteTestData: [(String, BaseType, Float64, Float64)] = [
        ("SInt16 Valid", BaseType.SINT16, -300.0, -300.0),
        ("SInt16 Max Invalid", BaseType.SINT16, Float64(Int16.max) + 1, Float64(BaseType.SINT16.invalidValue() as Int16)),
        ("SInt16 Min Invalid", BaseType.SINT16, Float64(Int16.min) - 1, Float64(BaseType.SINT16.invalidValue() as Int16)),
        ("UInt16 Valid", BaseType.UINT16, 10.0, 10.0),
        ("UInt16 Max Invalid", BaseType.UINT16, Float64(UInt16.max) + 1, Float64(BaseType.UINT16.invalidValue() as UInt16)),
        ("UInt16 Min Invalid", BaseType.UINT16, Float64(UInt16.min) - 1, Float64(BaseType.UINT16.invalidValue() as UInt16)),
    ]

    @Test("BaseType 2-byte validation", arguments: twoByteTestData)
    func test_correctRangeAndType_whenTypeIs2Bytes(title: String, baseType: BaseType, value: Float64, expectedValue: Float64) {
        assertCorrectRangeAndTypeIsExpectedValue(baseType: baseType, value: value, expectedValue: expectedValue)
    }

    static let fourByteIntegerTestData: [(String, BaseType, Float64, Float64)] = [
        ("SInt32 Valid", BaseType.SINT32, -5.0, -5.0),
        ("SInt32 Max Invalid", BaseType.SINT32, Float64(Int32.max) + 1, Float64(BaseType.SINT32.invalidValue() as Int32)),
        ("SInt32 Min Invalid", BaseType.SINT32, Float64(Int32.min) - 1, Float64(BaseType.SINT32.invalidValue() as Int32)),
        ("UInt32 Valid", BaseType.UINT32, 10.0, 10.0),
        ("UInt32 Max Invalid", BaseType.UINT32, Float64(UInt32.max) + 1, Float64(BaseType.UINT32.invalidValue() as UInt32)),
        ("UInt32 Min Invalid", BaseType.UINT32, Float64(UInt32.min) - 1, Float64(BaseType.UINT32.invalidValue() as UInt32)),
    ]

    @Test("BaseType 4-byte integer validation", arguments: fourByteIntegerTestData)
    func test_correctRangeAndType_whenTypeIs4ByteInteger(title: String, baseType: BaseType, value: Float64, expectedValue: Float64) {
        assertCorrectRangeAndTypeIsExpectedValue(baseType: baseType, value: value, expectedValue: expectedValue)
    }

    static let eightByteIntegerTestData: [(String, BaseType, Float64, Float64)] = [
        ("UInt64 Valid", BaseType.UINT64, 10.0, 10.0),
        ("UInt64 Max Invalid", BaseType.UINT64, Float64(fitValue: UInt64.max).nextUp, Float64(BaseType.UINT64.invalidValue() as UInt64)),
        ("UInt64 Min Invalid", BaseType.UINT64, Float64(fitValue: UInt64.min).nextDown, Float64(BaseType.UINT64.invalidValue() as UInt64)),
        ("UInt64 Min Invalid NaN", BaseType.UINT64, Float64.nan, Float64(BaseType.UINT64.invalidValue() as UInt64)),
        ("SInt64 Valid", BaseType.SINT64, -10.0, -10.0),
        ("SInt64 Max Invalid", BaseType.SINT64, Float64(fitValue: Int64.max).nextUp, Float64(BaseType.SINT64.invalidValue() as Int64)),
        ("SInt64 Min Invalid", BaseType.SINT64, Float64(fitValue: Int64.min).nextDown, Float64(BaseType.SINT64.invalidValue() as Int64)),
        ("SInt64 Min Invalid NaN", BaseType.SINT64, Float64.nan, Float64(Int64.max)),
        ("UInt64Z Valid", BaseType.UINT64Z, 0x01, 0x01),
        ("UInt64Z Max Invalid", BaseType.UINT64Z, Float64(fitValue: UInt64.max).nextUp, Float64(BaseType.UINT64Z.invalidValue() as UInt64)),
        ("UInt64Z Min Invalid", BaseType.UINT64Z, Float64(fitValue: UInt64.min).nextDown, Float64(BaseType.UINT64Z.invalidValue() as UInt64)),
        ("UInt64Z Min Invalid NaN", BaseType.UINT64Z, Float64.nan, Float64(BaseType.UINT64Z.invalidValue() as UInt64)),
    ]

    @Test("BaseType 8-byte integer validation", arguments: eightByteIntegerTestData)
    func test_correctRangeAndType_whenTypeIs8ByteInteger(title: String, baseType: BaseType, value: Float64, expectedValue: Float64) {
        assertCorrectRangeAndTypeIsExpectedValue(baseType: baseType, value: value, expectedValue: expectedValue)
    }

    static let zTypeTestData: [(String, BaseType, Float64, Float64)] = [
        ("UInt8Z Valid", BaseType.UINT8Z, 0x01, 0x01),
        ("UInt8Z Max Invalid", BaseType.UINT8Z, Float64(UInt8.max) + 1, Float64(BaseType.UINT8Z.invalidValue() as UInt8)),
        ("UInt8Z Min Invalid", BaseType.UINT8Z, Float64(UInt8.min) - 1, Float64(BaseType.UINT8Z.invalidValue() as UInt8)),
        ("UInt16Z Valid", BaseType.UINT16Z, 0x01, 0x01),
        ("UInt16Z Max Invalid", BaseType.UINT16Z, Float64(UInt16.max) + 1, Float64(BaseType.UINT16Z.invalidValue() as UInt16)),
        ("UInt16Z Min Invalid", BaseType.UINT16Z, Float64(UInt16.min) - 1, Float64(BaseType.UINT16Z.invalidValue() as UInt16)),
        ("UInt32Z Valid", BaseType.UINT32Z, 0x01, 0x01),
        ("UInt32Z Max Invalid", BaseType.UINT32Z, Float64(UInt32.max) + 1, Float64(BaseType.UINT32Z.invalidValue() as UInt32)),
        ("UInt32Z Min Invalid", BaseType.UINT32Z, Float64(UInt32.min) - 1, Float64(BaseType.UINT32Z.invalidValue() as UInt32)),
    ]

    @Test("BaseType Z-type validation", arguments: zTypeTestData)
    func test_correctRangeAndType_whenTypeIsZ(title: String, baseType: BaseType, value: Float64, expectedValue: Float64) {
        assertCorrectRangeAndTypeIsExpectedValue(baseType: baseType, value: value, expectedValue: expectedValue)
    }

    static let floatDoubleTestData: [(String, BaseType, Float64, Float64)] = [
        ("Float32 Valid", BaseType.FLOAT32, -10.0, -10.0),
        ("Float32 Min Invalid NaN", BaseType.FLOAT32, Float64(fitValue: Float32.nan), Float64(fitValue: BaseType.FLOAT32.invalidValue() as Float32)),
        ("Float32 Min Invalid Infinity", BaseType.FLOAT32, Float64(fitValue: Float32.infinity), Float64(fitValue: BaseType.FLOAT32.invalidValue() as Float32)),
        ("Float64 Valid", BaseType.FLOAT64, -10.0, -10.0),
        ("Float64 Min Invalid NaN", BaseType.FLOAT64, Float64(Float64.nan), Float64(fitValue: BaseType.FLOAT64.invalidValue() as Float64)),
        ("Float64 Min Invalid Infinity", BaseType.FLOAT64, Float64(fitValue: Float64.infinity), Float64(fitValue: BaseType.FLOAT64.invalidValue() as Float64)),
    ]

    @Test("BaseType float and double validation", arguments: floatDoubleTestData)
    func test_correctRangeAndType_whenTypeIsFloatOrDouble(title: String, baseType: BaseType, value: Float64, expectedValue: Float64) {
        assertCorrectRangeAndTypeIsExpectedValue(baseType: baseType, value: value, expectedValue: expectedValue)
    }

    @Test func test_correctRangeAndType_whenTypeIsStringAndInputIsString_returnsString() throws {
        let baseType = BaseType.STRING
        let string = "Test String"

        #expect(baseType.correctRangeAndType(string) as? String == string)
    }

    @Test func test_correctRangeAndType_whenTypeIsStringAndInputIsFloat_returnsString() throws {
        let baseType = BaseType.STRING
        let stringFloat: Float32 = 32.0

        #expect(baseType.correctRangeAndType(stringFloat) as? String == "32.0")
    }

    func assertCorrectRangeAndTypeIsExpectedValue(baseType: BaseType, value: Float64, expectedValue: Float64) {
        let result = Float64(fitValue: baseType.correctRangeAndType(value))

        if (expectedValue.isNaN) {
            #expect(result.isNaN)
        }
        else {
            #expect(result == expectedValue)
        }
    }

    struct BaseTypeFromValueTestData: Sendable {
        let title: String
        let value: any Sendable
        let expected: BaseType
    }
    @Test("BaseType from any value returns correct BaseType", arguments: [
        .init(title: "UInt8", value: UInt8.max, expected: .UINT8),
        .init(title: "UInt16", value: UInt16.max, expected: .UINT16),
        .init(title: "UInt32", value: UInt32.max, expected: .UINT32),
        .init(title: "UInt64", value: UInt64.max, expected: .UINT64),
        .init(title: "Int8", value: Int8.max, expected: .SINT8),
        .init(title: "Int16", value: Int16.max, expected: .SINT16),
        .init(title: "Int32", value: Int32.max, expected: .SINT32),
        .init(title: "Int64", value: Int64.max, expected: .SINT64),
        .init(title: "UInt8Z", value: UInt8.max, expected: .UINT8),
        .init(title: "UInt16Z", value: UInt16.max, expected: .UINT16),
        .init(title: "UInt32Z", value: UInt32.max, expected: .UINT32),
        .init(title: "UInt64Z", value: UInt64.max, expected: .UINT64),
        .init(title: "Float32", value: Float32.greatestFiniteMagnitude, expected: .FLOAT32),
        .init(title: "Float64", value: Float64.greatestFiniteMagnitude, expected: .FLOAT64),
        .init(title: "String", value: "Test", expected: .STRING),
        .init(title: "Bool", value: true, expected: .UINT8)
    ] as [BaseTypeFromValueTestData])
    func test_baseTypeFromAnyValue_returnsCorrectBaseType(test: BaseTypeFromValueTestData) throws {
        #expect(BaseType.from(test.value) == test.expected)
    }

    @Test func test_baseTypeFromUnsupportedType_returnsNil() {
        #expect(BaseType.from(Decimal()) == nil)
        #expect(BaseType.from(Int.max) == nil)
        #expect(BaseType.from(UInt.max) == nil)
    }
}
