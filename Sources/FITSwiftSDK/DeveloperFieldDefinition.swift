/////////////////////////////////////////////////////////////////////////////////////////////
// Copyright 2025 Garmin International, Inc.
// Licensed under the Flexible and Interoperable Data Transfer (FIT) Protocol License; you
// may not use this file except in compliance with the Flexible and Interoperable Data
// Transfer (FIT) Protocol License.
/////////////////////////////////////////////////////////////////////////////////////////////
// ****WARNING****  This file is auto-generated!  Do NOT edit this file.
// Profile Version = 21.171.0Release
// Tag = production/release/21.171.0-0-g57fed75
/////////////////////////////////////////////////////////////////////////////////////////////


import Foundation

public class DeveloperFieldDefinition: Equatable {
    public let fieldDefinitionNumber: UInt8
    public let size: UInt8
    public let developerDataIndex: UInt8
    
    public private(set) var developerDataIdMesg: DeveloperDataIdMesg?
    public private(set) var fieldDescriptionMesg: FieldDescriptionMesg?

    // MARK: Initializers
    public init(fieldDefinitionNumber: UInt8, size: UInt8, developerDataIndex: UInt8) {
        self.fieldDefinitionNumber = fieldDefinitionNumber
        self.size = size
        self.developerDataIndex = developerDataIndex
    }
    
    public convenience init(stream: InputStream) throws {
        let fieldDefinitionNumber: UInt8 = try stream.readNumeric()
        let size: UInt8 = try stream.readNumeric()
        let developerDataIndex: UInt8 = try stream.readNumeric()
        
        guard let developerFieldDefinition = DeveloperDataLookup.shared.getDeveloperFieldDefinition(developerDataIndex: developerDataIndex, fieldDescriptionNumber: fieldDefinitionNumber) else {
            self.init(fieldDefinitionNumber: fieldDefinitionNumber, size: size, developerDataIndex: developerDataIndex)
            return 
        }
        
        self.init(developerFieldDefinition: developerFieldDefinition, size: size)
    }
    
    public convenience init(developerFieldDefinition: DeveloperFieldDefinition, size: UInt8 = 0) {
        self.init(fieldDefinitionNumber: developerFieldDefinition.fieldDefinitionNumber, size: size, developerDataIndex: developerFieldDefinition.developerDataIndex)
        
        self.developerDataIdMesg = developerFieldDefinition.developerDataIdMesg
        self.fieldDescriptionMesg = developerFieldDefinition.fieldDescriptionMesg
    }
    
    public convenience init(developerField: DeveloperField) {
        let developerFieldDefinition = developerField.developerFieldDefinition
        
        self.init(fieldDefinitionNumber: developerFieldDefinition.fieldDefinitionNumber, size: developerField.size, developerDataIndex: developerFieldDefinition.developerDataIndex)
        
        self.developerDataIdMesg = developerFieldDefinition.developerDataIdMesg
        self.fieldDescriptionMesg = developerFieldDefinition.fieldDescriptionMesg
    }
    
    public convenience init(fieldDescriptionMesg: FieldDescriptionMesg, developerDataIdMesg: DeveloperDataIdMesg, size: UInt8) {
        self.init(fieldDefinitionNumber: fieldDescriptionMesg.getFieldDefinitionNumber()!, size: size, developerDataIndex: developerDataIdMesg.getDeveloperDataIndex()!)
        
        self.developerDataIdMesg = developerDataIdMesg
        self.fieldDescriptionMesg = fieldDescriptionMesg
    }
    
    // MARK: Write
    public func write(outputStream: OutputStream) {
        outputStream.append(value: fieldDefinitionNumber)
        outputStream.append(value: size)
        outputStream.append(value: developerDataIndex)
    }

    // MARK: Equatable
    public static func == (lhs: DeveloperFieldDefinition, rhs: DeveloperFieldDefinition) -> Bool {
        return lhs.fieldDefinitionNumber == rhs.fieldDefinitionNumber
            && lhs.size == rhs.size
            && lhs.developerDataIndex == rhs.developerDataIndex
    }
}
