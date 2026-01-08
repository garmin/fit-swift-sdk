/////////////////////////////////////////////////////////////////////////////////////////////
// Copyright 2025 Garmin International, Inc.
// Licensed under the Flexible and Interoperable Data Transfer (FIT) Protocol License; you
// may not use this file except in compliance with the Flexible and Interoperable Data
// Transfer (FIT) Protocol License.
/////////////////////////////////////////////////////////////////////////////////////////////


import Foundation
import Testing
@testable import FITSwiftSDK

@Suite
struct DeveloperDataLookupTests {
    var developerDataLookup = DeveloperDataLookup()

    @Test
    func test_developerDataKeyEquatable_whenBothAreIdentical_returnsEqualTrue() throws {
        let developerDataIdMesg = DeveloperDataIdMesg()
        try developerDataIdMesg.setDeveloperDataIndex(0)
        
        let fieldDescriptionMesg = FieldDescriptionMesg()
        try fieldDescriptionMesg.setFieldDefinitionNumber(0)
        
        let devDataKey = DeveloperDataKey(developerDataIdMesg: developerDataIdMesg, fieldDescriptionMesg: fieldDescriptionMesg)
        
        let devDataKeyIdentical = DeveloperDataKey(developerDataIdMesg: developerDataIdMesg, fieldDescriptionMesg: fieldDescriptionMesg)
        
        #expect(devDataKey == devDataKeyIdentical)
        #expect(devDataKey?.hashValue == devDataKeyIdentical?.hashValue)
    }
    
    @Test
    func test_developerDataKeyEquatable_whenBothAreDifferent_returnsEqualFalse() throws {
        let developerDataIdMesg = DeveloperDataIdMesg()
        try developerDataIdMesg.setDeveloperDataIndex(0)
        
        let fieldDescriptionMesg = FieldDescriptionMesg()
        try fieldDescriptionMesg.setFieldDefinitionNumber(0)
        
        let developerDataIdMesgOther = DeveloperDataIdMesg()
        try developerDataIdMesgOther.setDeveloperDataIndex(1)
        
        let fieldDescriptionMesgOther = FieldDescriptionMesg()
        try fieldDescriptionMesgOther.setFieldDefinitionNumber(1)
        
        let devDataKey = DeveloperDataKey(developerDataIdMesg: developerDataIdMesg, fieldDescriptionMesg: fieldDescriptionMesg)
        
        let devDataKeyDifferent = DeveloperDataKey(developerDataIdMesg: developerDataIdMesgOther, fieldDescriptionMesg: fieldDescriptionMesgOther)
        
        #expect(devDataKey != devDataKeyDifferent)
        #expect(devDataKey?.hashValue != devDataKeyDifferent?.hashValue)
    }

    @Test
    func test_developerDataKeyEquatable_whenKeyValuePairsEqualButSwapped_returnsEqualFalse() throws {
        let developerDataIdMesg0 = DeveloperDataIdMesg()
        try developerDataIdMesg0.setDeveloperDataIndex(0)
        
        let fieldDescriptionMesg0 = FieldDescriptionMesg()
        try fieldDescriptionMesg0.setFieldDefinitionNumber(0)
        
        let developerDataIdMesg1 = DeveloperDataIdMesg()
        try developerDataIdMesg1.setDeveloperDataIndex(1)
        
        let fieldDescriptionMesg1 = FieldDescriptionMesg()
        try fieldDescriptionMesg1.setFieldDefinitionNumber(1)
        
        let devDataKey01 = DeveloperDataKey(developerDataIdMesg: developerDataIdMesg0, fieldDescriptionMesg: fieldDescriptionMesg1)
        
        let devDataKey10 = DeveloperDataKey(developerDataIdMesg: developerDataIdMesg1, fieldDescriptionMesg: fieldDescriptionMesg0)
        
        #expect(devDataKey01 != devDataKey10)
        #expect(devDataKey01?.hashValue != devDataKey10?.hashValue)
    }

