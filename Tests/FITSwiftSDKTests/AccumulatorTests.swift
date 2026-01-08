/////////////////////////////////////////////////////////////////////////////////////////////
// Copyright 2025 Garmin International, Inc.
// Licensed under the Flexible and Interoperable Data Transfer (FIT) Protocol License; you
// may not use this file except in compliance with the Flexible and Interoperable Data
// Transfer (FIT) Protocol License.
/////////////////////////////////////////////////////////////////////////////////////////////


import XCTest
import Testing

@testable import FITSwiftSDK

@Suite struct AccumulatorTests {

    @Test func test_accumulate_singleField_accumulatesValue() throws {
        let accumulator = Accumulator()
        
        accumulator.createAccumulatedField(mesgNum: 0, fieldNum: 0, value: 0)
        #expect(accumulator.accumulate(mesgNum: 0, fieldNum: 0, value: 1, bits: 8) == 1)
        #expect(accumulator.accumulate(mesgNum: 0, fieldNum: 0, value: 2, bits: 8) == 2)
        #expect(accumulator.accumulate(mesgNum: 0, fieldNum: 0, value: 4, bits: 8) == 4)
        #expect(accumulator.accumulate(mesgNum: 0, fieldNum: 0, value: 5, bits: 8) == 5)
    }
    
    @Test func test_accumlate_multipleFields_accumulatesValuesIndependently() throws {
        let accumulator = Accumulator()
        
        accumulator.createAccumulatedField(mesgNum: 0, fieldNum: 0, value: 250)
        #expect(accumulator.accumulate(mesgNum: 0, fieldNum: 0, value: 254, bits: 8) == 254)

        accumulator.createAccumulatedField(mesgNum: 1, fieldNum: 1, value: 0)
        #expect(accumulator.accumulate(mesgNum: 1, fieldNum: 1, value: 2, bits: 8) == 2)

        #expect(accumulator.accumulate(mesgNum: 0, fieldNum: 0, value: 0, bits: 8) == 256)
    }
    
    @Test func test_accumulate_fieldWithRollover_accumulatesValueRollover() throws {
        let accumulator = Accumulator()
        
        accumulator.createAccumulatedField(mesgNum: 0, fieldNum: 0, value: 0)
        #expect(accumulator.accumulate(mesgNum: 0, fieldNum: 0, value: 254, bits: 8) == 254)
        #expect(accumulator.accumulate(mesgNum: 0, fieldNum: 0, value: 255, bits: 8) == 255)
        #expect(accumulator.accumulate(mesgNum: 0, fieldNum: 0, value: 0, bits: 8) == 256)
        #expect(accumulator.accumulate(mesgNum: 0, fieldNum: 0, value: 3, bits: 8) == 259)
    }
}

