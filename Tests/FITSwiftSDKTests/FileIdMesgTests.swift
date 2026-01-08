/////////////////////////////////////////////////////////////////////////////////////////////
// Copyright 2025 Garmin International, Inc.
// Licensed under the Flexible and Interoperable Data Transfer (FIT) Protocol License; you
// may not use this file except in compliance with the Flexible and Interoperable Data
// Transfer (FIT) Protocol License.
/////////////////////////////////////////////////////////////////////////////////////////////


import XCTest
@testable import FITSwiftSDK

final class FileIdMesgTests: XCTestCase {
    func test_getFields_whenMesgIsPopulated_returnsExpectedFieldValues() throws {
        let fileIdMesg = FileIdMesg()

        XCTAssertEqual(fileIdMesg.mesgNum, Profile.MesgNum.fileId)

        XCTAssertEqual(fileIdMesg.getType(), nil)
        XCTAssertEqual(fileIdMesg.getSerialNumber(), nil)
        XCTAssertEqual(fileIdMesg.getProductName(), nil)
        XCTAssertEqual(fileIdMesg.getTimeCreated(), nil)

        try fileIdMesg.setType(.activity)
        try fileIdMesg.setSerialNumber(12345)
        try fileIdMesg.setProductName("ProductName")

        let now = DateTime()
        try fileIdMesg.setTimeCreated(DateTime())


        XCTAssertEqual(fileIdMesg.getType(), .activity)
        XCTAssertEqual(fileIdMesg.getSerialNumber(), 12345)
        XCTAssertEqual(fileIdMesg.getProductName(), "ProductName")
        XCTAssertEqual(fileIdMesg.getTimeCreated(), now)

        try fileIdMesg.setType(.invalid)
        XCTAssertEqual(fileIdMesg.getType(), nil)

        try fileIdMesg.setFieldValue(fieldNum: FileIdMesg.productNameFieldNum, value: 1)
        XCTAssertEqual(fileIdMesg.getProductName(), "1")

        try fileIdMesg.setFieldValue(fieldNum: FileIdMesg.productNameFieldNum, value: 1.0 as Float32)
        XCTAssertEqual(fileIdMesg.getProductName(), "1.0")

        try fileIdMesg.setFieldValue(fieldNum: FileIdMesg.productNameFieldNum, value: 1.1)
        XCTAssertEqual(fileIdMesg.getProductName(), "1.1")
    }

}
