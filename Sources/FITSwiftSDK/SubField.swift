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

class SubField {
    class SubFieldMap {
        private let refFieldNum: UInt8
        private let refFieldValue: UInt64
        
        init(refFieldNum: UInt8, refFieldValue: Any) {
            self.refFieldNum = refFieldNum
            self.refFieldValue = UInt64(fitValue: refFieldValue)
        }
        
        init(subFieldMap: SubFieldMap) {
            self.refFieldNum = subFieldMap.refFieldNum
            self.refFieldValue = subFieldMap.refFieldValue
        }
        
        func canMesgSupport(mesg: Mesg) throws -> Bool {
            guard let field = mesg.getField(fieldNum: UInt8(self.refFieldNum)),
            let value = try field.getValue(index: 0, subFieldIndex:FIT.SUBFIELD_INDEX.MAIN_FIELD) else {
                return false
            }
            
            // Float refvalues are not supported
            if (UInt64(fitValue: value) == refFieldValue){
                return true
            }

            return false
        }
    }
    
    let name: String
    let type: UInt8
    let scale: Float64
    let offset: Float64
    let units: String

    var baseType: BaseType {
        return BaseType(rawValue: type)!
    }
    
    var maps: [SubFieldMap] = []
    var components: [FieldComponent] = []
    
    init(name: String, type: UInt8, scale: Float64, offset: Float64, units: String) {
        self.name = name
        self.type = type
        self.scale = scale
        self.offset = offset
        self.units = units
        self.maps = []
        self.components = []
    }
    
    init(subField: SubField?) {
        if (subField == nil) {
            self.name = "unknown"
            self.type = 0
            self.scale = 1
            self.offset = 0
            self.units = ""
            self.maps = []
            self.components = []
            return
        }
        
        self.name = subField!.name
        self.type = subField!.type
        self.scale = subField!.scale
        self.offset = subField!.offset
        self.units = subField!.units
        
        self.maps = []
        for map in subField!.maps {
            self.maps.append(map)
        }
        self.components = []
        for component in subField!.components {
            self.components.append(component)
        }
    }
    
    var hasComponents: Bool {
        return self.components.count > 0
    }
    
    func addMap(refFieldNum: UInt8, refFieldValue: Any) {
        self.maps.append(SubFieldMap(refFieldNum: refFieldNum, refFieldValue: refFieldValue))
    }
                      
    func addComponent(newComponent: FieldComponent) {
        self.components.append(newComponent)
    }

    public func canMesgSupport(mesg: Mesg) throws -> Bool {
        for map in maps {
            if (try map.canMesgSupport(mesg: mesg)) {
                return true
            }
        }
        return false
    }
                      
}
