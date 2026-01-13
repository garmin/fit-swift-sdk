/////////////////////////////////////////////////////////////////////////////////////////////
// Copyright 2026 Garmin International, Inc.
// Licensed under the Flexible and Interoperable Data Transfer (FIT) Protocol License; you
// may not use this file except in compliance with the Flexible and Interoperable Data
// Transfer (FIT) Protocol License.
/////////////////////////////////////////////////////////////////////////////////////////////


import XCTest
@testable import FITSwiftSDK

final class MesgTests: XCTestCase {

    func test_getFieldByName_whenFieldInMesg_returnsField() throws {
        let fileIdMesg = FileIdMesg()
        try fileIdMesg.setType(.activity)

        XCTAssertTrue(fileIdMesg.getField(fieldName: "Type") != nil)
    }
    
    func test_getFieldByName_whenFieldNotInMesg_returnsNil() throws {
        let fileIdMesg = FileIdMesg()

        XCTAssertTrue(fileIdMesg.getField(fieldName: "Type") == nil)
    }

    func test_setFieldValue_whenFieldIsUnknown_baseTypeSetToValueType() throws {
        let mesg = Factory.createDefaultMesg(mesgName: "TestMesg", mesgNum: UInt16.max)
        
        try mesg.setFieldValue(fieldNum: 0, value: UInt32.max)
        
        XCTAssertEqual(mesg.getField(fieldNum: 0)!.baseType, .UINT32)
    }
    
    func test_setFieldValue_whenFieldIsUnknownAndTypeUnupported_throwsError() throws {
        let mesg = Factory.createDefaultMesg(mesgName: "TestMesgThrows", mesgNum: UInt16.max)
                
        XCTAssertThrowsError(try mesg.setFieldValue(fieldNum: 0, value: Decimal(100)))
    }

    func test_removeExpandedFields_whenMesgIncludesExpandedFields_expandedFieldsAreRemoved() throws {
        let mesg = RecordMesg()
        try mesg.setSpeed(100)
        
        try mesg.expandComponents(containingField: mesg.fields[RecordMesg.speedFieldNum]!, accumulator: Accumulator())
        
        XCTAssertEqual(mesg.fields.count, 2)
        
        mesg.removeExpandedFields()
        
        XCTAssertEqual(mesg.fields.count, 1)
    }
    
    // MARK: Mesg Field Array Tests
    func test_getFieldValue_byIndex() throws {
        let lapMesg = LapMesg()
        try lapMesg.setTimeInHrZone(index: 0, value: 10.6)
        try lapMesg.setTimeInHrZone(index: 1, value: 12.0)
        
        XCTAssertEqual(lapMesg.getTimeInHrZone(index: 0), 10.6)
        XCTAssertEqual(lapMesg.getTimeInHrZone(index: 1), 12.0)
        XCTAssertNil(lapMesg.getTimeInHrZone(index: 2))
    }
    
    func test_setFieldValue_whenFieldTypeIsPrimitiveType_setsValuesSuccessfully() throws {
        let lapMesg = LapMesg()
        try lapMesg.setTimeInHrZone(index: 0, value: 10.6)
        try lapMesg.setTimeInHrZone(index: 1, value: 12.0)
        
        XCTAssertEqual(lapMesg.getTimeInHrZone(), [10.6, 12.0])
    }

    func test_setFieldValue_whenFieldTypeIsEnumAndPassingEnum_setsValuesSuccessfully() throws {
        let deviceSettingsMesg = DeviceSettingsMesg()
        try deviceSettingsMesg.setTimeMode(index: 0, value: .hour24)
        try deviceSettingsMesg.setTimeMode(index: 1, value: .hour12)

        XCTAssertEqual(deviceSettingsMesg.getTimeMode(), [.hour24, .hour12])
    }
    
    func test_setFieldValue_whenFieldTypeIsStringAndPassingString_setsValuesSuccessfully() throws {
        let fieldDescriptionMesg = FieldDescriptionMesg()
        try fieldDescriptionMesg.setUnits(index: 0, value: "meters")
        try fieldDescriptionMesg.setUnits(index: 1, value: "per second")

        XCTAssertEqual(fieldDescriptionMesg.getUnits(), ["meters", "per second"])
    }
    
