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


open class ScheduleMesg : Mesg {
    public static let manufacturerFieldNum:UInt8 = 0
    public static let productFieldNum:UInt8 = 1
    public static let serialNumberFieldNum:UInt8 = 2
    public static let timeCreatedFieldNum:UInt8 = 3
    public static let completedFieldNum:UInt8 = 4
    public static let typeFieldNum:UInt8 = 5
    public static let scheduledTimeFieldNum:UInt8 = 6

	private struct ProductSubField {
        public static let faveroProduct:UInt16 = 0
        public static let garminProduct:UInt16 = 1
        public static let subfields:UInt16 = 2
        public static let active:UInt16 = FIT.SUBFIELD_INDEX.ACTIVE_SUBFIELD
        public static let mainField:UInt16 = FIT.SUBFIELD_INDEX.MAIN_FIELD
    }

	public init() {
        super.init(mesg: ScheduleMesg.createScheduleMesg())
    }

    public override init(mesg: Mesg) {
        super.init(mesg: mesg)
    }

    fileprivate override init(name: String, num: UInt16) {
        super.init(name: name, num: num)
    }

	public func getManufacturer() -> Manufacturer? {
		guard let value = getFieldValue(fieldNum: ScheduleMesg.manufacturerFieldNum, index:0) as? UInt16 else {
            return nil
        }
		return Manufacturer(rawValue: value) ?? .invalid
	}

	public func setManufacturer(_ value: Manufacturer) throws {
		try setFieldValue(fieldNum: ScheduleMesg.manufacturerFieldNum, value: value.rawValue)
	}

	public func getProduct() -> UInt16? {
		guard let value = getFieldValue(fieldNum: ScheduleMesg.productFieldNum, index:0) as? UInt16 else {
            return nil
        }
		return value
	}

	public func setProduct(_ value: UInt16) throws {
		try setFieldValue(fieldNum: ScheduleMesg.productFieldNum, value: value)
	}

	public func getFaveroProduct() throws -> FaveroProduct? {
		guard let value = try getFieldValue(fieldNum: ScheduleMesg.productFieldNum, index: 0, subFieldIndex: ProductSubField.faveroProduct).map({UInt16(fitValue: $0)}) else {
			return nil
		}
		
		return FaveroProduct(rawValue: value) ?? .invalid
	}

	public func setFaveroProduct(_ value: FaveroProduct) throws {
		try setFieldValue(fieldNum: ScheduleMesg.productFieldNum, value: value.rawValue, index: 0, subFieldIndex: ProductSubField.faveroProduct )
	}

	public func getGarminProduct() throws -> GarminProduct? {
		guard let value = try getFieldValue(fieldNum: ScheduleMesg.productFieldNum, index: 0, subFieldIndex: ProductSubField.garminProduct).map({UInt16(fitValue: $0)}) else {
			return nil
		}
		
		return GarminProduct(rawValue: value) ?? .invalid
	}

	public func setGarminProduct(_ value: GarminProduct) throws {
		try setFieldValue(fieldNum: ScheduleMesg.productFieldNum, value: value.rawValue, index: 0, subFieldIndex: ProductSubField.garminProduct )
	}

	public func getSerialNumber() -> UInt32? {
		guard let value = getFieldValue(fieldNum: ScheduleMesg.serialNumberFieldNum, index:0) as? UInt32 else {
            return nil
        }
		return value
	}

	public func setSerialNumber(_ value: UInt32) throws {
		try setFieldValue(fieldNum: ScheduleMesg.serialNumberFieldNum, value: value)
	}

	public func getTimeCreated() -> DateTime? {
		guard let value = getFieldValue(fieldNum: ScheduleMesg.timeCreatedFieldNum, index:0) as? UInt32 else {
            return nil
        }
		return DateTime(timestamp: value)
	}

	public func setTimeCreated(_ value: DateTime) throws {
		try setFieldValue(fieldNum: ScheduleMesg.timeCreatedFieldNum, value: value.timestamp)
	}

