/////////////////////////////////////////////////////////////////////////////////////////////
// Copyright 2025 Garmin International, Inc.
// Licensed under the Flexible and Interoperable Data Transfer (FIT) Protocol License; you
// may not use this file except in compliance with the Flexible and Interoperable Data
// Transfer (FIT) Protocol License.
/////////////////////////////////////////////////////////////////////////////////////////////


import XCTest
@testable import FITSwiftSDK

final class DecoderIntegrationTests: XCTestCase {

    // MARK: MesgBroadcaster Integration Tests
    func test_whenBroadcastersWithListenersAreAddedToDecoder_mesgsShouldBeBroadcastedToListeners() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileShort)
        let decoder = Decoder(stream: stream)

        let mesgBroadcaster = MesgBroadcaster()
        let mesgListener = TestMesgListener()
        mesgBroadcaster.addListener(mesgListener as FileIdMesgListener)

        decoder.addMesgListener(mesgBroadcaster)
        try decoder.read()

        XCTAssertEqual(mesgListener.fileIdMesgs.count, 1)
    }

    func test_fileContainsUnknownMessages_onMesgShouldNotThrow() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileShortUnknownMesg)
        let decoder = Decoder(stream: stream)

        let mesgBroadcaster = MesgBroadcaster()
        let mesgListener = TestMesgListener()
        mesgBroadcaster.addListener(mesgListener as MesgListener)

        decoder.addMesgListener(mesgBroadcaster)
        try decoder.read()

        XCTAssertEqual(mesgListener.mesgs.count, 2)
        XCTAssertEqual(mesgListener.mesgs[0].mesgNum, MesgNum.fileId.rawValue)
        XCTAssertEqual(mesgListener.mesgs[1].mesgNum, 1234)
    }

    func test_whenBroadcastersWithThrowableListenersAreAddedToDecoder_listenerErrorsShouldBeRethrown() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileShort)
        let decoder = Decoder(stream: stream)

        let mesgListener = ShortCircuitMesgListener()
        let mesgBroadcaster = MesgBroadcaster()

        mesgBroadcaster.addListener(mesgListener as FileIdMesgListener)
        decoder.addMesgListener(mesgBroadcaster)

        // Short circuit the decoder on FileIdMesg
        do {
            try decoder.read()
        }
        catch TestShortCircuitError.fileIdMesgFound(let fileIdMesg) {
            XCTAssertEqual(fileIdMesg.getType(), File.activity)

            // The decoder should be short circuited and not have read completely
            XCTAssertNotEqual(stream.position, stream.count)
        }
    }

    // MARK: BufferedMesgBroadcaster Integration Tests
    func test_whenBroadcastersWithListenersAreAddedToDecoder_mesgsShouldBeBroadcastedAfterBroadcast() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileShort)
        let decoder = Decoder(stream: stream)

        let bufferedMesgBroadcaster = BufferedMesgBroadcaster()
        let mesgListener = TestMesgListener()
        bufferedMesgBroadcaster.addListener(mesgListener as FileIdMesgListener)

        decoder.addMesgListener(bufferedMesgBroadcaster)
        try decoder.read()

        // The bufferedBroadcaster hasn't yet broadcast its messages to its listeners
        XCTAssertEqual(mesgListener.fileIdMesgs.count, 0)

        try bufferedMesgBroadcaster.broadcast()
        XCTAssertEqual(mesgListener.fileIdMesgs.count, 1)
    }

    // MARK: Mesg Listener Integration Tests
    func test_whenDescriptionListenersAreAddedAndFileHasDevData_descriptionsAreBroadcastedToListeners() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileShortDevData)
        let decoder = Decoder(stream: stream)

        let descriptionListener = FitListener()
        decoder.addDeveloperFieldDescriptionListener(descriptionListener)

        try decoder.read()

        XCTAssertEqual(descriptionListener.fitMessages.developerFieldDescriptionMesgs.count, 1)

        let description = descriptionListener.fitMessages.developerFieldDescriptionMesgs[0]
        XCTAssertEqual(description.developerDataIndex, 0)
        XCTAssertEqual(description.fieldDefinitionNumber, 1)
    }

    func test_whenMesgListenersAreAddedToDecoder_mesgsAreBroadcastedToListeners() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileShort)
        let decoder = Decoder(stream: stream)

        let mesgListener = TestMesgListener()
        decoder.addMesgListener(mesgListener)

        try decoder.read();

        XCTAssertEqual(mesgListener.mesgs.count, 1)

        let fileIdMesg = FileIdMesg(mesg: mesgListener.mesgs[0])

        NSLog("%d", fileIdMesg.mesgNum)

        XCTAssertEqual(fileIdMesg.mesgNum, 0)

        XCTAssertEqual(fileIdMesg.getType(), .activity)

        XCTAssertEqual(fileIdMesg.getProductName(), "abcdefghi")

        try fileIdMesg.setType(File.device)
        XCTAssertEqual(fileIdMesg.getType(), .device)

        XCTAssertEqual(fileIdMesg.getSerialNumber(), nil)

        try fileIdMesg.setSerialNumber(1234)
        XCTAssertEqual(fileIdMesg.getSerialNumber(), 1234)

        try fileIdMesg.setSerialNumber(4321)
        XCTAssertEqual(fileIdMesg.getSerialNumber(), 4321)
    }

    // MARK: SubField Integration Tests
    func test_whenFileIdMesgProductSubfieldWithMissingManufacturerReferenceMesg_getSubfieldReturnsNil() throws {
        let stream = FITSwiftSDK.InputStream(data: fileIdMesgGarminProductSubfieldWithoutManufacturer)
        let decoder = Decoder(stream: stream)

        let mesgListener = FitListener()
        decoder.addMesgListener(mesgListener)

        try decoder.read();

        let fileIdMesg = mesgListener.fitMessages.fileIdMesgs[0]
        let productField = fileIdMesg.getField(fieldName: "Product")
        let faveroProductSubField = productField?.getSubField(subFieldName: "FaveroProduct")
        let garminProductSubField = productField?.getSubField(subFieldName: "GarminProduct")

        XCTAssertNil(fileIdMesg.getManufacturer())
        XCTAssertFalse(try faveroProductSubField!.canMesgSupport(mesg: fileIdMesg))
        XCTAssertFalse(try garminProductSubField!.canMesgSupport(mesg: fileIdMesg))
        XCTAssertNil(try fileIdMesg.getGarminProduct())
        XCTAssertNil(try fileIdMesg.getFaveroProduct())
        XCTAssertEqual(fileIdMesg.getProduct(), 4536)
    }

    func test_whenFileIdMesgProductSubfieldWithIncompatibleManufacturerType_getSubfieldReturnsNil() throws {
        let stream = FITSwiftSDK.InputStream(data: fileIdMesgGarminProductSubfieldWithDevelopmentManufacturer)
        let decoder = Decoder(stream: stream)

        let mesgListener = FitListener()
        decoder.addMesgListener(mesgListener)

        try decoder.read();

        let fileIdMesg = mesgListener.fitMessages.fileIdMesgs[0]
        let productField = fileIdMesg.getField(fieldName: "Product")
        let faveroProductSubField = productField?.getSubField(subFieldName: "FaveroProduct")
        let garminProductSubField = productField?.getSubField(subFieldName: "GarminProduct")

        XCTAssertEqual(fileIdMesg.getManufacturer(), .development)
        XCTAssertFalse(try faveroProductSubField!.canMesgSupport(mesg: fileIdMesg))
        XCTAssertFalse(try garminProductSubField!.canMesgSupport(mesg: fileIdMesg))
        XCTAssertNil(try fileIdMesg.getGarminProduct())
        XCTAssertNil(try fileIdMesg.getFaveroProduct())
        XCTAssertEqual(fileIdMesg.getProduct(), 4536)
    }

    func test_whenFileIdMesgProductSubfieldWithGarminManufacturerType_getSubfieldShouldReturnGarminProduct() throws {
        let stream = FITSwiftSDK.InputStream(data: fileIdMesgGarminProductSubfieldWithGarminManufacturer)
        let decoder = Decoder(stream: stream)

        let mesgListener = FitListener()
        decoder.addMesgListener(mesgListener)

        try decoder.read();

        let fileIdMesg = mesgListener.fitMessages.fileIdMesgs[0]
        let productField = fileIdMesg.getField(fieldName: "Product")
        let faveroProductSubField = productField?.getSubField(subFieldName: "FaveroProduct")
        let garminProductSubField = productField?.getSubField(subFieldName: "GarminProduct")

        XCTAssertEqual(fileIdMesg.getManufacturer(), .garmin)
        XCTAssertFalse(try faveroProductSubField!.canMesgSupport(mesg: fileIdMesg))
        XCTAssertTrue(try garminProductSubField!.canMesgSupport(mesg: fileIdMesg))
        XCTAssertEqual(try fileIdMesg.getGarminProduct(), .fenix8)
        XCTAssertNil(try fileIdMesg.getFaveroProduct())
        XCTAssertEqual(fileIdMesg.getProduct(), 4536)
    }

    func test_whenSubFieldTypeIsDifferentThanMainField_getSubFieldShouldReturnValue() throws {
        let eventMesg = EventMesg()
        try eventMesg.setData(1234)

        XCTAssertEqual(eventMesg.getData(), 1234)

        try eventMesg.setEvent(.autoActivityDetect)

        XCTAssertEqual(eventMesg.getData(), 1234)
        XCTAssertEqual(try eventMesg.getAutoActivityDetectDuration(), 1234)
    }

    func test_whenSubFieldTypeIsDifferentThanMainFieldAndValueInvalid_getSubFieldShouldReturnNil() throws {
        let eventMesg = EventMesg()
        try eventMesg.setData(BaseType.UINT32.invalidValue())

        XCTAssertNil(eventMesg.getData())

        try eventMesg.setEvent(.autoActivityDetect)
        XCTAssertNil(try eventMesg.getAutoActivityDetectDuration())
    }

    func test_whenSubFieldMainFieldIsEmpty_getSubFieldShouldReturnNil() throws {
        let eventMesg = EventMesg()

        XCTAssertNil(eventMesg.getData())

        try eventMesg.setEvent(.autoActivityDetect)

        XCTAssertNil(try eventMesg.getAutoActivityDetectDuration())
    }

    func test_whenSubFieldTypeIsDifferentThanMainFieldAndValueTooLarge_getSubFieldShouldReturnNil() throws {
        let eventMesg = EventMesg()
        try eventMesg.setData(0xABCDE)

        XCTAssertEqual(eventMesg.getData(), 0xABCDE)

        try eventMesg.setEvent(.autoActivityDetect)

        XCTAssertNil(try eventMesg.getAutoActivityDetectDuration())
    }

    // MARK: Component Expansion Integration Tests
    func test_whenFieldsContainComponents_componentsAreExpanded() throws {
        let recordMesgIn = RecordMesg()
        try recordMesgIn.setAltitude(22)
        try recordMesgIn.setSpeed(2)

        let encoder = Encoder();
        encoder.onMesg(recordMesgIn)
        let data = encoder.close()

        let decoder = Decoder(stream: InputStream(data: data))

        let mesgListener = TestMesgListener()
        decoder.addMesgListener(mesgListener)

        try decoder.read();

        let recordMesgOut = RecordMesg(mesg: mesgListener.mesgs[0])
        XCTAssertEqual(recordMesgOut.getAltitude(), recordMesgIn.getAltitude())
        XCTAssertEqual(recordMesgOut.getSpeed(), recordMesgIn.getSpeed())

        XCTAssertEqual(recordMesgOut.getEnhancedAltitude(), recordMesgIn.getAltitude())
        XCTAssertEqual(recordMesgOut.getEnhancedSpeed(), recordMesgIn.getSpeed())
    }

    func test_whenSubFieldsContainComponents_componentsAreExpanded() throws {
        let eventMesgIn = EventMesg()
        try eventMesgIn.setEvent(.rearGearChange)
        try eventMesgIn.setData(385816581)

        // Check that the subfield is GearChangeData
        XCTAssertNotNil(try eventMesgIn.getGearChangeData())

        let encoder = Encoder();
        encoder.onMesg(eventMesgIn)
        let data = encoder.close()

        let decoder = Decoder(stream: InputStream(data: data))

        let mesgListener = TestMesgListener()
        decoder.addMesgListener(mesgListener)

        try decoder.read();

        let eventMesgOut = EventMesg(mesg: mesgListener.mesgs[0])
        XCTAssertEqual(eventMesgOut.getData(), eventMesgIn.getData())
        XCTAssertEqual(try eventMesgOut.getGearChangeData(), try eventMesgIn.getGearChangeData())

        XCTAssertEqual(eventMesgOut.getRearGear(), 24)
        XCTAssertEqual(eventMesgOut.getRearGearNum(), 5)
        XCTAssertEqual(eventMesgOut.getFrontGear(), 22)
        XCTAssertEqual(eventMesgOut.getFrontGearNum(), 255)
    }

    func test_whenExpandedComponentsFieldsAreEnums_componentsAreExpandedIntoEnumTypes() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileMonitoringData)
        let decoder = Decoder(stream: stream)

        let mesgListener = TestMesgListener()
        decoder.addMesgListener(mesgListener)

        try decoder.read();

        var monitoringMesg = MonitoringMesg(mesg: mesgListener.mesgs[0])
        XCTAssertEqual(monitoringMesg.getActivityType(), .running)
        XCTAssertEqual(monitoringMesg.getIntensity(), 3)
        XCTAssertEqual(monitoringMesg.getCycles(), 10)
        XCTAssertEqual(try monitoringMesg.getSteps(), 20)

        monitoringMesg = MonitoringMesg(mesg: mesgListener.mesgs[1])
        XCTAssertEqual(monitoringMesg.getActivityType(), .walking)
        XCTAssertEqual(monitoringMesg.getIntensity(), 0)
        XCTAssertEqual(monitoringMesg.getCycles(), 30)
        XCTAssertEqual(try monitoringMesg.getSteps(), 60)

        monitoringMesg = MonitoringMesg(mesg: mesgListener.mesgs[2])
        XCTAssertEqual(monitoringMesg.getActivityType(), .invalid)
        XCTAssertEqual(monitoringMesg.getIntensity(), 0)
        XCTAssertEqual(monitoringMesg.getCycles(), 15)
        XCTAssertNil(try monitoringMesg.getSteps())

        monitoringMesg = MonitoringMesg(mesg: mesgListener.mesgs[3])
        XCTAssertNil(monitoringMesg.getActivityType())
        XCTAssertNil(monitoringMesg.getIntensity())
        XCTAssertEqual(monitoringMesg.getCycles(), 15)
        XCTAssertNil(try monitoringMesg.getSteps())
        return
    }

    // MARK: Accumulation Integration Tests
    func test_whenExpandedComponentsAreSetToBeAccumulated_fieldsAreAccumulated() throws {
        let encoder = Encoder();
        let recordMesg = RecordMesg()

        let cycles: [UInt8] = [254, 0, 1]

        try cycles.forEach {
            try recordMesg.setCycles($0)
            encoder.onMesg(recordMesg)
        }

        let decoder = Decoder(stream: InputStream(data: encoder.close()))

        let mesgListener = TestMesgListener()
        decoder.addMesgListener(mesgListener)

        try decoder.read();

        XCTAssertEqual(RecordMesg(mesg: mesgListener.mesgs[0]).getTotalCycles(), 254)
        XCTAssertEqual(RecordMesg(mesg: mesgListener.mesgs[1]).getTotalCycles(), 256)
        XCTAssertEqual(RecordMesg(mesg: mesgListener.mesgs[2]).getTotalCycles(), 257)
    }

    func test_whenAccumulatedComponentHasInvalidValue_invalidAccumulatedValuesReturnNilAndAreNotAccumulated() throws {
        let encoder = Encoder();
        let recordMesg = RecordMesg()

        let cycles: [UInt8] = [254, 255, 1]

        try cycles.forEach {
            try recordMesg.setCycles($0)
            encoder.onMesg(recordMesg)
        }

        let decoder = Decoder(stream: InputStream(data: encoder.close()))

        let mesgListener = TestMesgListener()
        decoder.addMesgListener(mesgListener)

        try decoder.read();

        XCTAssertEqual(RecordMesg(mesg: mesgListener.mesgs[0]).getTotalCycles(), 254)
        XCTAssertNil(RecordMesg(mesg: mesgListener.mesgs[1]).getTotalCycles())
        XCTAssertEqual(RecordMesg(mesg: mesgListener.mesgs[2]).getTotalCycles(), 257)
    }

    // MARK: Developer Data Integration Tests
    func test_whenFileHasDeveloperData_devFieldsAreAddedToMesgs() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileShortDevData)
        let decoder = Decoder(stream: stream)

        let mesgListener = TestMesgListener()
        decoder.addMesgListener(mesgListener)

        try decoder.read();

        XCTAssertEqual(mesgListener.mesgs.count, 3)
        XCTAssertEqual(mesgListener.mesgs[2].fieldCount, 1)
        XCTAssertEqual(mesgListener.mesgs[2].devFieldCount, 1)
    }

    func test_whenFileHasMultipleDeveloperFields_devFieldsAreAddedToMesgs() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileDevDataShortTwoFields)
        let decoder = Decoder(stream: stream)

        let mesgListener = TestMesgListener()
        decoder.addMesgListener(mesgListener)

        try decoder.read();

        XCTAssertEqual(mesgListener.mesgs.count, 4)
        XCTAssertEqual(mesgListener.mesgs[3].fieldCount, 1)
        XCTAssertEqual(mesgListener.mesgs[3].devFieldCount, 2)
    }

    func test_whenDeveloperDataReadWithIncorrectIndex_throwError() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileDevDataIncorrectDeveloperDataIndex)
        let decoder = Decoder(stream: stream)

        let mesgListener = TestMesgListener()
        decoder.addMesgListener(mesgListener)

        XCTAssertThrowsError(try decoder.read())
    }

    func test_whenFileHasDevDataApplicationId_applicationIdIsReadAndValidUuid() throws {
        let expectedUuid = "03020100-0504-0706-0809-0A0B0C0D0E0F"

        let stream = FITSwiftSDK.InputStream(data: fitFileDevDataApplicationId)
        let decoder = Decoder(stream: stream)

        let developerFieldDescriptionListener = FitListener()
        decoder.addDeveloperFieldDescriptionListener(developerFieldDescriptionListener)

        try decoder.read();

        XCTAssertEqual(developerFieldDescriptionListener.fitMessages.developerFieldDescriptionMesgs.count, 2)

        XCTAssertEqual(developerFieldDescriptionListener.fitMessages.developerFieldDescriptionMesgs[0].applicationId,
                       developerFieldDescriptionListener.fitMessages.developerFieldDescriptionMesgs[1].applicationId)

        XCTAssertEqual(developerFieldDescriptionListener.fitMessages.developerFieldDescriptionMesgs[0].applicationId?.uuidString, expectedUuid)
    }

    // MARK: Endianness Integration Tests
    func test_whenTwoFilesAreIdenticalButEndiannessOfEachAreDifferent_decoderOutputShouldBeEqual() throws {
        // Read the file with Little-Endian messages
        let streamLittle = FITSwiftSDK.InputStream(data: fitFileShortDevDataLittleEndian)
        let decoderLittle = Decoder(stream: streamLittle)

        let mesgDefinitionListenerLittle = TestMesgDefinitionListener()
        let mesgListenerLittle = FitListener()
        decoderLittle.addMesgDefinitionListener(mesgDefinitionListenerLittle)
        decoderLittle.addMesgListener(mesgListenerLittle)
        try decoderLittle.read()
        let recordMesgLittle = mesgListenerLittle.fitMessages.recordMesgs[0]

        // Read the file with Big-Endian messages
        let streamBig = FITSwiftSDK.InputStream(data: fitFileShortDevDataBigEndian)
        let decoderBig = Decoder(stream: streamBig)

        let mesgDefinitionListenerBig = TestMesgDefinitionListener()
        let mesgListenerBig = FitListener()
        decoderBig.addMesgDefinitionListener(mesgDefinitionListenerBig)
        decoderBig.addMesgListener(mesgListenerBig)
        try decoderBig.read()
        let recordMesgBig = mesgListenerBig.fitMessages.recordMesgs[0]

        // Assert that all message definitions and their field definitions are equal
        XCTAssertEqual(mesgDefinitionListenerLittle.mesgDefinitions, mesgDefinitionListenerBig.mesgDefinitions)
        XCTAssertEqual(mesgDefinitionListenerLittle.mesgDefinitions.count, mesgDefinitionListenerBig.mesgDefinitions.count)
        XCTAssertTrue(mesgDefinitionListenerLittle.mesgDefinitions == mesgDefinitionListenerBig.mesgDefinitions)


        // Assert that their record messages have equal multi-byte values and field counts
        XCTAssertEqual(recordMesgLittle.fieldCount, recordMesgBig.fieldCount)
        XCTAssertEqual(recordMesgLittle.devFieldCount, recordMesgBig.devFieldCount)
        XCTAssertEqual(recordMesgLittle.getPower(), recordMesgBig.getPower())

        let developerDataIdMesg = mesgListenerBig.fitMessages.developerDataIdMesgs[0]
        let fieldDescriptionMesg = mesgListenerBig.fitMessages.fieldDescriptionMesgs[0]

        XCTAssertEqual(developerDataIdMesg.getDeveloperDataIndex(), fieldDescriptionMesg.getDeveloperDataIndex())

        // Assert that their multi-byte developer fields are also equal
        let devValueLittle = recordMesgLittle.getDeveloperField(developerDataIdMesg: developerDataIdMesg, fieldDescriptionMesg: fieldDescriptionMesg)
        let devValueBig = recordMesgBig.getDeveloperField(developerDataIdMesg: developerDataIdMesg, fieldDescriptionMesg: fieldDescriptionMesg)

        XCTAssertEqual(devValueLittle, devValueBig)
    }

    // MARK: DecoderMesgIndex Integration Tests
    func test_decoderRead_incrementsMesgDecoderMesgIndex() throws {
        let encodedData = try encodeRecordMesgs()

        let stream = FITSwiftSDK.InputStream(data: encodedData)

        let decoder = Decoder(stream: stream)

        let mesgListener = TestMesgListener()
        decoder.addMesgListener(mesgListener)

        try decoder.read()

        for (index, mesg) in mesgListener.mesgs.enumerated() {
            XCTAssertEqual(mesg.decoderMesgIndex, index)
        }
    }

    func encodeRecordMesgs() throws -> Data {
        let encoder = Encoder();

        let fileIdMesg = FileIdMesg()
        try fileIdMesg.setType(.activity)
        encoder.onMesg(fileIdMesg)

        for index in 0..<500 {
            let recordMesg = RecordMesg()
            try recordMesg.setTimestamp(DateTime(timestamp: UInt32(index)))
            try recordMesg.setHeartRate(60)
            encoder.onMesg(recordMesg)
        }

        let encodedData = encoder.close()

        return encodedData
    }

    func test_whenFieldIncludesInvalidFloatingPointValues_fieldIsNotAddedToMesg() throws {
        let fitFile = Data([
            0x0E, 0x20, 0x8B, 0x08, 0x0D, 0x00, 0x00, 0x00, 0x2E, 0x46, 0x49, 0x54, 0x8E, 0xA3, // File Header - 14 Bytes
            0x40, 0x00, 0x00, 0x00, 0x00, 0x01, 0x0B, 0x04, 0x88, // Message Definition - 9 bytes
            0x00, 0xFF, 0xFF, 0xFF, 0xFF, // Message - 4 bytes
            0x74, 0x6B]); // CRC - 2 bytes

        let stream = FITSwiftSDK.InputStream(data: fitFile)
        let decoder = Decoder(stream: stream)

        let mesgListener = TestMesgListener()
        decoder.addMesgListener(mesgListener)

        try decoder.read();

        XCTAssertEqual(mesgListener.mesgs.count, 1)
        XCTAssertEqual(mesgListener.mesgs[0].fieldCount, 0)
    }

    // MARK: Message Definition Integration Tests
    func test_whenFieldDefIncludesInvalidFieldSize_fieldDataIsIgnored() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileShortInvalidFieldDef)
        let decoder = Decoder(stream: stream)

        let mesgListener = TestMesgListener()
        let mesgDefListener = TestMesgDefinitionListener()
        decoder.addMesgListener(mesgListener)
        decoder.addMesgDefinitionListener(mesgDefListener)

        try decoder.read();

        XCTAssertEqual(mesgDefListener.mesgDefinitions.count, 1)
        XCTAssertEqual(mesgDefListener.mesgDefinitions[0].fieldDefinitions.count, 5)

        let invalidFieldDef = mesgDefListener.mesgDefinitions[0].fieldDefinitions[4]
        XCTAssertEqual(invalidFieldDef.num, 3)
        XCTAssertEqual(invalidFieldDef.type, BaseType.UINT32.rawValue)
        XCTAssertEqual(invalidFieldDef.size, 1)

        XCTAssertEqual(mesgListener.mesgs.count, 1)

        let mesg = mesgListener.mesgs[0]
        XCTAssertEqual(mesg.fieldCount, 4)
        XCTAssertNil(mesg.getField(fieldNum: invalidFieldDef.num))
    }
}
