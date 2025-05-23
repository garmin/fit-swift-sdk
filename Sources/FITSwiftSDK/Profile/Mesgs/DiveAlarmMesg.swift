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


open class DiveAlarmMesg : Mesg {
    public static let messageIndexFieldNum:UInt8 = 254
    public static let depthFieldNum:UInt8 = 0
    public static let timeFieldNum:UInt8 = 1
    public static let enabledFieldNum:UInt8 = 2
    public static let alarmTypeFieldNum:UInt8 = 3
    public static let soundFieldNum:UInt8 = 4
    public static let diveTypesFieldNum:UInt8 = 5
    public static let idFieldNum:UInt8 = 6
    public static let popupEnabledFieldNum:UInt8 = 7
    public static let triggerOnDescentFieldNum:UInt8 = 8
    public static let triggerOnAscentFieldNum:UInt8 = 9
    public static let repeatingFieldNum:UInt8 = 10
    public static let speedFieldNum:UInt8 = 11

	public init() {
        super.init(mesg: DiveAlarmMesg.createDiveAlarmMesg())
    }

    public override init(mesg: Mesg) {
        super.init(mesg: mesg)
    }

    fileprivate override init(name: String, num: UInt16) {
        super.init(name: name, num: num)
    }

	public func getMessageIndex() -> MessageIndex? {
		guard let value = getFieldValue(fieldNum: DiveAlarmMesg.messageIndexFieldNum, index:0) as? UInt16 else {
            return nil
        }
		return value
	}

	public func setMessageIndex(_ value: MessageIndex) throws {
		try setFieldValue(fieldNum: DiveAlarmMesg.messageIndexFieldNum, value: value)
	}

	public func getDepth() -> Float64? {
		guard let value = getFieldValue(fieldNum: DiveAlarmMesg.depthFieldNum, index:0) as? Float64 else {
            return nil
        }
		return value
	}

	public func setDepth(_ value: Float64) throws {
		try setFieldValue(fieldNum: DiveAlarmMesg.depthFieldNum, value: value)
	}

	public func getTime() -> Int32? {
		guard let value = getFieldValue(fieldNum: DiveAlarmMesg.timeFieldNum, index:0) as? Int32 else {
            return nil
        }
		return value
	}

	public func setTime(_ value: Int32) throws {
		try setFieldValue(fieldNum: DiveAlarmMesg.timeFieldNum, value: value)
	}

