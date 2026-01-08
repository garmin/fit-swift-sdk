/////////////////////////////////////////////////////////////////////////////////////////////
// Copyright 2025 Garmin International, Inc.
// Licensed under the Flexible and Interoperable Data Transfer (FIT) Protocol License; you
// may not use this file except in compliance with the Flexible and Interoperable Data
// Transfer (FIT) Protocol License.
/////////////////////////////////////////////////////////////////////////////////////////////


import XCTest
@testable import FITSwiftSDK

class TestMesgListener: MesgListener, FileIdMesgListener, RecordMesgListener {
    var mesgs: [Mesg] = []
    var fileIdMesgs: [FileIdMesg] = []
    var recordMesgs: [RecordMesg] = []
    
    func onMesg(_ mesg: Mesg) {
        mesgs.append(mesg)
    }
    
    func onMesg(_ mesg: FileIdMesg) {
        fileIdMesgs.append(mesg)
    }

    func onMesg(_ mesg: RecordMesg) {
        recordMesgs.append(mesg)
    }
}

class ShortCircuitMesgListener: FileIdMesgListener {
    func onMesg(_ mesg: FileIdMesg) throws {
        throw TestShortCircuitError.fileIdMesgFound(mesg)
    }
}

enum TestShortCircuitError: Error, @unchecked Sendable {
    case fileIdMesgFound(FileIdMesg)
}

class TestMesgDefinitionListener: MesgDefinitionListener {
    var mesgDefinitions: [MesgDefinition] = []
    
    func onMesgDefinition(_ mesgDefinition: MesgDefinition) {
        mesgDefinitions.append(mesgDefinition)
    }
}

final class DecoderTests: XCTestCase {

