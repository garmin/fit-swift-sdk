/////////////////////////////////////////////////////////////////////////////////////////////
// Copyright 2025 Garmin International, Inc.
// Licensed under the Flexible and Interoperable Data Transfer (FIT) Protocol License; you
// may not use this file except in compliance with the Flexible and Interoperable Data
// Transfer (FIT) Protocol License.
/////////////////////////////////////////////////////////////////////////////////////////////


import XCTest
@testable import FITSwiftSDK

final class SubFieldTests: XCTestCase {
    
    func test_constructor_whenPassedSubfield_returnsIdenticalCopySubfield() throws {
        let subField = SubField(name: "testSubField", type: BaseType.UINT32.rawValue, scale: 3, offset: 10, units: "m")
        
        let subFieldCopy = SubField(subField: subField)

        XCTAssertEqual(subField.name, subFieldCopy.name)
        XCTAssertEqual(subField.type, subFieldCopy.type)
        XCTAssertEqual(subField.scale, subFieldCopy.scale)
        XCTAssertEqual(subField.offset, subFieldCopy.offset)
        XCTAssertEqual(subField.units, subFieldCopy.units)
    }
    
    func test_constructor_whenPassedNil_returnsDefaultSubField() throws {
        let nilSubField = SubField(subField: nil)

        XCTAssertEqual(nilSubField.name, "unknown")
        XCTAssertEqual(nilSubField.type, 0)
        XCTAssertEqual(nilSubField.scale, 1)
        XCTAssertEqual(nilSubField.offset, 0)
        XCTAssertEqual(nilSubField.units, "")
        XCTAssertEqual(nilSubField.maps.count, 0)
    }
}