    func test_getNumFieldValues_whenFieldDoesNotExist_returns0() throws {
        let lapMesg = LapMesg()
        XCTAssertEqual(lapMesg.getNumTimeInHrZone(), 0)
    }
    
    func test_getNumFieldValues_whenFieldContains2Values_returns2() throws {
        let lapMesg = LapMesg()
        try lapMesg.setTimeInHrZone(index: 0, value: 10.0)
        try lapMesg.setTimeInHrZone(index: 1, value: 20.0)
        
        XCTAssertEqual(lapMesg.getNumTimeInHrZone(), 2)
    }
    
    func test_getFieldValueByIndex_whenFieldDoesNotExist_returnsNil() throws {
        let lapMesg = LapMesg()
        XCTAssertNil(lapMesg.getTimeInHrZone(index: 0))
    }
    
    func test_getFieldValueArray_whenFieldDoesNotExist_returnsNil() throws {
        let lapMesg = LapMesg()
        XCTAssertNil(lapMesg.getTimeInHrZone())
    }
    
    // MARK: Equatable Tests
    func test_equatable_whenMesgsAreIdentical_returnsTrue() throws {
        let mesg = Factory.createDefaultMesg(mesgName: "Mesg", mesgNum: 0)
        let mesgIdentical = Factory.createDefaultMesg(mesgName: "Mesg", mesgNum: 0)
        
        XCTAssertTrue(mesg == mesgIdentical)
    }
    
    func test_equatable_whenMesgNamesAreDifferent_returnsFalse() throws {
        let mesg = Factory.createDefaultMesg(mesgName: "Mesg", mesgNum: 0)
        let mesgDifferentName = Factory.createDefaultMesg(mesgName: "Mesg1", mesgNum: 0)
        
        XCTAssertFalse(mesg == mesgDifferentName)
    }
    
    func test_equatable_whenMesgNumsAreDifferent_returnsFalse() throws {
        let mesg = Factory.createDefaultMesg(mesgName: "Mesg", mesgNum: 0)
        let mesgDifferentNum = Factory.createDefaultMesg(mesgName: "Mesg", mesgNum: 1)
                                                          
        XCTAssertFalse(mesg == mesgDifferentNum)
    }
    
    func test_equatable_whenLocalMesgNumsAreDifferent_returnsFalse() throws {
        let mesg = Factory.createDefaultMesg(mesgName: "Mesg", mesgNum: 0)
        let mesgDifferentLocalMesgNum = Factory.createDefaultMesg(mesgName: "Mesg", mesgNum: 0)
        mesgDifferentLocalMesgNum.localMesgNum = .ten
                                                          
        XCTAssertFalse(mesg == mesgDifferentLocalMesgNum)
    }
    
    func test_equatable_whenFieldCountsAreIdentical_returnsTrue() throws {
        let mesg = Factory.createDefaultMesg(mesgName: "Mesg", mesgNum: 0)
        try mesg.setFieldValue(fieldNum: 0, value: 0)
        
        let mesgSameField = Factory.createDefaultMesg(mesgName: "Mesg", mesgNum: 0)
        try mesgSameField.setFieldValue(fieldNum: 0, value: 0)
                                                          
        XCTAssertTrue(mesg == mesgSameField)
    }
    
    func test_equatable_whenFieldCountsAreDifferent_returnsFalse() throws {
        let mesg = Factory.createDefaultMesg(mesgName: "Mesg", mesgNum: 0)
        try mesg.setFieldValue(fieldNum: 0, value: 0)
        
        let mesgTwoFields = Factory.createDefaultMesg(mesgName: "Mesg", mesgNum: 0)
        try mesgTwoFields.setFieldValue(fieldNum: 0, value: 0)
        try mesgTwoFields.setFieldValue(fieldNum: 1, value: 1)
                                                          
        XCTAssertFalse(mesg == mesgTwoFields)
    }
    
    func test_equatable_whenDevFieldCountsAreIdentical_returnsTrue() throws {
        let devField = try createTestDeveloperField()
        
        let mesg = Factory.createDefaultMesg(mesgName: "Mesg", mesgNum: 0)
        mesg.devFields[DeveloperDataKey(developerDataIndex: 0, fieldDescriptionNumber: 0)] = devField
        
        let mesgSameDevField = Factory.createDefaultMesg(mesgName: "Mesg", mesgNum: 0)
        mesgSameDevField.devFields[DeveloperDataKey(developerDataIndex: 0, fieldDescriptionNumber: 0)] = devField
        
        XCTAssertTrue(mesg == mesgSameDevField)
    }
    
