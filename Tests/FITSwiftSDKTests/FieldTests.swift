/////////////////////////////////////////////////////////////////////////////////////////////
// Copyright 2026 Garmin International, Inc.
// Licensed under the Flexible and Interoperable Data Transfer (FIT) Protocol License; you
// may not use this file except in compliance with the Flexible and Interoperable Data
// Transfer (FIT) Protocol License.
/////////////////////////////////////////////////////////////////////////////////////////////


import Foundation
import Testing
@testable import FITSwiftSDK

func createTestFieldWithValue(type: BaseType, value: Any?) throws -> Field {
    let field = Factory.createDefaultField(fieldNum: 0, baseType: type)
    try field.setValue(value: value)

    return field
}

@Suite struct FieldTests {

    // MARK: Get and Set Value Tests
    @Test func test_setValue_whenValueIsBool_setsValueTo0Or1() throws {
        let field = Factory.createDefaultField(fieldNum: 0, baseType: BaseType.UINT8)

        try field.setValue(value: true)
        #expect(field.getValue() as! UInt8 == 1)

        try field.setValue(value: false)
        #expect(field.getValue() as! UInt8 == 0)
    }

    @Test func test_setFieldValue_whenBaseTypeIsStringAndPassedValueIsNumber_valueIsConvertedToAString() throws {
        let fileIdMesg = FileIdMesg.createFileIdMesg()

        try fileIdMesg.setFieldValue(fieldNum: FileIdMesg.productNameFieldNum, value: 1234)
        #expect(fileIdMesg.getProductName() == "1234")
    }

    struct SignedValuesTestData: Sendable {
        let title: String
        let baseType: BaseType
        let swiftType: any Equatable.Type
        let value: any Sendable
        let expected: any Numeric & Sendable
    }
    @Test("Get and set value when values and base type are signed returns same signed value", arguments: [
        .init(title: "Int8 Negative Returns Negative", baseType: .SINT8, swiftType: Int8.self, value: -100, expected: Int8(-100)),
        .init(title: "Int16 Negative Returns Negative", baseType: .SINT16, swiftType: Int16.self, value: -100, expected: Int16(-100)),
        .init(title: "Int32 Negative Returns Negative", baseType: .SINT32, swiftType: Int32.self, value: -100, expected: Int32(-100)),
        .init(title: "Int64 Negative Returns Negative", baseType: .SINT64, swiftType: Int64.self, value: -100, expected: Int64(-100)),
        .init(title: "Float32 Negative Returns Negative", baseType: .FLOAT32, swiftType: Float32.self, value: -100, expected: Float32(-100)),
        .init(title: "Float64 Negative Returns Negative", baseType: .FLOAT64, swiftType: Float64.self, value: -100, expected: Float64(-100)),
        .init(title: "Int8 Positive Returns Positive", baseType: .SINT8, swiftType: Int8.self, value: 100, expected: Int8(100)),
        .init(title: "Int16 Positive Returns Positive", baseType: .SINT16, swiftType: Int16.self, value: 100, expected: Int16(100)),
        .init(title: "Int32 Positive Returns Positive", baseType: .SINT32, swiftType: Int32.self, value: 100, expected: Int32(100)),
        .init(title: "Int64 Positive Returns Positive", baseType: .SINT64, swiftType: Int64.self, value: 100, expected: Int64(100)),
        .init(title: "Float32 Positive Returns Positive", baseType: .FLOAT32, swiftType: Float32.self, value: 100, expected: Float32(100)),
        .init(title: "Float64 Positive Returns Positive", baseType: .FLOAT64, swiftType: Float64.self, value: 100, expected: Float64(100))
    ] as [SignedValuesTestData])
    func test_getAndSetValue_whenValuesAndBaseTypeAreSigned_returnsSameSignedValue(test: SignedValuesTestData) throws {
        let field = Factory.createDefaultField(fieldNum: 0, baseType: test.baseType)
        try field.setValue(value: test.value)

        try assertValueAndExpectedValueEqual(swiftType: test.swiftType, value: field.getValue()!, expected: test.expected)
    }