    // MARK: isFIT Tests
    func test_staticIsFit_whenFileValid_returnsTrue() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileShort)
        XCTAssertTrue(try Decoder.isFIT(stream: stream))
    }
    
    func test_staticIsFit_whenFileEmpty_returnsFalse() throws {
        let stream = FITSwiftSDK.InputStream(data: Data([]))
        XCTAssertFalse(try Decoder.isFIT(stream: stream))
    }
    
    func test_staticIsFit_whenFileHeaderSizeIsInvalid_returnsFalse() throws {
        // The file header size != 12 or 14
        var file = fitFileShort
        file[0] = 0xFF
        
        let stream = FITSwiftSDK.InputStream(data: file)
        XCTAssertFalse(try Decoder.isFIT(stream: stream))
    }
    
    func test_staticIsFit_whenFileSizeSmallerThanHeaderSizePlusCrc_returnsFalse() throws {
        // The file data size is smaller than the File Header + CRC
        let stream = FITSwiftSDK.InputStream(data: Data([0x0E, 0x12, 0x23]))
        XCTAssertFalse(try Decoder.isFIT(stream: stream))
    }
    
    func test_staticIsFit_whenFileTypeIncorrect_returnsFalse() throws {
        // The file type is != ".FIT"
        let stream = FITSwiftSDK.InputStream(data: Data([0x0E, 0x10, 0xD9, 0x07, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0x91, 0x33, 0x00, 0x00]))
        XCTAssertFalse(try Decoder.isFIT(stream: stream))
    }
    
    func test_isFit_whenFileValid_returnsTrue() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileShort)
        let decoder = Decoder(stream: stream)
        XCTAssertTrue(try decoder.isFIT())
    }
    
    func test_isFit_whenFileEmpty_returnsFalse() throws {
        let stream = FITSwiftSDK.InputStream(data: Data([]))
        let decoder = Decoder(stream: stream)
        XCTAssertFalse(try decoder.isFIT())
    }
    
    func test_isFit_whenFileHeaderSizeInvalid_returnsFalse() throws {
        // The file header size != 12 or 14
        var file = fitFileShort
        file[0] = 0xFF
        
        let stream = FITSwiftSDK.InputStream(data: file)
        let decoder = Decoder(stream: stream)
        XCTAssertFalse(try decoder.isFIT())
    }
    
    func test_isFit_whenFileSmallerThanHeaderSizePlusCrc_returnsFalse() throws {
        // The file data size is smaller than the File Header + CRC
        let stream = FITSwiftSDK.InputStream(data: Data([0x0E, 0x12, 0x23]))
        let decoder = Decoder(stream: stream)
        XCTAssertFalse(try decoder.isFIT())
    }
    
    func test_isFit_whenFileTypeIncorrect_returnsFalse() throws {
        // The file type is != ".FIT"
        let stream = FITSwiftSDK.InputStream(data: Data([0x0E, 0x10, 0xD9, 0x07, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0x91, 0x33, 0x00, 0x00]))
        let decoder = Decoder(stream: stream)
        XCTAssertFalse(try decoder.isFIT())
    }

    // MARK: checkIntegrity Tests
    func test_checkIntegrity_whenIsFitAndCrcIsCorrect_returnsTrue() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileShort)
        let decoder = Decoder(stream: stream)
        
        XCTAssertEqual(try decoder.checkIntegrity(), true)
    }
    
    func test_checkIntegrity_whenIsFitReturnsFalse_returnsFalse() throws {
        class DecoderMock: Decoder {
            override func isFIT() throws -> Bool {
                return false
            }
        }
        
        let stream = FITSwiftSDK.InputStream(data: fitFileShort)
        let decoder = DecoderMock(stream: stream)
        
        XCTAssertFalse(try decoder.checkIntegrity())
    }
    
    func test_checkIntegrity_whenCrcIsIncorrect_returnsFalse() throws {
        var file = fitFileShort
        file[file.endIndex - 1] = 0xFF
        
        let stream = FITSwiftSDK.InputStream(data: file)
        let decoder = Decoder(stream: stream)
        
        XCTAssertFalse(try decoder.checkIntegrity())
    }
    
    func test_checkIntegrity_whenFileSmallerThanHeaderSizePlusCrc_returnsFalse() throws {
        let stream = FITSwiftSDK.InputStream(data: Data([0x0E, 0x10, 0xD9, 0x07, 0xFF, 0x00, 0x00, 0x00, 0x2E, 0x46, 0x49, 0x54, 0x91, 0x33, 0x00, 0x00]))
        let decoder = Decoder(stream: stream)
        
        XCTAssertFalse(try decoder.checkIntegrity())
    }
    
    func test_read_whenFileIsValid_succeeds() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileShort)
        let decoder = Decoder(stream: stream)
        
        try decoder.read();
    }

    // MARK: Skip Header Tests
    func test_read_whenDecodeModeNormalAndFileHasInvalidHeader_throwsError() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileShortInvalidHeader)
        let decoder = Decoder(stream: stream)
        
        let mesgListener = TestMesgListener()
        decoder.addMesgListener(mesgListener)
        
        XCTAssertThrowsError(try decoder.read())
    }
    
    func test_read_whenDecodeModeSkipHeaderAndFileHasInvalidHeader_doesNotThrow() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileShortInvalidHeader)
        let decoder = Decoder(stream: stream)
        
        let mesgListener = TestMesgListener()
        decoder.addMesgListener(mesgListener)
        
        try decoder.read(decodeMode: .skipHeader)

        XCTAssertEqual(mesgListener.mesgs.count, 1)
    }
    
    func test_read_whenDecodeModeSkipHeaderAndFileIsValid_doesNotThrow() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileShort)
        let decoder = Decoder(stream: stream)
        
        let mesgListener = TestMesgListener()
        decoder.addMesgListener(mesgListener)
        
        try decoder.read(decodeMode: .skipHeader)

        XCTAssertEqual(mesgListener.mesgs.count, 1)
    }
    
    func test_read_whenDecodeModeSkipHeaderAndFileHasInvalidCrc_doesNotThrow() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileShortInvalidCRC)
        let decoder = Decoder(stream: stream)
        
        let mesgListener = TestMesgListener()
        decoder.addMesgListener(mesgListener)
        
        try decoder.read(decodeMode: .skipHeader)
        XCTAssertEqual(mesgListener.mesgs.count, 1)
    }
    
    // MARK: Data Only Tests
    func test_read_whenDecodeModeDataOnlyAndFileHasNoHeader_doesNotThrow() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileShortDataOnly)
        let decoder = Decoder(stream: stream)
        
        let mesgListener = TestMesgListener()
        decoder.addMesgListener(mesgListener)
        
        try decoder.read(decodeMode: .dataOnly)

        XCTAssertEqual(mesgListener.mesgs.count, 1)
    }
    
    func test_read_whenDecodeModeNormalAndFileHasNoHeader_throwsError() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileShortDataOnly)
        let decoder = Decoder(stream: stream)
        
        let mesgListener = TestMesgListener()
        decoder.addMesgListener(mesgListener)
        
        XCTAssertThrowsError(try decoder.read())
    }
    
    func test_read_whenDecodeModeDataOnlyAndFileIsValid_throwsError() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileShort)
        let decoder = Decoder(stream: stream)
        
        let mesgListener = TestMesgListener()
        decoder.addMesgListener(mesgListener)
        
        XCTAssertThrowsError(try decoder.read(decodeMode: .dataOnly))
    }
    
    func test_read_whenDecodeModeDataOnlyAndFileHasNoHeaderAndInvalidCrC_doesNotThrow() throws {
        let fileLength = fitFileShortInvalidCRC.count
        let trimmedHeaderInvalidCRC = fitFileShortInvalidCRC.subdata(in: Data.Index(FIT.HEADER_WITH_CRC_SIZE)..<fileLength)
        let stream = FITSwiftSDK.InputStream(data: trimmedHeaderInvalidCRC)
        let decoder = Decoder(stream: stream)
        
        let mesgListener = TestMesgListener()
        decoder.addMesgListener(mesgListener)
        
        try decoder.read(decodeMode: .dataOnly)
        
        XCTAssertEqual(mesgListener.mesgs.count, 1)
    }
    
    // MARK: MesgBroadcaster Tests
    func test_broadcastMesg_whenBroadcastersWithListenersAreAdded_broadcastersShouldBroadcastMesgsToTheirListeners() throws {
        let decoder = Decoder(stream: FITSwiftSDK.InputStream(data: Data()))
        
        let mesgBroadcaster = MesgBroadcaster()
        let mesgListener = TestMesgListener()
        mesgBroadcaster.addListener(mesgListener as FileIdMesgListener)
        
        decoder.addMesgListener(mesgBroadcaster)
        
        try decoder.broadcastMesg(FileIdMesg())
        try decoder.broadcastMesg(RecordMesg())
        
        XCTAssertEqual(mesgListener.fileIdMesgs.count, 1)
    }
    
    func test_broadcastMesg_whenOutOfScopeMesgListenerWeakRef_doesNotThrow() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileShort)
        let decoder = Decoder(stream: stream)
        
        do {
            let mesgListener = TestMesgListener()
            decoder.addMesgListener(mesgListener)
        }
        
        let fileIdMesg = FileIdMesg()
        XCTAssertNoThrow(try decoder.broadcastMesg(fileIdMesg))
    }
    
    func test_broadcastMesg_whenOutOfScopeMesgDefinitionListenerWeakRef_doesNotThrow() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileShort)
        let decoder = Decoder(stream: stream)
        
        do {
            let mesgDefinitionListener = TestMesgDefinitionListener()
            decoder.addMesgDefinitionListener(mesgDefinitionListener)
        }
        
        let fileIdMesg = FileIdMesg()
        let fileIdMesgDefinition = MesgDefinition(mesg: fileIdMesg)
        XCTAssertNoThrow(try decoder.broadcastMesgDefinition(fileIdMesgDefinition))
    }

    func test_broadcastMesg_whenOutOfScopeDeveloperFieldDescriptionListenerWeakRef_doesNotThrow() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileShort)
        let decoder = Decoder(stream: stream)
        
        do {
            let developerFieldDescriptionListener = FitListener()
            decoder.addDeveloperFieldDescriptionListener(developerFieldDescriptionListener)
        }
        
        let fileIdMesg = FileIdMesg()
        let developerFieldDescription = DeveloperFieldDescription(developerDataIdMesg: DeveloperDataIdMesg(), fieldDescriptionMesg: FieldDescriptionMesg(mesg: fileIdMesg))
        XCTAssertNoThrow(decoder.broadcastDeveloperFieldDescription(developerFieldDescription))
    }

    func test_broadcastMesg_whenOnMesgExplicitlyThrows_rethrows() throws {
        let stream = FITSwiftSDK.InputStream(data: fitFileShort)
        let decoder = Decoder(stream: stream)

        let fileIdMesg = FileIdMesg()
        try fileIdMesg.setType(File.activity)

        let mesgListener = ShortCircuitMesgListener()
        let mesgBroadcaster = MesgBroadcaster()

        mesgBroadcaster.addListener(mesgListener as FileIdMesgListener)
        decoder.addMesgListener(mesgBroadcaster)

        XCTAssertThrowsError(try decoder.broadcastMesg(fileIdMesg))
    }
}