    func test_equatable_whenDevFieldCountsAreDifferent_returnsFalse() throws {
        let devField1 = try createTestDeveloperField()
        let devField2 = try createTestDeveloperField(fieldDefinitionNumber: 1)
        
        let mesg = Factory.createDefaultMesg(mesgName: "Mesg", mesgNum: 0)
        mesg.devFields[DeveloperDataKey(developerDataIndex: 0, fieldDescriptionNumber: 0)] = devField1
        
        let mesgTwoDevFields = Factory.createDefaultMesg(mesgName: "Mesg", mesgNum: 0)

        mesgTwoDevFields.devFields[DeveloperDataKey(developerDataIndex: 0, fieldDescriptionNumber: 0)] = devField1
        mesgTwoDevFields.devFields[DeveloperDataKey(developerDataIndex: 0, fieldDescriptionNumber: 1)] = devField2
        
        XCTAssertFalse(mesg == mesgTwoDevFields)
    }
    
    func test_equatable_whenFieldNumsAreDifferent_returnsFalse() throws {
        let mesg = Factory.createDefaultMesg(mesgName: "Mesg", mesgNum: 0)
        try mesg.fields[0] = createTestFieldWithValue(type: .UINT8, value: 100)
        
        let mesgDifferentFieldNum = Factory.createDefaultMesg(mesgName: "Mesg", mesgNum: 0)
        try mesg.fields[1] = createTestFieldWithValue(type: .UINT8, value: 100)
                                                          
        XCTAssertFalse(mesg == mesgDifferentFieldNum)
    }
    
    func test_equatable_whenFieldValuesAreDifferent_returnsFalse() throws {
        let mesg = Factory.createDefaultMesg(mesgName: "Mesg", mesgNum: 0)
        try mesg.setFieldValue(fieldNum: 0, value: 0)
        
        let mesgDifferentFieldValue = Factory.createDefaultMesg(mesgName: "Mesg", mesgNum: 0)
        try mesgDifferentFieldValue.setFieldValue(fieldNum: 0, value: 100)
                                                          
        XCTAssertFalse(mesg == mesgDifferentFieldValue)
    }
    
    func test_equatable_whenDeveloperDataKeysAreDifferent_returnsFalse() throws {
        let devField = try createTestDeveloperField()
        
        let mesg = Factory.createDefaultMesg(mesgName: "Mesg", mesgNum: 0)
        mesg.devFields[DeveloperDataKey(developerDataIndex: 0, fieldDescriptionNumber: 0)] = devField
        
        let mesgDifferentDeveloperDataKey = Factory.createDefaultMesg(mesgName: "Mesg", mesgNum: 0)
        mesgDifferentDeveloperDataKey.devFields[DeveloperDataKey(developerDataIndex: 1, fieldDescriptionNumber: 0)] = devField
        
        XCTAssertFalse(mesg == mesgDifferentDeveloperDataKey)
    }
    
    func test_equatable_whenDeveloperFieldValuesAreDifferent_returnsFalse() throws {
        let devField = try createTestDeveloperField()
        
        let mesg = Factory.createDefaultMesg(mesgName: "Mesg", mesgNum: 0)
        mesg.devFields[DeveloperDataKey(developerDataIndex: 0, fieldDescriptionNumber: 0)] = devField
        
        let mesgDifferentDeveloperFieldValue = Factory.createDefaultMesg(mesgName: "Mesg", mesgNum: 0)
        mesgDifferentDeveloperFieldValue.devFields[DeveloperDataKey(developerDataIndex: 0, fieldDescriptionNumber: 1)] = devField
        
        XCTAssertFalse(mesg == mesgDifferentDeveloperFieldValue)
    }
    
    
    func test_equatable_whenMesgsAreFromProfileAndIdentical_returnsTrue() throws {
        let fileIdMesg = FileIdMesg()
        let fileIdMesgIdentical = FileIdMesg()
        
        XCTAssertTrue(fileIdMesg == fileIdMesgIdentical)
    }