    static let invalidValueTestData: [(String, BaseType, Data, any Equatable.Type)] = [
        ("Enum", .ENUM, Data([0xFF]), UInt8.self),
        ("Byte", .BYTE, Data([0xFF]), UInt8.self),
        ("UInt8", .UINT8, Data([0xFF]), UInt8.self),
        ("UInt8Z", .UINT8Z, Data([0x00]), UInt8.self),
        ("SInt8", .SINT8, Data([0x7F]), Int8.self),
        ("UInt16", .UINT16, Data([0xFF, 0xFF]), UInt16.self),
        ("UInt16Z", .UINT16Z, Data([0x00, 0x00]), UInt16.self),
        ("SInt16", .SINT16, Data([0xFF, 0x7F]), Int16.self),
        ("UInt32", .UINT32, Data([0xFF, 0xFF, 0xFF, 0xFF]), UInt32.self),
        ("UInt32Z", .UINT32Z, Data([0x00, 0x00, 0x00, 0x00]), UInt32.self),
        ("SInt32", .SINT32, Data([0xFF, 0xFF, 0xFF, 0x7F]), Int32.self),
        ("UInt64", .UINT64, Data([0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF]), UInt64.self),
        ("UInt64Z", .UINT64Z, Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]), UInt64.self),
        ("SInt64", .SINT64, Data([0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x7F]), Int64.self),
        ("Float32", .FLOAT32, Data([0xFF, 0xFF, 0xFF, 0xFF]), Float32.self),
        ("Float64", .FLOAT64, Data([0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF]), Float64.self),
    ]
    @Test("Get and set value when value is invalid value returns nil", arguments: invalidValueTestData)
    func test_getAndSetValue_whenValueIsInvalidValue_returnsNil(title: String, baseType: BaseType, value: Data, swiftType: any Equatable.Type) throws {
        try assertFieldSetToInvalidValueAndType(swiftType: swiftType.self, value: value, baseType: baseType)
    }

    // MARK: addRawValue Tests
    @Test func test_addRawValue_whenFieldHasScaleAndOffset_doesNotApplyScaleOrOffset() throws {
        let rawValue: UInt8 = 100
        let scaledAndOffsetValueExpected = (Float64(rawValue) / 2) - 5

        let field = Field(name: "ScaleAndOffset", num: 0, type: BaseType.UINT8.rawValue, scale: 2, offset: 5, units: "", accumulated: false)
        try field.addRawValue(UInt8(100))

        #expect(field.getValue() as! Float64 == scaledAndOffsetValueExpected)
    }

    @Test func test_addRawValue_whenCalledMultipleTimes_appendsToValues() throws {
        let field = Factory.createDefaultField(fieldNum: 0, baseType: .UINT8)

        try field.addRawValue(0)
        try field.addRawValue(1)
        try field.addRawValue(2)

        #expect(field.getValue(index: 0) as! UInt8 == 0)
        #expect(field.getValue(index: 1) as! UInt8 == 1)
        #expect(field.getValue(index: 2) as! UInt8 == 2)
    }

    @Test func test_addRawValue_correctsRangeAndValue() throws {
        let field = Factory.createDefaultField(fieldNum: 0, baseType: .UINT8)

        try field.addRawValue(0)
        try field.addRawValue(UInt64.max)
        try field.addRawValue(2)

        #expect(field.getValue(index: 0) as! UInt8 == 0)
        #expect(field.getValue(index: 1) == nil)
        #expect(field.getValue(index: 2) as! UInt8 == 2)
    }

    // MARK: Field Size Overflow Tests
    @Test func test_setValue_whenTypeIsUInt8AndArraySizeExceeds255_throwsError() throws {
        let field = Factory.createDefaultField(fieldNum: 0, baseType: .UINT8)

        try field.setValue(index: 0, value: 0, subField: nil)
        try field.setValue(index: 0, value: nil, subField: nil)
        try field.setValue(index: 254, value: 0, subField: nil)
        try field.setValue(index: 254, value: nil, subField: nil)

        #expect(throws: Field.FieldError.sizeOverflow(size: 256)) {
            try field.setValue(index: 255, value: nil, subField: nil)
        }
    }

    @Test func testArrayBoundtest_setValue_whenTypeIsUInt16AndArraySizeExceeds126_throwsError() throws {
        let field = Factory.createDefaultField(fieldNum: 0, baseType: BaseType.UINT16)

        try field.setValue(index: 0, value: 0, subField: nil)
        try field.setValue(index: 0, value: nil, subField: nil)
        try field.setValue(index: 126, value: 0, subField: nil)
        try field.setValue(index: 126, value: nil, subField: nil)

        #expect(throws: Field.FieldError.sizeOverflow(size: 256)) {
            try field.setValue(index: 127, value: 0, subField: nil)
        }
    }

    @Test func test_setValue_whenTypeIsUInt32AndArraySizeExceeds62_throwsError() throws {
        let field = Factory.createDefaultField(fieldNum: 0, baseType: BaseType.UINT32)

        try field.setValue(index: 0, value: 0, subField: nil)
        try field.setValue(index: 0, value: nil, subField: nil)
        try field.setValue(index: 62, value: 0, subField: nil)
        try field.setValue(index: 62, value: nil, subField: nil)

        #expect(throws: Field.FieldError.sizeOverflow(size: 256)) {
            try field.setValue(index: 63, value: 0, subField: nil)
        }
    }

    @Test func test_setValue_whenTypeIsUInt64AndArraySizeExceeds30_throwsError() throws {
        let field = Factory.createDefaultField(fieldNum: 0, baseType: BaseType.UINT64)

        try field.setValue(index: 0, value: 0, subField: nil)
        try field.setValue(index: 0, value: nil, subField: nil)
        try field.setValue(index: 30, value: 0, subField: nil)
        try field.setValue(index: 30, value: nil, subField: nil)

        #expect(throws: Field.FieldError.sizeOverflow(size: 256)) {
            try field.setValue(index: 31, value: 0, subField: nil)
        }
    }

    @Test func test_addRawValue_whenTypeIsUInt8AndArraySizeExceeds255_throwsError() throws {
        let field = Factory.createDefaultField(fieldNum: 0, baseType: BaseType.UINT8)

        try field.addRawValue(UInt8(0))
        try field.setValue(index: 253, value: 0, subField: nil)
        try field.setValue(index: 253, value: nil, subField: nil)
        try field.addRawValue(UInt8(0))

        #expect(throws: Field.FieldError.sizeOverflow(size: 256)) {
            try field.addRawValue(UInt8(0))
        }
    }

    // MARK: Value Rounding Tests
    @Test func test_setValue_whenFieldIsFloatingPoint_valueIsNotRounded() throws {
        let field = Factory.createDefaultField(fieldNum: 0, baseType: .FLOAT32)
        let value: Float32 = 123.678

        try field.setValue(value: value)

        #expect(field.getValue() as! Float32 == value)
    }

    @Test func test_setValue_whenFieldIsIntegerWithNoScale_valueIsTruncated() throws {
        let field = Factory.createDefaultField(fieldNum: 0, baseType: .UINT16)
        let value: Float32 = 123.678

        try field.setValue(value: value)

        #expect(field.getValue() as! UInt16 == 123)
    }

    @Test func test_setValue_whenFieldIsIntegerWithScale_valueIsRounded() throws {
        let field = Field(name: "scaled", num: 0, type: BaseType.UINT8.rawValue, scale: 2, offset: 0, units: "", accumulated: false)
        let value: Float32 = 62.378

        try field.setValue(value: value)

        // Value gets scaled to 124.7 and rounded to 125, and should be 62.5 when retrieved
        #expect(field.getValue() as! Float64 == 62.5)
    }

    // MARK: Scale and Offset Tests
    @Test func test_setValue_whenFieldHasNoScaleOrOffset_storedValueEqualsInputValue() throws {
        let field = Field(name: "noScaleOrOffset", num: 250, type: BaseType.UINT16.rawValue, scale: 1, offset: 0, units: "m", accumulated: false)
        let value: UInt16 = 100

        try field.setValue(value: value)

        #expect(field.getValue() as? UInt16 != nil)
        #expect(field.getValue() as! UInt16 == value)

        // Verify that the stored value is also the same as there is no scale or offset
        let storedValue = UInt16(fitValue: field.values[0])

        #expect(storedValue == value)
    }

    @Test func test_setValue_whenFieldHasOffset_getValueReturnsFloat64() throws {
        let field = Field(name: "offsetOnly", num: 250, type: BaseType.UINT16.rawValue, scale: 1, offset: 10, units: "m", accumulated: false)
        let value: Float64 = 50

        try field.setValue(value: value)

        #expect(field.getValue() as? Float64 != nil)
        #expect(field.getValue() as! Float64 == value)

        // Verify that the stored value has the scale and offset applied and is the base type (not Float64)
        let storedValue = UInt16(fitValue: field.values[0])
        let expectedStoredValue: UInt16 = 50 + 10

        #expect(storedValue == expectedStoredValue)
    }

    @Test func test_setValue_whenFieldHasScaleAndOffset_getValueReturnsFloat64() throws {
        let field = Field(name: "scaleAndOffset", num: 250, type: BaseType.UINT16.rawValue, scale: 2, offset: 10, units: "m", accumulated: false)
        let value: Float64 = 50

        try field.setValue(value: value)

        #expect(field.getValue() as? Float64 != nil)
        #expect(field.getValue() as! Float64 == value)

        // Verify that the stored value has the scale and offset applied and is the base type (not Float64)
        let storedValue = UInt16(fitValue: field.values[0])
        let expectedStoredValue: UInt16 = (50 + 10) * 2

        #expect(storedValue == expectedStoredValue)
    }

    @Test func test_setValue_whenFieldIsArray_scaleAndOffsetIsApplied() throws {
        let field = Field(name: "arrayField", num: 250, type: BaseType.UINT16.rawValue, scale: 2, offset: 10, units: "m", accumulated: false)
        let value1: Float64 = 10
        let value2: Float64 = 20

        try field.setValue(index: 0, value: value1)
        try field.setValue(index: 1, value: value2)

        #expect(field.toArray() == [10.0, 20.0])
    }

    // MARK: Equatable Tests

    struct EquatablePropertiesTestData: @unchecked Sendable {
        let title: String
        let value: Field
        let expected: Bool
    }

    static let equatablePropertiesTestData: [EquatablePropertiesTestData] = [
        EquatablePropertiesTestData(title: "Identical Field", value: Field(name: "Field", num: 0, type: 0, scale: 0, offset: 0, units: "", accumulated: false), expected: true),
        EquatablePropertiesTestData(title: "Field with Different Name", value: Field(name: "Field1", num: 0, type: 0, scale: 0, offset: 0, units: "", accumulated: false), expected: false),
        EquatablePropertiesTestData(title: "Field with Different Field num", value: Field(name: "Field", num: 1, type: 0, scale: 0, offset: 0, units: "", accumulated: false), expected: false),
        EquatablePropertiesTestData(title: "Field with Different Type", value: Field(name: "Field", num: 0, type: 1, scale: 0, offset: 0, units: "", accumulated: false), expected: false),
        EquatablePropertiesTestData(title: "Field with Different Scale", value: Field(name: "Field", num: 0, type: 0, scale: 10, offset: 0, units: "", accumulated: false), expected: false),
        EquatablePropertiesTestData(title: "Field with Different Offset", value: Field(name: "Field", num: 0, type: 0, scale: 0, offset: 100, units: "", accumulated: false), expected: false),
        EquatablePropertiesTestData(title: "Field with Different Units", value: Field(name: "Field", num: 0, type: 0, scale: 0, offset: 0, units: "m", accumulated: false), expected: false),
    ]

    @Test("Equatable when properties are the same or different returns expected", arguments: equatablePropertiesTestData)
    func test_equatable_whenPropertiesAreTheSameOrDifferent_returnsExpected(test: EquatablePropertiesTestData) throws {
        let field = Field(name: "Field", num: 0, type: 0, scale: 0, offset: 0, units: "", accumulated: false)
        #expect((field == test.value) == test.expected)
    }

    struct EquatableFieldValuesTestData: Sendable {
        let title: String
        let lhsFactory: @Sendable () throws -> Field
        let rhsFactory: @Sendable () throws -> Field
        let expected: Bool

        init(_ title: String, _ lhsFactory: @escaping @Sendable () throws -> Field, _ rhsFactory: @escaping @Sendable () throws -> Field, _ expected: Bool) {
            self.title = title
            self.lhsFactory = lhsFactory
            self.rhsFactory = rhsFactory
            self.expected = expected
        }
    }
    static let equatableFieldValuesTestData: [EquatableFieldValuesTestData] = [
        .init("UInt8 matching value", { try createTestFieldWithValue(type: BaseType.UINT8, value: 100) }, { try createTestFieldWithValue(type: BaseType.UINT8, value: 100) }, true),
        .init("UInt8 different value", { try createTestFieldWithValue(type: BaseType.UINT8, value: 100) }, { try createTestFieldWithValue(type: BaseType.UINT8, value: 101) }, false),
        .init("Enum matching value", { try createTestFieldWithValue(type: BaseType.ENUM, value: 100) }, { try createTestFieldWithValue(type: BaseType.ENUM, value: 100) }, true),
        .init("Enum different value", { try createTestFieldWithValue(type: BaseType.ENUM, value: 100) }, { try createTestFieldWithValue(type: BaseType.ENUM, value: 101) }, false),
        .init("UInt8z matching value", { try createTestFieldWithValue(type: BaseType.UINT8Z, value: 100) }, { try createTestFieldWithValue(type: BaseType.UINT8Z, value: 100) }, true),
        .init("UInt8z different value", { try createTestFieldWithValue(type: BaseType.UINT8Z, value: 100) }, { try createTestFieldWithValue(type: BaseType.UINT8Z, value: 101) }, false),
        .init("Byte matching value", { try createTestFieldWithValue(type: BaseType.BYTE, value: 100) }, { try createTestFieldWithValue(type: BaseType.BYTE, value: 100) }, true),
        .init("Byte different value", { try createTestFieldWithValue(type: BaseType.BYTE, value: 100) }, { try createTestFieldWithValue(type: BaseType.BYTE, value: 101) }, false),
        .init("SInt8 matching value", { try createTestFieldWithValue(type: BaseType.SINT8, value: 100) }, { try createTestFieldWithValue(type: BaseType.SINT8, value: 100) }, true),
        .init("SInt8 different value", { try createTestFieldWithValue(type: BaseType.SINT8, value: 100) }, { try createTestFieldWithValue(type: BaseType.SINT8, value: 101) }, false),
        .init("SInt16 matching value", { try createTestFieldWithValue(type: BaseType.SINT16, value: 100) }, { try createTestFieldWithValue(type: BaseType.SINT16, value: 100) }, true),
        .init("SInt16 different value", { try createTestFieldWithValue(type: BaseType.SINT16, value: 100) }, { try createTestFieldWithValue(type: BaseType.SINT16, value: 101) }, false),
        .init("UInt16 matching value", { try createTestFieldWithValue(type: BaseType.UINT16, value: 100) }, { try createTestFieldWithValue(type: BaseType.UINT16, value: 100) }, true),
        .init("UInt16 different value", { try createTestFieldWithValue(type: BaseType.UINT16, value: 100) }, { try createTestFieldWithValue(type: BaseType.UINT16, value: 101) }, false),
        .init("UInt16Z matching value", { try createTestFieldWithValue(type: BaseType.UINT16Z, value: 100) }, { try createTestFieldWithValue(type: BaseType.UINT16Z, value: 100) }, true),
        .init("UInt16Z different value", { try createTestFieldWithValue(type: BaseType.UINT16Z, value: 100) }, { try createTestFieldWithValue(type: BaseType.UINT16Z, value: 101) }, false),
        .init("SInt32 matching value", { try createTestFieldWithValue(type: BaseType.SINT32, value: 100) }, { try createTestFieldWithValue(type: BaseType.SINT32, value: 100) }, true),
        .init("SInt32 different value", { try createTestFieldWithValue(type: BaseType.SINT32, value: 100) }, { try createTestFieldWithValue(type: BaseType.SINT32, value: 101) }, false),
        .init("UInt32 matching value", { try createTestFieldWithValue(type: BaseType.UINT32, value: 100) }, { try createTestFieldWithValue(type: BaseType.UINT32, value: 100) }, true),
        .init("UInt32 different value", { try createTestFieldWithValue(type: BaseType.UINT32, value: 100) }, { try createTestFieldWithValue(type: BaseType.UINT32, value: 101) }, false),
        .init("UInt32Z matching value", { try createTestFieldWithValue(type: BaseType.UINT32Z, value: 100) }, { try createTestFieldWithValue(type: BaseType.UINT32Z, value: 100) }, true),
        .init("UInt32Z different value", { try createTestFieldWithValue(type: BaseType.UINT32Z, value: 100) }, { try createTestFieldWithValue(type: BaseType.UINT32Z, value: 101) }, false),
        .init("Float32 matching value", { try createTestFieldWithValue(type: BaseType.FLOAT32, value: 100) }, { try createTestFieldWithValue(type: BaseType.FLOAT32, value: 100) }, true),
        .init("Float32 different value", { try createTestFieldWithValue(type: BaseType.FLOAT32, value: 100) }, { try createTestFieldWithValue(type: BaseType.FLOAT32, value: 101) }, false),
        .init("Float64 matching value", { try createTestFieldWithValue(type: BaseType.FLOAT64, value: 100) }, { try createTestFieldWithValue(type: BaseType.FLOAT64, value: 100) }, true),
        .init("Float64 different value", { try createTestFieldWithValue(type: BaseType.FLOAT64, value: 100) }, { try createTestFieldWithValue(type: BaseType.FLOAT64, value: 101) }, false),
        .init("SInt64 matching value", { try createTestFieldWithValue(type: BaseType.SINT64, value: 100) }, { try createTestFieldWithValue(type: BaseType.SINT64, value: 100) }, true),
        .init("SInt64 different value", { try createTestFieldWithValue(type: BaseType.SINT64, value: 100) }, { try createTestFieldWithValue(type: BaseType.SINT64, value: 101) }, false),
        .init("UInt64 matching value", { try createTestFieldWithValue(type: BaseType.UINT64, value: 100) }, { try createTestFieldWithValue(type: BaseType.UINT64, value: 100) }, true),
        .init("UInt64 different value", { try createTestFieldWithValue(type: BaseType.UINT64, value: 100) }, { try createTestFieldWithValue(type: BaseType.UINT64, value: 101) }, false),
        .init("UInt64Z matching value", { try createTestFieldWithValue(type: BaseType.UINT64Z, value: 100) }, { try createTestFieldWithValue(type: BaseType.UINT64Z, value: 100) }, true),
        .init("UInt64Z different value", { try createTestFieldWithValue(type: BaseType.UINT64Z, value: 100) }, { try createTestFieldWithValue(type: BaseType.UINT64Z, value: 101) }, false),
        .init("String matching value", { try createTestFieldWithValue(type: BaseType.STRING, value: "value") }, { try createTestFieldWithValue(type: BaseType.STRING, value: "value") }, true),
        .init("String different value", { try createTestFieldWithValue(type: BaseType.STRING, value: "value") }, { try createTestFieldWithValue(type: BaseType.STRING, value: "different value") }, false),
    ]
    @Test("Equatable when field contains single value equates on value and is expected", arguments: equatableFieldValuesTestData)
    func test_equatable_whenFieldContainsSingleValue_equatesOnValueAndIsExpected(test: EquatableFieldValuesTestData) throws {
        let lhs = try test.lhsFactory()
        let rhs = try test.rhsFactory()

        #expect((lhs == rhs) == test.expected)
    }

    func assertFieldSetToInvalidValueAndType<T: Equatable>(swiftType: T.Type, value: Data, baseType: BaseType) throws {
        let field = Factory.createDefaultField(fieldNum: 0, baseType: baseType)

        // This should not throw
        try field.setValue(value: value.withUnsafeBytes { $0.load(as: swiftType) })

        // The underlying value should be equal to the invalid value
        if(baseType == BaseType.FLOAT32 || baseType == BaseType.FLOAT64) {
            #expect(Float64(fitValue: field.values[0]).isNaN == true)
        }
        else {
            #expect(field.values[0] as? T == baseType.invalidValue() as T)
        }

        // Getting the invalid value should return nil
        #expect(field.getValue() == nil)
    }

    func assertValueAndExpectedValueEqual<T: Equatable>(swiftType: T.Type, value: Any, expected: Any) throws {
        #expect(value as! T == expected as! T)
    }

    // MARK: SubField Tests
    @Test func test_setFileIdMesgProductSubfield_withMissingManufacturerReferenceMessage_throwsError() throws {
        let fileIdMesg = FileIdMesg()
        #expect(throws: (any Error).self) {
            try fileIdMesg.setGarminProduct(GarminProduct.fenix8)
        }
    }

    @Test func test_setFileIdMesgProductSubfield_withIncompatableManufacturerType_throwsError() throws {
        let fileIdMesg = FileIdMesg()
        try fileIdMesg.setManufacturer(Manufacturer.development)
        #expect(throws: (any Error).self) {
            try fileIdMesg.setGarminProduct(GarminProduct.fenix8)
        }
    }

    @Test func test_setFileIdMesgProductSubfield_withCorrectRefFieldValues_returnsExpectedSubfieldValues() throws {
        let fileIdMesg = FileIdMesg()
        try fileIdMesg.setManufacturer(Manufacturer.garmin)
        try fileIdMesg.setGarminProduct(GarminProduct.fenix8)

        let productField = fileIdMesg.getField(fieldName: "Product")
        let faveroProductSubField = productField?.getSubField(subFieldName: "FaveroProduct")
        let garminProductSubField = productField?.getSubField(subFieldName: "GarminProduct")

        #expect(fileIdMesg.getManufacturer() == Manufacturer.garmin)
        #expect(try faveroProductSubField!.canMesgSupport(mesg: fileIdMesg) == false)
        #expect(try garminProductSubField!.canMesgSupport(mesg: fileIdMesg) == true)
        #expect(try fileIdMesg.getGarminProduct() == GarminProduct.fenix8)
        #expect(try fileIdMesg.getFaveroProduct() == nil)
        #expect(fileIdMesg.getProduct() == 4536)
    }

    @Test func test_getSubfieldValue_whenSubfieldHasScale_scaleIsApplied() throws {
        let workoutStepMesg = WorkoutStepMesg()
        try workoutStepMesg.setDurationType(WktStepDuration.time)
        try workoutStepMesg.setDurationTime(1)

        #expect(try workoutStepMesg.getDurationTime() == 1)
        #expect(workoutStepMesg.getDurationValue() == 1000)
    }

    @Test func test_setSubfieldValue_whenInputIsFloat_scaleAndOffsetIsApplied() throws {
        let workoutStepMesg = WorkoutStepMesg()
        try workoutStepMesg.setDurationType(WktStepDuration.time)
        try workoutStepMesg.setDurationTime(0.01)

        #expect(try workoutStepMesg.getDurationTime() == 0.01)
        #expect(workoutStepMesg.getDurationValue() == 10)
    }

    @Test func test_getActiveSubFieldIndex_whenSubFieldExists_returnsExpectedValue() throws {
        let workoutStepMesg = WorkoutStepMesg()
        try workoutStepMesg.setDurationType(WktStepDuration.distance)
        try workoutStepMesg.setDurationDistance(1)

        let activeSubFieldValue = try workoutStepMesg.getFieldValue(fieldNum: WorkoutStepMesg.durationValueFieldNum, index: 0, subFieldIndex: FIT.SUBFIELD_INDEX.ACTIVE_SUBFIELD) as? Float64
        #expect(activeSubFieldValue == 1)

        #expect(try workoutStepMesg.getActiveSubFieldIndex(fieldNum: WorkoutStepMesg.durationValueFieldNum) == 1)

        let durationValueField = workoutStepMesg.getField(fieldName: "DurationValue")
        let durationDistanceSubField = durationValueField?.getSubField(subFieldName: "DurationDistance")
        #expect(try durationDistanceSubField!.canMesgSupport(mesg: workoutStepMesg))

        #expect(try workoutStepMesg.getDurationTime() == nil)
        #expect(try workoutStepMesg.getDurationDistance() == 1)
        #expect(workoutStepMesg.getDurationValue() == 100)

        let durationDistance = try workoutStepMesg.getDurationDistance()
        #expect(activeSubFieldValue == durationDistance)
    }


    @Test func test_getSubFieldValue_whenincompatibleTypeActiveSubField_throwsError() throws {
        let workoutStepMesg = WorkoutStepMesg()
        try workoutStepMesg.setDurationType(WktStepDuration.time)
        #expect(throws: Error.self) {
            try workoutStepMesg.setDurationDistance(1)
        }
    }

    @Test func test_setActiveSubField_withoutType_throwsError() throws {
        let workoutStepMesg = WorkoutStepMesg()
        #expect(throws: Error.self) {
            try workoutStepMesg.setDurationDistance(1)
        }
    }

    @Test func test_getFieldAndSubfieldTypeNameAndUnits_fromFieldWithSubField_returnsSubFieldExpectedValuesFromProfile() throws {
        let workoutStepMesg = WorkoutStepMesg()
        try workoutStepMesg.setDurationType(WktStepDuration.time)
        try workoutStepMesg.setDurationTime(1)

        let durationValueField = workoutStepMesg.getField(fieldName: "DurationValue")

        #expect(durationValueField!.getName() == "DurationValue")
        #expect(durationValueField!.getName(subFieldIndex: 0) == "DurationTime")
        #expect(durationValueField!.getName(subFieldName: "DurationTime") == "DurationTime")

        #expect(durationValueField!.getType() == BaseType.UINT32.rawValue)
        #expect(durationValueField!.getType(subFieldIndex: 0) == BaseType.UINT32.rawValue)
        #expect(durationValueField!.getType(subFieldName: "DurationTime") == BaseType.UINT32.rawValue)

        #expect(durationValueField!.getUnits() == "")
        #expect(durationValueField!.getUnits(subFieldIndex: 0) == "s")
        #expect(durationValueField!.getUnits(subFieldName: "DurationTime") == "s")
    }

    // MARK: Array Field Tests
    @Test func test_byteArrayFieldRead_whenAllValuesAreValid_byteArrayFieldIsValid() throws {
        let byteArrayField = Factory.createDefaultField(fieldNum: 0, baseType: BaseType.BYTE)

        let stream = FITSwiftSDK.InputStream(data: Data([0x01, 0x02, 0x03, 0x04]))

        try byteArrayField.read(stream: stream, size: 4)

        #expect(byteArrayField.hasValues)
    }

    static let byteArrayTestCases = [
        (title: "First element is invalid 0111", data: Data([0xFF, 0x02, 0x03, 0x04])),
        (title: "Second element is invalid 1011", data: Data([0x01, 0xFF, 0x03, 0x04])),
        (title: "Third element is invalid 1101", data: Data([0x01, 0x02, 0xFF, 0x04])),
        (title: "Last element is invalid 1110", data: Data([0x01, 0x02, 0x03, 0xFF])),
        (title: "First and last elements are invalid 0110", data: Data([0xFF, 0x02, 0x03, 0xFF])),
        (title: "Middle elements are invalid 1001", data: Data([0x01, 0xFF, 0xFF, 0x04])),
        (title: "Odd indexes are invalid 1010", data: Data([0x01, 0xFF, 0x03, 0xFF])),
        (title: "Even indexes are invalid 0101", data: Data([0xFF, 0x02, 0xFF, 0x04])),
        (title: "All but first element are invalid 1000", data: Data([0x01, 0xFF, 0xFF, 0xFF])),
        (title: "All but second element are invalid 0100", data: Data([0xFF, 0x02, 0xFF, 0xFF])),
        (title: "All but third element are invalid 0010", data: Data([0xFF, 0xFF, 0x03, 0xFF])),
        (title: "All but forth element are invalid 0001", data: Data([0xFF, 0xFF, 0xFF, 0x04])),
        (title: "First two elements are invalid 0011", data: Data([0xFF, 0xFF, 0x03, 0x04])),
        (title: "Last two elements are invalid 1100", data: Data([0x01, 0x02, 0xFF, 0xFF]))
    ]
    @Test("Array field with any invalid values is still valid", arguments: byteArrayTestCases)
    func test_byteArrayFieldRead_whenAnyValuesAreInvalid_byteArrayFieldIsValid(testCase: (title: String, data: Data)) throws {
        let byteArrayField = Factory.createDefaultField(fieldNum: 0, baseType: BaseType.BYTE)
        let stream = FITSwiftSDK.InputStream(data: testCase.data)
        try byteArrayField.read(stream: stream, size: 4)
        #expect(byteArrayField.hasValues)
    }

    @Test func test_byteArrayFieldRead_whenAllValuesAreInvalid_byteArrayFieldIsInvalid() throws {
        let byteArrayField = Field(name: "array field", num: 0, type: BaseType.BYTE.rawValue , scale: 1.0, offset: 0, units: "", accumulated: false)

        let stream = FITSwiftSDK.InputStream(data: Data([0xFF, 0xFF, 0xFF, 0xFF]))

        try byteArrayField.read(stream: stream, size: 4)

        #expect(!byteArrayField.hasValues)
    }

    @Test func test_getValue_whenGivenIndex_returnsFieldValueAtIndex() throws {
        let arrayField = Factory.createDefaultField(fieldNum: 0, baseType: BaseType.SINT32)

        try arrayField.setValue(index: 0, value: 0)
        try arrayField.setValue(index: 1, value: 10)

        #expect(arrayField.getValue(index: 0) as! Int32 == 0)
        #expect(arrayField.getValue(index: 1) as! Int32 == 10)
        #expect(arrayField.getValue(index: 2) == nil)
    }

    @Test func test_toArray_returnsArrayOfFieldValues() throws {
        let arrayField = Factory.createDefaultField(fieldNum: 0, baseType: BaseType.SINT32)

        try arrayField.setValue(index: 0, value: 0)
        try arrayField.setValue(index: 1, value: 10)

        #expect(arrayField.toArray() as [Int32?] == [0, 10])
    }

    @Test func test_numValues_whenFieldHas0Values_returnsZero() throws {
        let arrayField = Factory.createDefaultField(fieldNum: 0, baseType: BaseType.SINT32)
        #expect(arrayField.numValues == 0)
    }

    @Test func test_numValues_whenFieldHasValues_returnsNumberOfFieldValues() throws {
        let arrayField = Factory.createDefaultField(fieldNum: 0, baseType: BaseType.SINT32)

        try arrayField.setValue(index: 0, value: 0)
        try arrayField.setValue(index: 1, value: 10)

        #expect(arrayField.numValues == 2)
    }

    @Test func test_getValue_whenFieldIsEmpty_returnsNil() throws {
        let arrayField = Factory.createDefaultField(fieldNum: 0, baseType: BaseType.SINT32)
        #expect(arrayField.getValue(index: 0) == nil)
    }

    // MARK: String Field Tests
    @Test func test_read_whenFieldIsSingleByteStringWithNullTerminator_trimsTerminatorsAndReadsExpectedValue() throws {
        let data = Data([0x2E, 0x46, 0x49, 0x54, 0x00])

        let field = try readStringFieldWithData(data)

        #expect(field.count == 1)
        #expect(field.getStringValue() == ".FIT")
    }

    @Test func test_read_whenFieldIsSingleByteStringWithoutNullTerminator_readsExpectedValue() throws {
        let data = Data([0x2E, 0x46, 0x49, 0x54])

        let field = try readStringFieldWithData(data)

        #expect(field.count == 1)
        #expect(field.getStringValue() == ".FIT")
    }

    @Test func test_read_whenFieldIsSingleByteStringWithTrailingNullTerminators_trimsTerminatorsAndReadsExpectedValue() throws {
        let data = Data([0x2E, 0x46, 0x49, 0x54, 0x00, 0x00, 0x00, 0x00])

        let field = try readStringFieldWithData(data)

        #expect(field.count == 1)
        #expect(field.getStringValue() == ".FIT")
    }

    @Test func test_read_whenFieldIsArrayOfStringsWithNullTerminators_trimsTerminatorsAndReadsExpectedValues() throws {
        let data = Data([0x2E, 0x46, 0x49, 0x54, 0x00, 0x47, 0x61, 0x72, 0x6d, 0x69, 0x6e, 0x00])

        let field = try readStringFieldWithData(data)

        #expect(field.count == 2)
        #expect(field.getStringValue(index: 0) == ".FIT")
        #expect(field.getStringValue(index: 1) == "Garmin")
    }

    @Test func test_read_whenFieldIsSingleByteStringWithStartingNullTerminators_trimsTerminatorsAndReadsExpectedValue() throws {
        let data = Data([0x00, 0x00, 0x00, 0x00, 0x2E, 0x46, 0x49, 0x54])

        let field = try readStringFieldWithData(data)

        #expect(field.count == 5)
        #expect(field.getStringValue(index: 0) == nil)
        #expect(field.getStringValue(index: 1) == nil)
        #expect(field.getStringValue(index: 2) == nil)
        #expect(field.getStringValue(index: 3) == nil)
        #expect(field.getStringValue(index: 4) == ".FIT")
    }

    @Test func test_read_whenFieldIsArrayOfStringsWithLeadingAndTrailingNullTerminators_onlyTrimsTrailingTerminators() throws {
        let data = Data([0x00, 0x00, 0x00, 0x00, 0x2E, 0x46, 0x49, 0x54, 0x00, 0x00, 0x00, 0x00])

        let field = try readStringFieldWithData(data)

        #expect(field.count == 5)
        #expect(field.getStringValue(index: 0) == nil)
        #expect(field.getStringValue(index: 1) == nil)
        #expect(field.getStringValue(index: 2) == nil)
        #expect(field.getStringValue(index: 3) == nil)
        #expect(field.getStringValue(index: 4) == ".FIT")
    }

    @Test func test_read_whenFieldIsSingleByteStringWithMultibyteCharacters_mulitbyteCharactersAreRead() throws {
        let data = Data([0x61, 0xD1, 0x84, 0xE1, 0x90, 0x83, 0xF0, 0x9D, 0x95, 0xAB, 0x7A, 0x00])

        let field = try readStringFieldWithData(data)

        #expect(field.count == 1)
        #expect(field.getStringValue() == "aфᐃ𝕫z")
    }

    @Test func test_setValue_whenValueIsStringOfSingleByteCharacters_noError() throws {
        try setStringValue(index: 0, value: "Short String Of Single Byte Characters")
    }

    @Test func test_setValue_whenValueIsStringOfMultiByteCharacters_noError() throws {
        try setStringValue(index: 0, value: "这套动作由两组")
    }

    @Test func test_setValue_whenValueIsStringOfSingleByteCharactersAndExceeds255Bytes_noError() throws {
        // 255 Bytes + the null terminator = 256 = fail
        let value = "AS4EgyRNHimg4Pw3bUiFQwGyOttIQti8kHzPcfoUQ1kxi4PGVpwuE7MVlfnA0PjvIdWYn" +
        "L5yDX4LmULwXFTt8jGqfafPSoL3CXmYVGaTHuB1ILbjdVtPGPm0FQPyS6NVeJ97cBYI6PoVI7wmRnc7MLS903ckhJephd" +
        "Y1OdBKJ4YRWTmhrR712BSl59SEwDs6uLHLUvWnA6JE6aVPkN2LJbI11QAtKzXNORWcK2ggsWqtsAzxSsdGyXCs6qs6CDx"

        #expect(throws: Field.FieldError.sizeOverflow(size: 256)) {
            try setStringValue(index: 0, value: value)
        }
    }

    @Test func test_setValue_whenValueIsStringOfMultiByteCharactersAndExceeds255Bytes_noError() throws {
        // 255 Bytes + the null terminator = 256 = fail
        let value = "这套动作由两组 4 分钟的 Tabata 训练组成，中间休息 1 分钟。对于每组 Tabata 训练，在" +
        "训练的 20 秒内尽可能多地重复完成动作，休息 10 秒，然后重复动作总共 8 组。在 Tabata 训练中间，还有 1 分."

        #expect(throws: Field.FieldError.sizeOverflow(size: 256)) {
            try setStringValue(index: 0, value: value)
        }
    }

    @Test func test_setValue_whenFieldIsArrayOfStringsAndFieldSizeExceeds255Bytes_throwsSizeOverflowError() throws {
        let field = Factory.createDefaultField(fieldNum: 0, baseType: BaseType.STRING)

        // 254 Bytes + the null terminator = 255 = ok
        let value = "AS4EgyRNHimg4Pw3bUiFQwGyOttIQti8kHzPcfoUQ1kxi4PGVpwuE7MVlfnA0PjvIdWYn" +
        "L5yDX4LmULwXFTt8jGqfafPSoL3CXmYVGaTHuB1ILbjdVtPGPm0FQPyS6NVeJ97cBYI6PoVI7wmRnc7MLS903ckhJephd" +
        "Y1OdBKJ4YRWTmhrR712BSl59SEwDs6uLHLUvWnA6JE6aVPkN2LJbI11QAtKzXNORWcK2ggsWqtsAzxSsdGyXCs6qs6CD"

        try field.setValue(index: 0, value: value, subField: nil)

        // Even a blank string will have a null terminator, and in this case push the field size over 255 bytes
        #expect(throws: Field.FieldError.sizeOverflow(size: 256)) {
            try field.setValue(index: 1, value: "", subField: nil)
        }
    }

    // MARK: FieldBase Write Tests
    @Test func test_write_emptyNilStringField_writesNullTerminator() throws {
        let outputStream = OutputStream()
        let field = Factory.createDefaultField(fieldNum: 0, baseType: BaseType.STRING)

        field.values.append("")

        let fieldDefintition = FieldDefinition(field: field)

        field.write(outputStream: outputStream)

        #expect(outputStream[0] == 0)
        #expect(Int(fieldDefintition.size) == outputStream.count)
    }

    @Test func test_write_ArrayValidValues_writes() throws {
        let outputStream = OutputStream()
        let field = Factory.createDefaultField(fieldNum: 0, baseType: BaseType.UINT8)

        let byteArray: [UInt8] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

        field.values = byteArray

        field.write(outputStream: outputStream)

        #expect(field.values.count == outputStream.count)
        for (index, value) in field.values.enumerated() {
            #expect(UInt8(fitValue: value) == outputStream[index])
        }
    }

    @Test func test_write_whenArrayContainsInvalid_continuesWritingPastInvalid() throws {
        let outputStream = OutputStream()
        let field = Factory.createDefaultField(fieldNum: 0, baseType: BaseType.UINT8)

        let byteArray: [UInt8?] = [0, 1, 2, 3, 255, 5, 6, 7, 8, 9, 10]

        field.values = byteArray

        field.write(outputStream: outputStream)

        #expect(field.values.count == outputStream.count)
        for (index, value) in field.values.enumerated() {
            #expect(UInt8(fitValue: value) == outputStream[index])
        }
    }

    @Test func test_read_whenSizeIsNotMultipleOfType_readingSkipsSize() throws {
        let uint32Field = Factory.createDefaultField(fieldNum: 0, baseType: BaseType.UINT32)

        let stream = FITSwiftSDK.InputStream(data: Data([0x01, 0x02, 0x03, 0x04]))

        try uint32Field.read(stream: stream, size: 1)

        #expect(!uint32Field.hasValues)
        #expect(stream.position == 1)
    }

    // MARK: Float64 Field Tests
    @Test func test_whenBaseTypeIsFloat64_littleEndianValueCanBeDecoded() throws {
        let float64Field = Factory.createDefaultField(fieldNum: 0, baseType: BaseType.FLOAT64)

        let stream = FITSwiftSDK.InputStream(data: Data([0x0, 0x0, 0x0, 0x0, 0x0, 0x80, 0x71, 0x40]))

        try float64Field.read(stream: stream, size: 8)
        
        #expect(float64Field.getValue(index: 0) as! Float64 == 280.0)
    }
    
    @Test func test_whenBaseTypeIsFloat64_bigEndianValueCanBeDecoded() throws {
        let float64Field = Factory.createDefaultField(fieldNum: 0, baseType: BaseType.FLOAT64)

        let stream = FITSwiftSDK.InputStream(data: Data([0x40, 0x71, 0x80, 0x0, 0x0, 0x0, 0x0, 0x0]))

        try float64Field.read(stream: stream, size: 8, endianness: .big)
        
        #expect(float64Field.getValue(index: 0) as! Float64 == 280.0)
    }

    @discardableResult
    func readStringFieldWithData(_ data: Data) throws -> Field {
        let stream = FITSwiftSDK.InputStream(data: data)

        let field = Factory.createDefaultField(fieldNum: 0, baseType: BaseType.STRING)
        let fieldDefinition = FieldDefinition(num: field.num, size: UInt8(data.count), type: field.type)

        try field.read(stream: stream, size: fieldDefinition.size)

        return field
    }

    @discardableResult
    func setStringValue(index: Int, value: String) throws -> Field {
        let field = Factory.createDefaultField(fieldNum: 0, baseType: BaseType.STRING)
        try field.setValue(index: index, value: value, subField: nil)

        return field
    }

}