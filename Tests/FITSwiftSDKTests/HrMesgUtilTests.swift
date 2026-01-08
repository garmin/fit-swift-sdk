/////////////////////////////////////////////////////////////////////////////////////////////
// Copyright 2025 Garmin International, Inc.
// Licensed under the Flexible and Interoperable Data Transfer (FIT) Protocol License; you
// may not use this file except in compliance with the Flexible and Interoperable Data
// Transfer (FIT) Protocol License.
/////////////////////////////////////////////////////////////////////////////////////////////


import XCTest
@testable import FITSwiftSDK

func readFitMessagesFromFile(fileName: String) throws -> FitMessages {
    let fileURL = URL(string: fileName , relativeTo: URL(fileURLWithPath: String(testDataPath)))
    let hrMesgTestActivity = try Data(contentsOf: fileURL!)
    let stream = FITSwiftSDK.InputStream(data: hrMesgTestActivity)
    
    let decoder = Decoder(stream: stream)
    let mesgListener = FitListener()
    decoder.addMesgListener(mesgListener)
    try decoder.read();
    
    return mesgListener.fitMessages
}

final class HrMesgUtilTests: XCTestCase {
    
    func test_expandHeartRates_onTestActivityHrMesgs_returnsExpectedExpandedHeartRates() throws {
        let fitMessages = try readFitMessagesFromFile(fileName: "HrMesgTestActivity.fit")
        
        let heartrates = try HrMesgUtil.expandHeartRates(hrMesgs: fitMessages.hrMesgs)
        
        XCTAssertEqual(heartrates.count, expandedHrMessages.count)
        
        for (index, heartrate) in heartrates.enumerated(){
            let expected = expandedHrMessages[index]
            
            XCTAssertEqual(heartrate.timestamp, expected.timestamp)
            XCTAssertEqual(heartrate.heartRate, expected.heartRate)
        }
    }
    
    func test_mergeHrMesgs_onTestActivityRecordAndHrMesgs_returnsExpectedMergedRecordMesgs() throws {
        let fitMessages = try readFitMessagesFromFile(fileName: "HrMesgTestActivity.fit")
        
        try HrMesgUtil.mergeHeartRates(hrMesgs: fitMessages.hrMesgs, recordMesgs: fitMessages.recordMesgs)
        
        XCTAssertEqual(fitMessages.recordMesgs.count, mergedRecordMessages.count)
        
        for (index, recordMesg) in fitMessages.recordMesgs.enumerated(){
            let expected = mergedRecordMessages[index]
            
            XCTAssertEqual(recordMesg.getTimestamp()?.timestamp, UInt32(expected.timestamp))
            XCTAssertEqual(recordMesg.getHeartRate(), expected.heartRate)
        }
    }
    
    func test_mergeHrMesgs_whenPassingTestFileFitMessages_returnsExpectedMergedRecordMesgs() throws {
        let fitMessages = try readFitMessagesFromFile(fileName: "HrMesgTestActivity.fit")
        
        try HrMesgUtil.mergeHeartRates(fitMessages: fitMessages)
        
        XCTAssertEqual(fitMessages.recordMesgs.count, mergedRecordMessages.count)
        
        for (index, recordMesg) in fitMessages.recordMesgs.enumerated(){
            let expected = mergedRecordMessages[index]
            
            XCTAssertEqual(recordMesg.getTimestamp()?.timestamp, UInt32(expected.timestamp))
            XCTAssertEqual(recordMesg.getHeartRate(), expected.heartRate)
        }
    }
}
