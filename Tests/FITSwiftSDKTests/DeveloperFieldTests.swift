/////////////////////////////////////////////////////////////////////////////////////////////
// Copyright 2026 Garmin International, Inc.
// Licensed under the Flexible and Interoperable Data Transfer (FIT) Protocol License; you
// may not use this file except in compliance with the Flexible and Interoperable Data
// Transfer (FIT) Protocol License.
/////////////////////////////////////////////////////////////////////////////////////////////


import Testing
@testable import FITSwiftSDK

func createTestDeveloperField(developerDataIndex: UInt8 = 0, fieldDefinitionNumber: UInt8 = 0, fitBaseType: FitBaseType = .float32, fieldName: String = "DevField", fieldIndex: Int = 0, units: String = "", scale: UInt8 = 0, offset: Int8 = 0) throws -> DeveloperField {
    let developerDataIdMesg = DeveloperDataIdMesg()
    try developerDataIdMesg.setDeveloperDataIndex(developerDataIndex)

    let fieldDescMesg = FieldDescriptionMesg()
    try fieldDescMesg.setDeveloperDataIndex(developerDataIndex)
    try fieldDescMesg.setFieldDefinitionNumber(fieldDefinitionNumber)
    try fieldDescMesg.setFitBaseTypeId(fitBaseType)
    try fieldDescMesg.setFieldName(index: fieldIndex, value: fieldName)
    try fieldDescMesg.setUnits(index: fieldIndex, value: units)
    try fieldDescMesg.setScale(scale)
    try fieldDescMesg.setOffset(offset)

    let developerFieldDefinition = DeveloperFieldDefinition(fieldDescriptionMesg: fieldDescMesg, developerDataIdMesg: developerDataIdMesg, size: 0)

    return DeveloperField(def: developerFieldDefinition)
}

@Suite struct DeveloperFieldTests {

    @Test func test_constructor_fromDeveloperFieldDefinition_createsExpectedField() throws {
        let developerDataIdMesg = DeveloperDataIdMesg()
        try developerDataIdMesg.setDeveloperDataIndex(0)

        let fieldDescMesg = FieldDescriptionMesg()
        try fieldDescMesg.setDeveloperDataIndex(0)
        try fieldDescMesg.setFieldDefinitionNumber(0)
        try fieldDescMesg.setFitBaseTypeId(.float32)
        try fieldDescMesg.setFieldName(index: 0, value: "fieldName")
        try fieldDescMesg.setUnits(index: 0, value: "units")
        try fieldDescMesg.setNativeMesgNum(.record)
        try fieldDescMesg.setNativeFieldNum(RecordMesg.heartRateFieldNum)

        let developerFieldDefinition = DeveloperFieldDefinition(fieldDescriptionMesg: fieldDescMesg, developerDataIdMesg: developerDataIdMesg, size: 0)

        #expect(developerFieldDefinition.developerDataIndex == developerDataIdMesg.getDeveloperDataIndex())
        #expect(developerFieldDefinition.fieldDefinitionNumber == fieldDescMesg.getFieldDefinitionNumber())

        #expect(developerFieldDefinition.developerDataIdMesg?.getDeveloperId() == developerDataIdMesg.getDeveloperId())
        #expect(developerFieldDefinition.fieldDescriptionMesg?.getFieldDefinitionNumber() == fieldDescMesg.getFieldDefinitionNumber())

        let devField = DeveloperField(def: developerFieldDefinition)


        #expect(devField.getNum() == developerFieldDefinition.fieldDefinitionNumber)
        #expect(devField.getBaseType() == BaseType(rawValue: (developerFieldDefinition.fieldDescriptionMesg?.getFitBaseTypeId()!.rawValue)!))
        #expect(devField.getName() == "fieldName")
        #expect(devField.getUnits() == "units")
        #expect(devField.nativeOverride == RecordMesg.heartRateFieldNum)
    }

    @Test func test_setDeveloperFieldAndCopyingField_copiesAllDeveloperFields() throws {
        let developerDataIdMesg = DeveloperDataIdMesg()
        try developerDataIdMesg.setDeveloperDataIndex(0)

        let fieldDescMesg = FieldDescriptionMesg()
        try fieldDescMesg.setDeveloperDataIndex(0)
        try fieldDescMesg.setFieldDefinitionNumber(0)
        try fieldDescMesg.setFitBaseTypeId(FitBaseType.float32)
        try fieldDescMesg.setFieldName(index: 0, value: "doughnutsearned")
        try fieldDescMesg.setUnits(index: 0, value: "doughnuts")
        try fieldDescMesg.setNativeMesgNum(MesgNum.record)
        try fieldDescMesg.setNativeFieldNum(RecordMesg.heartRateFieldNum)

        let developerFieldDefinition = DeveloperFieldDefinition(fieldDescriptionMesg: fieldDescMesg, developerDataIdMesg: developerDataIdMesg, size: 0)

        let devField = DeveloperField(def: developerFieldDefinition)
        try devField.setValue(value: 25)

        let recordMesg = RecordMesg()
        recordMesg.setDeveloperField(devField)
        try recordMesg.setHeartRate(20)

        let field = recordMesg.getDeveloperField(developerDataIdMesg: developerFieldDefinition.developerDataIdMesg!, fieldDescriptionMesg: developerFieldDefinition.fieldDescriptionMesg!)

        #expect(field == devField)

        // Test that creating a new message from an existing message copies developer fields
        let recordMesg2 = RecordMesg(mesg: recordMesg)

        let field2 = recordMesg2.getDeveloperField(developerDataIdMesg: developerFieldDefinition.developerDataIdMesg!, fieldDescriptionMesg: developerFieldDefinition.fieldDescriptionMesg!)

        #expect(field2 == field)
    }

    struct EquatableTestData: Sendable {
        let title: String
        let fieldFactory: @Sendable () throws -> DeveloperField
        let expected: Bool
    }
    @Test("Developer field equatable comparison", arguments: [
        .init(title: "Identical Dev Field", fieldFactory: { try createTestDeveloperField() }, expected: true),
        .init(title: "Dev Field with Different Name", fieldFactory: { try createTestDeveloperField(fieldName: "Field1") }, expected: false),
        .init(title: "Dev Field with Different Field num", fieldFactory: { try createTestDeveloperField(fieldDefinitionNumber: 1) }, expected: false),
        .init(title: "Dev Field with Different Type", fieldFactory: { try createTestDeveloperField(fitBaseType: FitBaseType.uint8) }, expected: false),
        .init(title: "Dev Field with Different Scale", fieldFactory:  { try createTestDeveloperField(scale: 10) }, expected: false),
        .init(title: "Dev Field with Different Offset", fieldFactory: { try createTestDeveloperField(offset: 100) }, expected: false),
        .init(title: "Dev Field with Different Units", fieldFactory: { try createTestDeveloperField(units: "m") }, expected: false),
    ] as [EquatableTestData])
    func test_equatable_whenValuesAreSameOrIdentical_returnsExpectedValue(test: EquatableTestData) throws {
        let devField = try createTestDeveloperField()
        let value = try test.fieldFactory()

        #expect((devField == value) == test.expected)
    }
}