	public func getCompleted() -> Bool? {
		guard let value = getFieldValue(fieldNum: ScheduleMesg.completedFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return value == 1 ? true : false
	}

	public func setCompleted(_ value: Bool) throws {
		try setFieldValue(fieldNum: ScheduleMesg.completedFieldNum, value: value)
	}

	public func getType() -> Schedule? {
		guard let value = getFieldValue(fieldNum: ScheduleMesg.typeFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return Schedule(rawValue: value) ?? .invalid
	}

	public func setType(_ value: Schedule) throws {
		try setFieldValue(fieldNum: ScheduleMesg.typeFieldNum, value: value.rawValue)
	}

	public func getScheduledTime() -> LocalDateTime? {
		guard let value = getFieldValue(fieldNum: ScheduleMesg.scheduledTimeFieldNum, index:0) as? UInt32 else {
            return nil
        }
		return value
	}

	public func setScheduledTime(_ value: LocalDateTime) throws {
		try setFieldValue(fieldNum: ScheduleMesg.scheduledTimeFieldNum, value: value)
	}

	public class func createScheduleMesg() -> ScheduleMesg {
        let mesg = ScheduleMesg(name: "Schedule", num: Profile.MesgNum.schedule)
		
		mesg.fields[ScheduleMesg.manufacturerFieldNum] = Field(name: "Manufacturer", num: ScheduleMesg.manufacturerFieldNum, type: BaseType.UINT16.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[ScheduleMesg.productFieldNum] = Field(name: "Product", num: ScheduleMesg.productFieldNum, type: BaseType.UINT16.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
        mesg.fields[ScheduleMesg.productFieldNum]?.subFields.append(SubField(name: "FaveroProduct", type: BaseType.UINT16.rawValue, scale: 1, offset: 0, units: ""))
        mesg.fields[ScheduleMesg.productFieldNum]?.subFields[Int(ProductSubField.faveroProduct)].addMap(refFieldNum: 0, refFieldValue: 263)
        mesg.fields[ScheduleMesg.productFieldNum]?.subFields.append(SubField(name: "GarminProduct", type: BaseType.UINT16.rawValue, scale: 1, offset: 0, units: ""))
        mesg.fields[ScheduleMesg.productFieldNum]?.subFields[Int(ProductSubField.garminProduct)].addMap(refFieldNum: 0, refFieldValue: 1)
        mesg.fields[ScheduleMesg.productFieldNum]?.subFields[Int(ProductSubField.garminProduct)].addMap(refFieldNum: 0, refFieldValue: 15)
        mesg.fields[ScheduleMesg.productFieldNum]?.subFields[Int(ProductSubField.garminProduct)].addMap(refFieldNum: 0, refFieldValue: 13)
        mesg.fields[ScheduleMesg.productFieldNum]?.subFields[Int(ProductSubField.garminProduct)].addMap(refFieldNum: 0, refFieldValue: 89)
		mesg.fields[ScheduleMesg.serialNumberFieldNum] = Field(name: "SerialNumber", num: ScheduleMesg.serialNumberFieldNum, type: BaseType.UINT32Z.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[ScheduleMesg.timeCreatedFieldNum] = Field(name: "TimeCreated", num: ScheduleMesg.timeCreatedFieldNum, type: BaseType.UINT32.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[ScheduleMesg.completedFieldNum] = Field(name: "Completed", num: ScheduleMesg.completedFieldNum, type: BaseType.ENUM.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[ScheduleMesg.typeFieldNum] = Field(name: "Type", num: ScheduleMesg.typeFieldNum, type: BaseType.ENUM.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[ScheduleMesg.scheduledTimeFieldNum] = Field(name: "ScheduledTime", num: ScheduleMesg.scheduledTimeFieldNum, type: BaseType.UINT32.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
        return mesg
    }
}