    // MARK: Field Method Tests
    func test_hasField_whenMesgHasField_returnsTrue() throws {
        let mesg = Factory.createDefaultMesg(mesgName: "test", mesgNum: 0)

        let field = Factory.createDefaultField(fieldNum: 1, baseType: .ENUM)
        mesg.setField(field: field)

        XCTAssertTrue(mesg.hasField(fieldNum: field.num))
    }

    func test_hasField_whenMesgDoesntHaveField_returnsFalse() throws {
        let mesg = Factory.createDefaultMesg(mesgName: "test", mesgNum: 0)

        XCTAssertFalse(mesg.hasField(fieldNum: 0))
    }

    func test_setField_whenFieldIsValid_setsFieldInMesg() throws {
        let mesg = Factory.createDefaultMesg(mesgName: "test", mesgNum: 0)

        let field = Factory.createDefaultField(fieldNum: 1, baseType: .UINT8)
        try field.setValue(value: 123)

        mesg.setField(field: field)

        XCTAssertTrue(mesg.hasField(fieldNum: 1))
        XCTAssertEqual(mesg.getField(fieldNum: 1)?.getValue() as! UInt8, 123)
    }

    func test_setField_whenFieldExists_setsAndOverwritesFieldInMesg() throws {
        let mesg = Factory.createDefaultMesg(mesgName: "test", mesgNum: 0)
        let field = Factory.createDefaultField(fieldNum: 1, baseType: .UINT8)
        try field.setValue(value: 123)

        mesg.setField(field: field)

        let duplicateField = Factory.createDefaultField(fieldNum: 1, baseType: .UINT8)
        try duplicateField.setValue(value: 254)
        
        mesg.setField(field: duplicateField)

        XCTAssertTrue(mesg.hasField(fieldNum: 1))
        XCTAssertEqual(mesg.getField(fieldNum: 1)?.getValue() as! UInt8, 254)
    }

    func test_setFields_whenMesgNumsEqual_setsFieldsInMesg() throws {
        let mesg = Factory.createDefaultMesg(mesgName: "original", mesgNum: 0)
        let field = Factory.createDefaultField(fieldNum: 0, baseType: .UINT8)
        try field.setValue(value: 123)
        mesg.setField(field: field)

        let mesgToAdd = Factory.createDefaultMesg(mesgName: "toAdd", mesgNum: 0)
        let fieldToAdd = Factory.createDefaultField(fieldNum: 1, baseType: .UINT8)
        try fieldToAdd.setValue(value: 254)
        mesgToAdd.setField(field: fieldToAdd)

        mesg.setFields(mesg: mesgToAdd)

        XCTAssertEqual(mesg.fieldCount, 2)
        XCTAssertEqual(mesg.getField(fieldNum: 0)?.getValue() as! UInt8, 123)
        XCTAssertEqual(mesg.getField(fieldNum: 1)?.getValue() as! UInt8, 254)
    }

    func test_setFields_whenMesgNumsNotEqual_doesNotSetFieldsInMesg() throws {
        let mesg = Factory.createDefaultMesg(mesgName: "original", mesgNum: 0)
        let field = Factory.createDefaultField(fieldNum: 0, baseType: .UINT8)
        try field.setValue(value: 123)
        mesg.setField(field: field)

        let mesgToAdd = Factory.createDefaultMesg(mesgName: "toAdd", mesgNum: 1)
        let fieldToAdd = Factory.createDefaultField(fieldNum: 1, baseType: .UINT8)
        try fieldToAdd.setValue(value: 254)
        mesgToAdd.setField(field: fieldToAdd)

        mesg.setFields(mesg: mesgToAdd)

        XCTAssertEqual(mesg.fieldCount, 1)
        XCTAssertEqual(mesg.getField(fieldNum: 0)?.getValue() as! UInt8, 123)
    }

    func test_removeFieldByField_whenFieldInMesg_removesField() throws {
        let mesg = Factory.createDefaultMesg(mesgName: "test", mesgNum: 0)
        let field = Factory.createDefaultField(fieldNum: 1, baseType: .UINT8)
        try field.setValue(value: 123)
        mesg.setField(field: field)

        XCTAssertEqual(mesg.fieldCount, 1)

        mesg.removeField(field: field)

        XCTAssertEqual(mesg.fieldCount, 0)
    }