    @Test
    func test_getDeveloperFieldDefinition_returnsEpxectedDeveloperFieldDefinition() throws {
        let developerDataIdMesg = DeveloperDataIdMesg()
        try developerDataIdMesg.setDeveloperDataIndex(0)
        
        let fieldDescMesg = FieldDescriptionMesg()
        try fieldDescMesg.setDeveloperDataIndex(0)
        try fieldDescMesg.setFieldDefinitionNumber(0)

        developerDataLookup.addDeveloperDataIdMesg(mesg: developerDataIdMesg)
        developerDataLookup.addFieldDescriptionMesg(mesg: fieldDescMesg)
        
        let retrieved = developerDataLookup.getDeveloperFieldDefinition(developerDataIdMesg: developerDataIdMesg, fieldDescriptionMesg: fieldDescMesg)
        #expect(retrieved?.developerDataIdMesg?.getDeveloperDataIndex() == developerDataIdMesg.getDeveloperDataIndex())
        #expect(retrieved?.fieldDescriptionMesg?.getFieldDefinitionNumber() == fieldDescMesg.getFieldDefinitionNumber())
    }

    @Test
    func test_getDeveloperFieldDefintion_WhenEitherMesgWasUnadded_returnsNil() throws {
        let developerDataIdMesg = DeveloperDataIdMesg()
        try developerDataIdMesg.setDeveloperDataIndex(0)
        
        let fieldDescMesg = FieldDescriptionMesg()
        try fieldDescMesg.setDeveloperDataIndex(0)
        try fieldDescMesg.setFieldDefinitionNumber(0)
        
        let unaddedDeveloperDataIdMesg = DeveloperDataIdMesg()
        let unaddedFieldDescMesg = FieldDescriptionMesg()

        developerDataLookup.addDeveloperDataIdMesg(mesg: developerDataIdMesg)
        developerDataLookup.addFieldDescriptionMesg(mesg: fieldDescMesg)
        
        var retrieved = developerDataLookup.getDeveloperFieldDefinition(developerDataIdMesg: unaddedDeveloperDataIdMesg, fieldDescriptionMesg: fieldDescMesg)
        #expect(retrieved == nil)

        retrieved = developerDataLookup.getDeveloperFieldDefinition(developerDataIdMesg: developerDataIdMesg, fieldDescriptionMesg: unaddedFieldDescMesg)
        #expect(retrieved == nil)
    }

    @Test
    func test_addingOverlappingMesgs() throws {
        let developerDataIdMesgOriginal = DeveloperDataIdMesg()
        try developerDataIdMesgOriginal.setDeveloperDataIndex(0)
        
        let fieldDescMesgOriginal = FieldDescriptionMesg()
        try fieldDescMesgOriginal.setDeveloperDataIndex(0)
        try fieldDescMesgOriginal.setFieldDefinitionNumber(0)
        try fieldDescMesgOriginal.setFieldName(index: 0, value: "original")
        
        let developerDataIdMesgNew = DeveloperDataIdMesg()
        try developerDataIdMesgNew.setDeveloperDataIndex(0)
        
        let fieldDescMesgNew = FieldDescriptionMesg()
        try fieldDescMesgNew.setDeveloperDataIndex(0)
        try fieldDescMesgNew.setFieldDefinitionNumber(0)
        try fieldDescMesgNew.setFieldName(index: 0, value: "new")

        developerDataLookup.addDeveloperDataIdMesg(mesg: developerDataIdMesgOriginal)
        developerDataLookup.addFieldDescriptionMesg(mesg: fieldDescMesgOriginal)
        
        var retrieved = developerDataLookup.getDeveloperFieldDefinition(developerDataIdMesg: developerDataIdMesgOriginal, fieldDescriptionMesg: fieldDescMesgOriginal)
        #expect(retrieved?.developerDataIdMesg != nil)
        #expect(retrieved?.fieldDescriptionMesg != nil)
        #expect(retrieved?.fieldDescriptionMesg?.getFieldName() == ["original"])

        // Add a new field description with field definition number of 0, the original should be overwritten
        developerDataLookup.addFieldDescriptionMesg(mesg: fieldDescMesgNew)
        retrieved = developerDataLookup.getDeveloperFieldDefinition(developerDataIdMesg: developerDataIdMesgOriginal, fieldDescriptionMesg: fieldDescMesgOriginal)
        #expect(retrieved?.fieldDescriptionMesg?.getFieldName() == ["new"])

        // Add a new DeveloperDataIdMesg with an existing developerDataIndex, it should erase all connected FieldDescriptionMesgs
        developerDataLookup.addDeveloperDataIdMesg(mesg: developerDataIdMesgNew)
        
        retrieved = developerDataLookup.getDeveloperFieldDefinition(developerDataIdMesg: developerDataIdMesgOriginal, fieldDescriptionMesg: fieldDescMesgOriginal)
        #expect(retrieved == nil)
    }
}
