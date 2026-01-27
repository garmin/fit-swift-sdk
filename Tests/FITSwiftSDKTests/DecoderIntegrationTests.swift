/////////////////////////////////////////////////////////////////////////////////////////////
// Copyright 2026 Garmin International, Inc.
// Licensed under the Flexible and Interoperable Data Transfer (FIT) Protocol License; you
// may not use this file except in compliance with the Flexible and Interoperable Data
// Transfer (FIT) Protocol License.
/////////////////////////////////////////////////////////////////////////////////////////////


import Testing
import Foundation
@testable import FITSwiftSDK

@Suite struct DecoderIntegrationTests {

    // MARK: MesgBroadcaster Integration Tests
    @Test func test_whenBroadcastersWithListenersAreAddedToDecoder_mesgsShouldBeBroadcastedToListeners() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileShort)
        let decoder = Decoder(stream: stream)

        let mesgBroadcaster = MesgBroadcaster()
        let mesgListener = TestMesgListener()
        mesgBroadcaster.addListener(mesgListener as FileIdMesgListener)

        decoder.addMesgListener(mesgBroadcaster)
        try decoder.read()

        #expect(mesgListener.fileIdMesgs.count == 1)
    }

    @Test func test_fileContainsUnknownMessages_onMesgShouldNotThrow() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileShortUnknownMesg)
        let decoder = Decoder(stream: stream)

        let mesgBroadcaster = MesgBroadcaster()
        let mesgListener = TestMesgListener()
        mesgBroadcaster.addListener(mesgListener as MesgListener)

        decoder.addMesgListener(mesgBroadcaster)
        try decoder.read()

        #expect(mesgListener.mesgs.count == 2)
        #expect(mesgListener.mesgs[0].mesgNum == MesgNum.fileId.rawValue)
        #expect(mesgListener.mesgs[1].mesgNum == 1234)
    }

    @Test func test_whenBroadcastersWithThrowableListenersAreAddedToDecoder_listenerErrorsShouldBeRethrown() throws {
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
            #expect(fileIdMesg.getType() == File.activity)

            // The decoder should be short circuited and not have read completely
            #expect(stream.position != stream.count)
        }
    }

    // MARK: BufferedMesgBroadcaster Integration Tests
    @Test func test_whenBroadcastersWithListenersAreAddedToDecoder_mesgsShouldBeBroadcastedAfterBroadcast() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileShort)
        let decoder = Decoder(stream: stream)

        let bufferedMesgBroadcaster = BufferedMesgBroadcaster()
        let mesgListener = TestMesgListener()
        bufferedMesgBroadcaster.addListener(mesgListener as FileIdMesgListener)

        decoder.addMesgListener(bufferedMesgBroadcaster)
        try decoder.read()

        // The bufferedBroadcaster hasn't yet broadcast its messages to its listeners
        #expect(mesgListener.fileIdMesgs.count == 0)

        try bufferedMesgBroadcaster.broadcast()
        #expect(mesgListener.fileIdMesgs.count == 1)
    }

    // MARK: Mesg Listener Integration Tests
    @Test func test_whenDescriptionListenersAreAddedAndFileHasDevData_descriptionsAreBroadcastedToListeners() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileShortDevData)
        let decoder = Decoder(stream: stream)

        let descriptionListener = FitListener()
        decoder.addDeveloperFieldDescriptionListener(descriptionListener)

        try decoder.read()

        #expect(descriptionListener.fitMessages.developerFieldDescriptionMesgs.count == 1)

        let description = descriptionListener.fitMessages.developerFieldDescriptionMesgs[0]
        #expect(description.developerDataIndex == 0)
        #expect(description.fieldDefinitionNumber == 1)
    }

    @Test func test_whenMesgListenersAreAddedToDecoder_mesgsAreBroadcastedToListeners() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileShort)
        let decoder = Decoder(stream: stream)

        let mesgListener = TestMesgListener()
        decoder.addMesgListener(mesgListener)

        try decoder.read();

        #expect(mesgListener.mesgs.count == 1)

        let fileIdMesg = FileIdMesg(mesg: mesgListener.mesgs[0])

        #expect(fileIdMesg.mesgNum == 0)

        #expect(fileIdMesg.getType() == .activity)

        #expect(fileIdMesg.getProductName() == "abcdefghi")

        try fileIdMesg.setType(File.device)
        #expect(fileIdMesg.getType() == .device)

        #expect(fileIdMesg.getSerialNumber() == nil)

        try fileIdMesg.setSerialNumber(1234)
        #expect(fileIdMesg.getSerialNumber() == 1234)

        try fileIdMesg.setSerialNumber(4321)
        #expect(fileIdMesg.getSerialNumber() == 4321)
    }

    // MARK: SubField Integration Tests
    @Test func test_whenFileIdMesgProductSubfieldWithMissingManufacturerReferenceMesg_getSubfieldReturnsNil() throws {
        let stream = FITSwiftSDK.InputStream(data: fileIdMesgGarminProductSubfieldWithoutManufacturer)
        let decoder = Decoder(stream: stream)

        let mesgListener = FitListener()
        decoder.addMesgListener(mesgListener)

        try decoder.read();

        let fileIdMesg = mesgListener.fitMessages.fileIdMesgs[0]
        let productField = fileIdMesg.getField(fieldName: "Product")
        let faveroProductSubField = productField?.getSubField(subFieldName: "FaveroProduct")
        let garminProductSubField = productField?.getSubField(subFieldName: "GarminProduct")

        #expect(fileIdMesg.getManufacturer() == nil)
        #expect(try faveroProductSubField!.canMesgSupport(mesg: fileIdMesg) == false)
        #expect(try garminProductSubField!.canMesgSupport(mesg: fileIdMesg) == false)
        #expect(try fileIdMesg.getGarminProduct() == nil)
        #expect(try fileIdMesg.getFaveroProduct() == nil)
        #expect(fileIdMesg.getProduct() == 4536)
    }

    @Test func test_whenFileIdMesgProductSubfieldWithIncompatibleManufacturerType_getSubfieldReturnsNil() throws {
        let stream = FITSwiftSDK.InputStream(data: fileIdMesgGarminProductSubfieldWithDevelopmentManufacturer)
        let decoder = Decoder(stream: stream)

        let mesgListener = FitListener()
        decoder.addMesgListener(mesgListener)

        try decoder.read();

        let fileIdMesg = mesgListener.fitMessages.fileIdMesgs[0]
        let productField = fileIdMesg.getField(fieldName: "Product")
        let faveroProductSubField = productField?.getSubField(subFieldName: "FaveroProduct")
        let garminProductSubField = productField?.getSubField(subFieldName: "GarminProduct")

        #expect(fileIdMesg.getManufacturer() == .development)
        #expect(try faveroProductSubField!.canMesgSupport(mesg: fileIdMesg) == false)
        #expect(try garminProductSubField!.canMesgSupport(mesg: fileIdMesg) == false)
        #expect(try fileIdMesg.getGarminProduct() == nil)
        #expect(try fileIdMesg.getFaveroProduct() == nil)
        #expect(fileIdMesg.getProduct() == 4536)
    }

    @Test func test_whenFileIdMesgProductSubfieldWithGarminManufacturerType_getSubfieldShouldReturnGarminProduct() throws {
        let stream = FITSwiftSDK.InputStream(data: fileIdMesgGarminProductSubfieldWithGarminManufacturer)
        let decoder = Decoder(stream: stream)

        let mesgListener = FitListener()
        decoder.addMesgListener(mesgListener)

        try decoder.read();

        let fileIdMesg = mesgListener.fitMessages.fileIdMesgs[0]
        let productField = fileIdMesg.getField(fieldName: "Product")
        let faveroProductSubField = productField?.getSubField(subFieldName: "FaveroProduct")
        let garminProductSubField = productField?.getSubField(subFieldName: "GarminProduct")

        #expect(fileIdMesg.getManufacturer() == .garmin)
        #expect(try faveroProductSubField!.canMesgSupport(mesg: fileIdMesg) == false)
        #expect(try garminProductSubField!.canMesgSupport(mesg: fileIdMesg) == true)
        #expect(try fileIdMesg.getGarminProduct() == .fenix8)
        #expect(try fileIdMesg.getFaveroProduct() == nil)
        #expect(fileIdMesg.getProduct() == 4536)
    }

    @Test func test_whenSubFieldTypeIsDifferentThanMainField_getSubFieldShouldReturnValue() throws {
        let eventMesg = EventMesg()
        try eventMesg.setData(1234)

        #expect(eventMesg.getData() == 1234)

        try eventMesg.setEvent(.autoActivityDetect)

        #expect(eventMesg.getData() == 1234)
        #expect(try eventMesg.getAutoActivityDetectDuration() == 1234)
    }

    @Test func test_whenSubFieldTypeIsDifferentThanMainFieldAndValueInvalid_getSubFieldShouldReturnNil() throws {
        let eventMesg = EventMesg()
        try eventMesg.setData(BaseType.UINT32.invalidValue())

        #expect(eventMesg.getData() == nil)

        try eventMesg.setEvent(.autoActivityDetect)
        #expect(try eventMesg.getAutoActivityDetectDuration() == nil)
    }

    @Test func test_whenSubFieldMainFieldIsEmpty_getSubFieldShouldReturnNil() throws {
        let eventMesg = EventMesg()

        #expect(eventMesg.getData() == nil)

        try eventMesg.setEvent(.autoActivityDetect)

        #expect(try eventMesg.getAutoActivityDetectDuration() == nil)
    }

    @Test func test_whenSubFieldTypeIsDifferentThanMainFieldAndValueTooLarge_getSubFieldShouldReturnNil() throws {
        let eventMesg = EventMesg()
        try eventMesg.setData(0xABCDE)

        #expect(eventMesg.getData() == 0xABCDE)

        try eventMesg.setEvent(.autoActivityDetect)

        #expect(try eventMesg.getAutoActivityDetectDuration() == nil)
    }

    // MARK: Component Expansion Integration Tests
    @Test func test_whenFieldsContainComponents_componentsAreExpanded() throws {
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
        #expect(recordMesgOut.getAltitude() == recordMesgIn.getAltitude())
        #expect(recordMesgOut.getSpeed() == recordMesgIn.getSpeed())

        #expect(recordMesgOut.getEnhancedAltitude() == recordMesgIn.getAltitude())
        #expect(recordMesgOut.getEnhancedSpeed() == recordMesgIn.getSpeed())
    }

    @Test func test_whenSubFieldsContainComponents_componentsAreExpanded() throws {
        let eventMesgIn = EventMesg()
        try eventMesgIn.setEvent(.rearGearChange)
        try eventMesgIn.setData(385816581)

        // Check that the subfield is GearChangeData
        #expect(try eventMesgIn.getGearChangeData() != nil)

        let encoder = Encoder();
        encoder.onMesg(eventMesgIn)
        let data = encoder.close()

        let decoder = Decoder(stream: InputStream(data: data))

        let mesgListener = TestMesgListener()
        decoder.addMesgListener(mesgListener)

        try decoder.read();

        let eventMesgOut = EventMesg(mesg: mesgListener.mesgs[0])
        #expect(eventMesgOut.getData() == eventMesgIn.getData())
        #expect(try eventMesgOut.getGearChangeData() == (try eventMesgIn.getGearChangeData()))

        #expect(eventMesgOut.getRearGear() == 24)
        #expect(eventMesgOut.getRearGearNum() == 5)
        #expect(eventMesgOut.getFrontGear() == 22)
        #expect(eventMesgOut.getFrontGearNum() == 255)
    }

    @Test func test_whenExpandedComponentsFieldsAreEnums_componentsAreExpandedIntoEnumTypes() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileMonitoringData)
        let decoder = Decoder(stream: stream)

        let mesgListener = TestMesgListener()
        decoder.addMesgListener(mesgListener)

        try decoder.read();

        var monitoringMesg = MonitoringMesg(mesg: mesgListener.mesgs[0])
        #expect(monitoringMesg.getActivityType() == .running)
        #expect(monitoringMesg.getIntensity() == 3)
        #expect(monitoringMesg.getCycles() == 10)
        #expect(try monitoringMesg.getSteps() == 20)

        monitoringMesg = MonitoringMesg(mesg: mesgListener.mesgs[1])
        #expect(monitoringMesg.getActivityType() == .walking)
        #expect(monitoringMesg.getIntensity() == 0)
        #expect(monitoringMesg.getCycles() == 30)
        #expect(try monitoringMesg.getSteps() == 60)

        monitoringMesg = MonitoringMesg(mesg: mesgListener.mesgs[2])
        #expect(monitoringMesg.getActivityType() == .invalid)
        #expect(monitoringMesg.getIntensity() == 0)
        #expect(monitoringMesg.getCycles() == 15)
        #expect(try monitoringMesg.getSteps() == nil)

        monitoringMesg = MonitoringMesg(mesg: mesgListener.mesgs[3])
        #expect(monitoringMesg.getActivityType() == nil)
        #expect(monitoringMesg.getIntensity() == nil)
        #expect(monitoringMesg.getCycles() == 15)
        #expect(try monitoringMesg.getSteps() == nil)
        return
    }

    // MARK: Accumulation Integration Tests
    @Test func test_whenExpandedComponentsAreSetToBeAccumulated_fieldsAreAccumulated() throws {
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

        #expect(RecordMesg(mesg: mesgListener.mesgs[0]).getTotalCycles() == 254)
        #expect(RecordMesg(mesg: mesgListener.mesgs[1]).getTotalCycles() == 256)
        #expect(RecordMesg(mesg: mesgListener.mesgs[2]).getTotalCycles() == 257)
    }

    @Test func test_whenAccumulatedComponentHasInvalidValue_invalidAccumulatedValuesReturnNilAndAreNotAccumulated() throws {
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

        #expect(RecordMesg(mesg: mesgListener.mesgs[0]).getTotalCycles() == 254)
        #expect(RecordMesg(mesg: mesgListener.mesgs[1]).getTotalCycles() == nil)
        #expect(RecordMesg(mesg: mesgListener.mesgs[2]).getTotalCycles() == 257)
    }

    // MARK: Developer Data Integration Tests
    @Test func test_whenFileHasDeveloperData_devFieldsAreAddedToMesgs() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileShortDevData)
        let decoder = Decoder(stream: stream)

        let mesgListener = TestMesgListener()
        decoder.addMesgListener(mesgListener)

        try decoder.read();

        #expect(mesgListener.mesgs.count == 3)
        #expect(mesgListener.mesgs[2].fieldCount == 1)
        #expect(mesgListener.mesgs[2].devFieldCount == 1)
    }

    @Test func test_whenFileHasMultipleDeveloperFields_devFieldsAreAddedToMesgs() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileDevDataShortTwoFields)
        let decoder = Decoder(stream: stream)

        let mesgListener = TestMesgListener()
        decoder.addMesgListener(mesgListener)

        try decoder.read();

        #expect(mesgListener.mesgs.count == 4)
        #expect(mesgListener.mesgs[3].fieldCount == 1)
        #expect(mesgListener.mesgs[3].devFieldCount == 2)
    }

    @Test func test_whenDeveloperDataReadWithIncorrectIndex_throwError() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileDevDataIncorrectDeveloperDataIndex)
        let decoder = Decoder(stream: stream)

        let mesgListener = TestMesgListener()
        decoder.addMesgListener(mesgListener)

        #expect(throws: (any Error).self) {
            try decoder.read()
        }
    }

    @Test func test_whenFileHasDevDataApplicationId_applicationIdIsReadAndValidUuid() throws {
        let expectedUuid = "03020100-0504-0706-0809-0A0B0C0D0E0F"

        let stream = FITSwiftSDK.InputStream(data: fitFileDevDataApplicationId)
        let decoder = Decoder(stream: stream)

        let developerFieldDescriptionListener = FitListener()
        decoder.addDeveloperFieldDescriptionListener(developerFieldDescriptionListener)

        try decoder.read();

        #expect(developerFieldDescriptionListener.fitMessages.developerFieldDescriptionMesgs.count == 2)

        #expect(developerFieldDescriptionListener.fitMessages.developerFieldDescriptionMesgs[0].applicationId ==
                       developerFieldDescriptionListener.fitMessages.developerFieldDescriptionMesgs[1].applicationId)

        #expect(developerFieldDescriptionListener.fitMessages.developerFieldDescriptionMesgs[0].applicationId?.uuidString == expectedUuid)
    }

    // MARK: Endianness Integration Tests
    @Test func test_whenTwoFilesAreIdenticalButEndiannessOfEachAreDifferent_decoderOutputShouldBeEqual() throws {
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
        #expect(mesgDefinitionListenerLittle.mesgDefinitions == mesgDefinitionListenerBig.mesgDefinitions)
        #expect(mesgDefinitionListenerLittle.mesgDefinitions.count == mesgDefinitionListenerBig.mesgDefinitions.count)
        #expect((mesgDefinitionListenerLittle.mesgDefinitions == mesgDefinitionListenerBig.mesgDefinitions) == true)


        // Assert that their record messages have equal multi-byte values and field counts
        #expect(recordMesgLittle.fieldCount == recordMesgBig.fieldCount)
        #expect(recordMesgLittle.devFieldCount == recordMesgBig.devFieldCount)
        #expect(recordMesgLittle.getPower() == recordMesgBig.getPower())

        let developerDataIdMesg = mesgListenerBig.fitMessages.developerDataIdMesgs[0]
        let fieldDescriptionMesg = mesgListenerBig.fitMessages.fieldDescriptionMesgs[0]

        #expect(developerDataIdMesg.getDeveloperDataIndex() == fieldDescriptionMesg.getDeveloperDataIndex())

        // Assert that their multi-byte developer fields are also equal
        let devValueLittle = recordMesgLittle.getDeveloperField(developerDataIdMesg: developerDataIdMesg, fieldDescriptionMesg: fieldDescriptionMesg)
        let devValueBig = recordMesgBig.getDeveloperField(developerDataIdMesg: developerDataIdMesg, fieldDescriptionMesg: fieldDescriptionMesg)

        #expect(devValueLittle == devValueBig)
    }

    // MARK: DecoderMesgIndex Integration Tests
    @Test func test_decoderRead_incrementsMesgDecoderMesgIndex() throws {
        let encodedData = try encodeRecordMesgs()

        let stream = FITSwiftSDK.InputStream(data: encodedData)

        let decoder = Decoder(stream: stream)

        let mesgListener = TestMesgListener()
        decoder.addMesgListener(mesgListener)

        try decoder.read()

        for (index, mesg) in mesgListener.mesgs.enumerated() {
            #expect(mesg.decoderMesgIndex == index)
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

    @Test func test_whenFieldIncludesInvalidFloatingPointValues_fieldIsNotAddedToMesg() throws {
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

        #expect(mesgListener.mesgs.count == 1)
        #expect(mesgListener.mesgs[0].fieldCount == 0)
    }

    // MARK: Message Definition Integration Tests
    @Test func test_whenFieldDefIncludesInvalidFieldSize_fieldDataIsIgnored() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileShortInvalidFieldDef)
        let decoder = Decoder(stream: stream)

        let mesgListener = TestMesgListener()
        let mesgDefListener = TestMesgDefinitionListener()
        decoder.addMesgListener(mesgListener)
        decoder.addMesgDefinitionListener(mesgDefListener)

        try decoder.read();

        #expect(mesgDefListener.mesgDefinitions.count == 1)
        #expect(mesgDefListener.mesgDefinitions[0].fieldDefinitions.count == 5)

        let invalidFieldDef = mesgDefListener.mesgDefinitions[0].fieldDefinitions[4]
        #expect(invalidFieldDef.num == 3)
        #expect(invalidFieldDef.type == BaseType.UINT32.rawValue)
        #expect(invalidFieldDef.size == 1)

        #expect(mesgListener.mesgs.count == 1)

        let mesg = mesgListener.mesgs[0]
        #expect(mesg.fieldCount == 4)
        #expect(mesg.getField(fieldNum: invalidFieldDef.num) == nil)
    }
    
    // MARK: Bit Mask Integration Tests
    struct leftRightBalanceTestData: Sendable {
        let title: String
        let mesgIndex: Int
        let expectedLeftRightBalanceValue: Int
        let expectedSideValue: Int
        let expectedMaskValue: Int
    }
    @Test("Get field of type rightLeftBalance bit mask", arguments: [
        .init(title: "leftRightBalance value is 126", mesgIndex: 0, expectedLeftRightBalanceValue: 126, expectedSideValue: 0, expectedMaskValue: 126),
        .init(title: "leftRightBalance value is 127", mesgIndex: 1, expectedLeftRightBalanceValue: 127, expectedSideValue: 0, expectedMaskValue: 127),
        .init(title: "leftRightBalance value is 128", mesgIndex: 2, expectedLeftRightBalanceValue: 128, expectedSideValue: Int(LeftRightBalanceValues.right), expectedMaskValue: 0),
        .init(title: "leftRightBalance value is 129", mesgIndex: 3, expectedLeftRightBalanceValue: 129, expectedSideValue: Int(LeftRightBalanceValues.right), expectedMaskValue: 1),
        
        
    ] as [leftRightBalanceTestData])
    func test_rightLeftBalanceBitMask_getFieldReturnsValue(test: leftRightBalanceTestData) throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileLeftRightBalanceLeftRightBalance100)
        let decoder = Decoder(stream: stream)
        
        let mesgListener = FitListener()
        decoder.addMesgListener(mesgListener)
        
        try decoder.read();
        
        let message = mesgListener.fitMessages.recordMesgs[test.mesgIndex]
        #expect(message.getLeftRightBalance()! == test.expectedLeftRightBalanceValue )
        #expect((message.getLeftRightBalance()! & LeftRightBalanceValues.right) == test.expectedSideValue )
        #expect((message.getLeftRightBalance()! & LeftRightBalanceValues.mask) ==  test.expectedMaskValue)
    }
    
    struct leftRightBalance100TestData: Sendable {
        let title: String
        let mesgIndex: Int
        let expectedLeftRightBalanceValue: Int
        let expectedSideValue: Int
        let expectedMaskValue: Int
    }
    @Test("Get field of type rightLeftBalance100 bit mask", arguments: [
        .init(title: "leftRightBalance value is 16382", mesgIndex: 0, expectedLeftRightBalanceValue: 16382, expectedSideValue: 0, expectedMaskValue: 16382),
        .init(title: "leftRightBalance value is 16383", mesgIndex: 1, expectedLeftRightBalanceValue: 16383, expectedSideValue: 0, expectedMaskValue: 16383),
        .init(title: "leftRightBalance value is 16384", mesgIndex: 2, expectedLeftRightBalanceValue: 16384, expectedSideValue: 0, expectedMaskValue: 0),
        .init(title: "leftRightBalance value is 32767", mesgIndex: 3, expectedLeftRightBalanceValue: 32767, expectedSideValue: 0, expectedMaskValue: 16383),
        .init(title: "leftRightBalance value is 32768", mesgIndex: 4, expectedLeftRightBalanceValue: 32768, expectedSideValue: Int(LeftRightBalance100Values.right), expectedMaskValue: 0),
        .init(title: "leftRightBalance value is 32769", mesgIndex: 5, expectedLeftRightBalanceValue: 32769, expectedSideValue: Int(LeftRightBalance100Values.right), expectedMaskValue: 1),
    ] as [leftRightBalance100TestData])
    func test_rightLeftBalance100BitMask_getFieldReturnsValue(test: leftRightBalance100TestData) throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileLeftRightBalanceLeftRightBalance100)
        let decoder = Decoder(stream: stream)
        
        let mesgListener = FitListener()
        decoder.addMesgListener(mesgListener)
        
        try decoder.read();
        
        let message = mesgListener.fitMessages.sessionMesgs[test.mesgIndex]
        #expect(message.getLeftRightBalance()! == test.expectedLeftRightBalanceValue )
        #expect((message.getLeftRightBalance()! & LeftRightBalance100Values.right) == test.expectedSideValue )
        #expect((message.getLeftRightBalance()! & LeftRightBalance100Values.mask) ==  test.expectedMaskValue)
    }
}