    func test_removeFieldByFieldNum_whenFieldInMesg_removesField() throws {
        let mesg = Factory.createDefaultMesg(mesgName: "test", mesgNum: 0)
        let field = Factory.createDefaultField(fieldNum: 1, baseType: .UINT8)
        mesg.setField(field: field)

        XCTAssertEqual(mesg.fieldCount, 1)

        mesg.removeField(fieldNum: field.num)

        XCTAssertEqual(mesg.fieldCount, 0)
    }
    
    // MARK: DecoderMesgIndex Tests
    func test_constructor_whenPassingMesg_copiesDecoderMesgIndex() throws {
        let mesg = Factory.createDefaultMesg(mesgName: "record", mesgNum: Profile.MesgNum.record)
        mesg.decoderMesgIndex = 4567
        
        let mesgCopy = Mesg(mesg: mesg)
        
        XCTAssertEqual(mesg.decoderMesgIndex, mesgCopy.decoderMesgIndex)
    }
    
    // MARK: ComponentExpansion Tests
    func test_expandComponents_fieldWithComponents_addsComponentFieldsToMesg() throws {
        let recordMesg = RecordMesg()
        try recordMesg.setAltitude(22)
        try recordMesg.setSpeed(2)
        
        try recordMesg.expandComponents(containingField: recordMesg.fields[RecordMesg.altitudeFieldNum]!, accumulator: Accumulator())
        try recordMesg.expandComponents(containingField: recordMesg.fields[RecordMesg.speedFieldNum]!, accumulator: Accumulator())

        
        XCTAssertEqual(recordMesg.getAltitude(), recordMesg.getEnhancedAltitude())
        XCTAssertEqual(recordMesg.getSpeed(), recordMesg.getEnhancedSpeed())
    }
        
    func test_expandComponents_subFieldWithComponents_addsComponentFieldsToMesg() throws {
        let eventMesg = EventMesg()
        try eventMesg.setEvent(.rearGearChange)
        try eventMesg.setData(385816581)
        
        // Check that the subfield is GearChangeData
        XCTAssertNotNil(try eventMesg.getGearChangeData())

        try eventMesg.expandComponents(containingField: eventMesg.getField(fieldNum: EventMesg.dataFieldNum)!, accumulator: Accumulator())
        
        XCTAssertEqual(eventMesg.getRearGear(), 24)
        XCTAssertEqual(eventMesg.getRearGearNum(), 5)
        XCTAssertEqual(eventMesg.getFrontGear(), 22)
        XCTAssertEqual(eventMesg.getFrontGearNum(), 255)
        
        return
    }
        
    func test_expandComponents_fieldWithComponentsWichHaveComponents_addsAllComponentFieldsToMesg() throws {
        let recordMesg = RecordMesg()
        try recordMesg.setCompressedSpeedDistance(index: 0, value: 0xFF)
        try recordMesg.setCompressedSpeedDistance(index: 1, value: 0xD0)
        try recordMesg.setCompressedSpeedDistance(index: 2, value: 0xE2)
        
        try recordMesg.expandComponents(containingField: recordMesg.getField(fieldNum: RecordMesg.compressedSpeedDistanceFieldNum)!, accumulator: Accumulator())
        
        // Speed and Distance should be expanded from the original field
        XCTAssertEqual(recordMesg.getSpeed(), 2.55)
        XCTAssertEqual(recordMesg.getDistance(), 226.81)
        
        // EnhancedSpeed should be expanded from Speed and Equal
        XCTAssertEqual(recordMesg.getEnhancedSpeed(), recordMesg.getSpeed())
        
        return
    }

    // MARK: Constructor Tests
    func test_constructor_fromMesg_MaintainsOrderOfFields() throws {
        let originalMesg = RecordMesg()
        try originalMesg.setTimestamp(DateTime.init())
        try originalMesg.setHeartRate(50)
        try originalMesg.setPositionLat(123456)
        try originalMesg.setSpeed(100)

        let copyMesg = Mesg(mesg: originalMesg)

        let originalFields = originalMesg.fields
        let copyFields = copyMesg.fields

        XCTAssertEqual(originalMesg, copyMesg)
        XCTAssertEqual(originalFields, copyFields)
    }
}