	public func getEnabled() -> Bool? {
		guard let value = getFieldValue(fieldNum: DiveAlarmMesg.enabledFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return value == 1 ? true : false
	}

	public func setEnabled(_ value: Bool) throws {
		try setFieldValue(fieldNum: DiveAlarmMesg.enabledFieldNum, value: value)
	}

	public func getAlarmType() -> DiveAlarmType? {
		guard let value = getFieldValue(fieldNum: DiveAlarmMesg.alarmTypeFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return DiveAlarmType(rawValue: value) ?? .invalid
	}

	public func setAlarmType(_ value: DiveAlarmType) throws {
		try setFieldValue(fieldNum: DiveAlarmMesg.alarmTypeFieldNum, value: value.rawValue)
	}

	public func getSound() -> Tone? {
		guard let value = getFieldValue(fieldNum: DiveAlarmMesg.soundFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return Tone(rawValue: value) ?? .invalid
	}

	public func setSound(_ value: Tone) throws {
		try setFieldValue(fieldNum: DiveAlarmMesg.soundFieldNum, value: value.rawValue)
	}

	public func getNumDiveTypes() -> UInt8 {
		guard let field = getField(fieldNum: DiveAlarmMesg.diveTypesFieldNum) else {
			return 0
		}

		return field.numValues
	}

	public func getDiveTypes() -> [SubSport?]? {
		guard let field = getField(fieldNum: DiveAlarmMesg.diveTypesFieldNum) else {
			return nil
		}

		let rawValues = field.toArray() as [Any?]
		var values = [SubSport]()
		for rawValue in rawValues {
			values.append(
				SubSport(rawValue: rawValue as! UInt8)!
			)
		}

		return values
	}

	public func getDiveTypes(index: Int) -> SubSport? {
		guard let value = getFieldValue(fieldNum: DiveAlarmMesg.diveTypesFieldNum, index: index) as? UInt8 else {
            return nil
        }
		return SubSport(rawValue: value) ?? .invalid
	}

	public func setDiveTypes(index: Int, value: SubSport) throws {
		try setFieldValue(fieldNum: DiveAlarmMesg.diveTypesFieldNum, value: value.rawValue, index: index)
	}

	public func getId() -> UInt32? {
		guard let value = getFieldValue(fieldNum: DiveAlarmMesg.idFieldNum, index:0) as? UInt32 else {
            return nil
        }
		return value
	}

	public func setId(_ value: UInt32) throws {
		try setFieldValue(fieldNum: DiveAlarmMesg.idFieldNum, value: value)
	}

	public func getPopupEnabled() -> Bool? {
		guard let value = getFieldValue(fieldNum: DiveAlarmMesg.popupEnabledFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return value == 1 ? true : false
	}

	public func setPopupEnabled(_ value: Bool) throws {
		try setFieldValue(fieldNum: DiveAlarmMesg.popupEnabledFieldNum, value: value)
	}

	public func getTriggerOnDescent() -> Bool? {
		guard let value = getFieldValue(fieldNum: DiveAlarmMesg.triggerOnDescentFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return value == 1 ? true : false
	}

	public func setTriggerOnDescent(_ value: Bool) throws {
		try setFieldValue(fieldNum: DiveAlarmMesg.triggerOnDescentFieldNum, value: value)
	}

	public func getTriggerOnAscent() -> Bool? {
		guard let value = getFieldValue(fieldNum: DiveAlarmMesg.triggerOnAscentFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return value == 1 ? true : false
	}

	public func setTriggerOnAscent(_ value: Bool) throws {
		try setFieldValue(fieldNum: DiveAlarmMesg.triggerOnAscentFieldNum, value: value)
	}

	public func getRepeating() -> Bool? {
		guard let value = getFieldValue(fieldNum: DiveAlarmMesg.repeatingFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return value == 1 ? true : false
	}

	public func setRepeating(_ value: Bool) throws {
		try setFieldValue(fieldNum: DiveAlarmMesg.repeatingFieldNum, value: value)
	}

	public func getSpeed() -> Float64? {
		guard let value = getFieldValue(fieldNum: DiveAlarmMesg.speedFieldNum, index:0) as? Float64 else {
            return nil
        }
		return value
	}

	public func setSpeed(_ value: Float64) throws {
		try setFieldValue(fieldNum: DiveAlarmMesg.speedFieldNum, value: value)
	}

	public class func createDiveAlarmMesg() -> DiveAlarmMesg {
        let mesg = DiveAlarmMesg(name: "DiveAlarm", num: Profile.MesgNum.diveAlarm)
		
		mesg.fields[DiveAlarmMesg.messageIndexFieldNum] = Field(name: "MessageIndex", num: DiveAlarmMesg.messageIndexFieldNum, type: BaseType.UINT16.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[DiveAlarmMesg.depthFieldNum] = Field(name: "Depth", num: DiveAlarmMesg.depthFieldNum, type: BaseType.UINT32.rawValue, scale: 1000, offset: 0, units: "m", accumulated: false)
		mesg.fields[DiveAlarmMesg.timeFieldNum] = Field(name: "Time", num: DiveAlarmMesg.timeFieldNum, type: BaseType.SINT32.rawValue, scale: 1, offset: 0, units: "s", accumulated: false)
		mesg.fields[DiveAlarmMesg.enabledFieldNum] = Field(name: "Enabled", num: DiveAlarmMesg.enabledFieldNum, type: BaseType.ENUM.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[DiveAlarmMesg.alarmTypeFieldNum] = Field(name: "AlarmType", num: DiveAlarmMesg.alarmTypeFieldNum, type: BaseType.ENUM.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[DiveAlarmMesg.soundFieldNum] = Field(name: "Sound", num: DiveAlarmMesg.soundFieldNum, type: BaseType.ENUM.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[DiveAlarmMesg.diveTypesFieldNum] = Field(name: "DiveTypes", num: DiveAlarmMesg.diveTypesFieldNum, type: BaseType.ENUM.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[DiveAlarmMesg.idFieldNum] = Field(name: "Id", num: DiveAlarmMesg.idFieldNum, type: BaseType.UINT32.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[DiveAlarmMesg.popupEnabledFieldNum] = Field(name: "PopupEnabled", num: DiveAlarmMesg.popupEnabledFieldNum, type: BaseType.ENUM.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[DiveAlarmMesg.triggerOnDescentFieldNum] = Field(name: "TriggerOnDescent", num: DiveAlarmMesg.triggerOnDescentFieldNum, type: BaseType.ENUM.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[DiveAlarmMesg.triggerOnAscentFieldNum] = Field(name: "TriggerOnAscent", num: DiveAlarmMesg.triggerOnAscentFieldNum, type: BaseType.ENUM.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[DiveAlarmMesg.repeatingFieldNum] = Field(name: "Repeating", num: DiveAlarmMesg.repeatingFieldNum, type: BaseType.ENUM.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[DiveAlarmMesg.speedFieldNum] = Field(name: "Speed", num: DiveAlarmMesg.speedFieldNum, type: BaseType.SINT32.rawValue, scale: 1000, offset: 0, units: "mps", accumulated: false)
        return mesg
    }
}