/////////////////////////////////////////////////////////////////////////////////////////////
// Copyright 2025 Garmin International, Inc.
// Licensed under the Flexible and Interoperable Data Transfer (FIT) Protocol License; you
// may not use this file except in compliance with the Flexible and Interoperable Data
// Transfer (FIT) Protocol License.
/////////////////////////////////////////////////////////////////////////////////////////////


import XCTest
@testable import FITSwiftSDK

final class MesgDefinitionTests: XCTestCase {
    // MARK: Constructor Tests
    func test_constructor_fromMesg_sortsFieldDefsByOrderOfInsertion() throws {
        let mesg = RecordMesg()
        try mesg.setHeartRate(50)
        try mesg.setPositionLat(123456)

        let mesgDef = MesgDefinition(mesg: mesg)

        XCTAssertTrue(mesgDef.fieldDefinitions[0].num == RecordMesg.heartRateFieldNum)
        XCTAssertTrue(mesgDef.fieldDefinitions[1].num == RecordMesg.positionLatFieldNum)
    }

    // MARK: Equatable Tests
    func test_equatable_whenMesgDefinitionsHaveEqualValues_returnsTrue() {
        let mesgDef1 = MesgDefinition(mesg: RecordMesg())
        let mesgDef2 = MesgDefinition(mesg: RecordMesg())

        XCTAssertEqual(mesgDef1, mesgDef2)
    }

    func test_equatable_whenCreatingMesgDefinitionFromCopiedMesg_returnsTrue() throws {
        let originalMesg = RecordMesg()
        try originalMesg.setHeartRate(50)
        try originalMesg.setPositionLat(123456)

        let copiedMesg = Mesg(mesg: originalMesg)

        XCTAssertEqual(MesgDefinition(mesg: originalMesg), MesgDefinition(mesg: copiedMesg))
    }

    func test_equatable_whenCreatingMesgDefinitionFromMesgsWithExactMatchingFields_returnsTrue() throws {
        let mesg1 = RecordMesg()
        try mesg1.setHeartRate(50)
        try mesg1.setPositionLat(123456)

        let mesg2 = RecordMesg()
        try mesg2.setHeartRate(50)
        try mesg2.setPositionLat(123456)

        XCTAssertEqual(MesgDefinition(mesg: mesg1), MesgDefinition(mesg: mesg2))
    }

    func test_equatable_whenCreatingMesgDefinitionFromMesgsWithDifferentOrderOfFields_returnsFalse() throws {
        let mesg1 = RecordMesg()
        try mesg1.setHeartRate(50)
        try mesg1.setPositionLat(123456)

        let mesg2 = RecordMesg()
        try mesg2.setPositionLat(123456)
        try mesg2.setHeartRate(50)

        XCTAssertNotEqual(MesgDefinition(mesg: mesg1), MesgDefinition(mesg: mesg2))
    }

    func test_equatable_whenCreatingMesgDefinitionFromMesgsWithDifferentOrderOfDevFields_returnsFalse() throws {
        // Dev field 1 - Data Index 1 Field Def 1
        let devDataIdMesg1 = DeveloperDataIdMesg()
        try devDataIdMesg1.setDeveloperDataIndex(1)

        let fieldDescriptionMesg1 = FieldDescriptionMesg()
        try fieldDescriptionMesg1.setFieldDefinitionNumber(1)

        let devField1 = DeveloperField(fieldDescription: fieldDescriptionMesg1, developerDataIdMesg: devDataIdMesg1)

        // Dev field 2 - Data Index 100 Field Def 100
        let devDataIdMesg2 = DeveloperDataIdMesg()
        try devDataIdMesg2.setDeveloperDataIndex(100)

        let fieldDescriptionMesg2 = FieldDescriptionMesg()
        try fieldDescriptionMesg2.setFieldDefinitionNumber(100)

        let devField2 = DeveloperField(fieldDescription: fieldDescriptionMesg2, developerDataIdMesg: devDataIdMesg2)


        // Equivalent dev fields set in different orders create unequal MesgDefinitions
        let mesg1 = RecordMesg()
        mesg1.setDeveloperField(devField2)
        mesg1.setDeveloperField(devField1)

        let mesg2 = RecordMesg()
        mesg2.setDeveloperField(devField1)
        mesg2.setDeveloperField(devField2)

        XCTAssertNotEqual(MesgDefinition(mesg: mesg1), MesgDefinition(mesg: mesg2))
    }
}
