/////////////////////////////////////////////////////////////////////////////////////////////
// Copyright 2026 Garmin International, Inc.
// Licensed under the Flexible and Interoperable Data Transfer (FIT) Protocol License; you
// may not use this file except in compliance with the Flexible and Interoperable Data
// Transfer (FIT) Protocol License.
/////////////////////////////////////////////////////////////////////////////////////////////


import Foundation
import Testing
@testable import FITSwiftSDK

@Suite struct EncoderTests {

    @Test func test_close_encoderHasReceivedNoMesgs_writesFileData() throws {
        let encoder = Encoder();
        let data = encoder.close()

        #expect(data.count == 16)
    }

    @Test func test_close_encoderHasReceivedOneMesg_writesFileData() throws {
        let encoder = Encoder();

        let fileIdMesg = FileIdMesg()
        try fileIdMesg.setType(.activity)
        try fileIdMesg.setTimeCreated(DateTime())
        try fileIdMesg.setProductName("Product Name")

        encoder.onMesg(fileIdMesg)
        let data = encoder.close()

        #expect(data.count == 50)
    }

    // MARK: - Null and FIT Invalid Value Encoding Tests

    private static let fieldDataOffset = 24

    private func encodeSingleFieldMesg(baseType: BaseType, value: Any?) throws -> Data {
        let mesg = Mesg(name: "testMesg", num: MesgNum.mfgRangeMin.rawValue)
        let field = Field(name: "testField", num: 0, type: baseType.rawValue, scale: 1.0, offset: 0.0, units: "", accumulated: false)

        try field.setValue(value: value)
        mesg.setField(field: field)

        let encoder = Encoder()
        encoder.onMesg(mesg)
        return encoder.close()
    }

    static let invalidValueTestParameters: [(String, BaseType)] = [
        ("UInt8",   .UINT8),
        ("SInt8",   .SINT8),
        ("UInt16",  .UINT16),
        ("SInt16",  .SINT16),
        ("UInt32",  .UINT32),
        ("SInt32",  .SINT32),
        ("Float32", .FLOAT32),
        ("Float64", .FLOAT64),
        ("UInt8Z",  .UINT8Z),
        ("UInt16Z", .UINT16Z),
        ("UInt32Z", .UINT32Z),
        ("Byte",    .BYTE),
        ("SInt64",  .SINT64),
        ("UInt64",  .UINT64),
        ("UInt64Z", .UINT64Z),
    ]

    @Test("Encoding nil value writes FIT invalid bytes", arguments: invalidValueTestParameters)
    func test_encodingNilValue_writesFITInvalidBytes(title: String, baseType: BaseType) throws {
        let data = try encodeSingleFieldMesg(baseType: baseType, value: nil as Any?)

        let invalidBytes = baseType.invalidBytes
        let fieldBytes = Array(data[Self.fieldDataOffset..<(Self.fieldDataOffset + invalidBytes.count)])

        #expect(fieldBytes == invalidBytes)
    }


    @Test("Encoding FIT invalid value writes expected bytes", arguments: invalidValueTestParameters)
    func test_encodingFITInvalidValue_writesExpectedBytes(title: String, baseType: BaseType) throws {
        let invalidValue = baseType.invalidValueInternal()
        let data = try encodeSingleFieldMesg(baseType: baseType, value: invalidValue)

        let invalidBytes = baseType.invalidBytes
        let fieldBytes = Array(data[Self.fieldDataOffset..<(Self.fieldDataOffset + invalidBytes.count)])

        #expect(fieldBytes == invalidBytes)
    }
}
