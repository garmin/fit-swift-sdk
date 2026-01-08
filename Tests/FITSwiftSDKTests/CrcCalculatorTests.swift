/////////////////////////////////////////////////////////////////////////////////////////////
// Copyright 2025 Garmin International, Inc.
// Licensed under the Flexible and Interoperable Data Transfer (FIT) Protocol License; you
// may not use this file except in compliance with the Flexible and Interoperable Data
// Transfer (FIT) Protocol License.
/////////////////////////////////////////////////////////////////////////////////////////////


import XCTest
@testable import FITSwiftSDK

final class CrcCalculatorTests: XCTestCase {
    
    func test_updateCrc_onFitFile_returnsFilesExpectedCrc() throws {
        let crcCalculator = CrcCalculator();
        
        for index in 0..<fitFileShort.count - 2 {
            
            let _ = crcCalculator.updateCRC(fitFileShort[index])
        }
        
        XCTAssertEqual(crcCalculator.crc, 0xF25D)
    }
    
    func test_calculateCrc_onFitFile_returnsFilesExpectedCrc() throws {
        
        let data = fitFileShort[..<Int(fitFileShort.count - 2)]
        let crc = CrcCalculator.calculateCRC(data: data)
    
        XCTAssertEqual(crc, 0xF25D)
    }
}
