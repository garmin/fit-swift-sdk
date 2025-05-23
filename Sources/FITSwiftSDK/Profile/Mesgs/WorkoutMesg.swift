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


open class WorkoutMesg : Mesg {
    public static let messageIndexFieldNum:UInt8 = 254
    public static let sportFieldNum:UInt8 = 4
    public static let capabilitiesFieldNum:UInt8 = 5
    public static let numValidStepsFieldNum:UInt8 = 6
    public static let wktNameFieldNum:UInt8 = 8
    public static let subSportFieldNum:UInt8 = 11
    public static let poolLengthFieldNum:UInt8 = 14
    public static let poolLengthUnitFieldNum:UInt8 = 15
    public static let wktDescriptionFieldNum:UInt8 = 17

	public init() {
        super.init(mesg: WorkoutMesg.createWorkoutMesg())
    }

    public override init(mesg: Mesg) {
        super.init(mesg: mesg)
    }

    fileprivate override init(name: String, num: UInt16) {
        super.init(name: name, num: num)
    }

	public func getMessageIndex() -> MessageIndex? {
		guard let value = getFieldValue(fieldNum: WorkoutMesg.messageIndexFieldNum, index:0) as? UInt16 else {
            return nil
        }
		return value
	}

	public func setMessageIndex(_ value: MessageIndex) throws {
		try setFieldValue(fieldNum: WorkoutMesg.messageIndexFieldNum, value: value)
	}

	public func getSport() -> Sport? {
		guard let value = getFieldValue(fieldNum: WorkoutMesg.sportFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return Sport(rawValue: value) ?? .invalid
	}

	public func setSport(_ value: Sport) throws {
		try setFieldValue(fieldNum: WorkoutMesg.sportFieldNum, value: value.rawValue)
	}

	public func getCapabilities() -> WorkoutCapabilities? {
		guard let value = getFieldValue(fieldNum: WorkoutMesg.capabilitiesFieldNum, index:0) as? UInt32 else {
            return nil
        }
		return value
	}

	public func setCapabilities(_ value: WorkoutCapabilities) throws {
		try setFieldValue(fieldNum: WorkoutMesg.capabilitiesFieldNum, value: value)
	}

	public func getNumValidSteps() -> UInt16? {
		guard let value = getFieldValue(fieldNum: WorkoutMesg.numValidStepsFieldNum, index:0) as? UInt16 else {
            return nil
        }
		return value
	}

	public func setNumValidSteps(_ value: UInt16) throws {
		try setFieldValue(fieldNum: WorkoutMesg.numValidStepsFieldNum, value: value)
	}

	public func getWktName() -> String? {
		guard let value = getFieldValue(fieldNum: WorkoutMesg.wktNameFieldNum, index:0) as? String else {
            return nil
        }
		return value
	}

	public func setWktName(_ value: String) throws {
		try setFieldValue(fieldNum: WorkoutMesg.wktNameFieldNum, value: value)
	}

	public func getSubSport() -> SubSport? {
		guard let value = getFieldValue(fieldNum: WorkoutMesg.subSportFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return SubSport(rawValue: value) ?? .invalid
	}

	public func setSubSport(_ value: SubSport) throws {
		try setFieldValue(fieldNum: WorkoutMesg.subSportFieldNum, value: value.rawValue)
	}

	public func getPoolLength() -> Float64? {
		guard let value = getFieldValue(fieldNum: WorkoutMesg.poolLengthFieldNum, index:0) as? Float64 else {
            return nil
        }
		return value
	}

	public func setPoolLength(_ value: Float64) throws {
		try setFieldValue(fieldNum: WorkoutMesg.poolLengthFieldNum, value: value)
	}

	public func getPoolLengthUnit() -> DisplayMeasure? {
		guard let value = getFieldValue(fieldNum: WorkoutMesg.poolLengthUnitFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return DisplayMeasure(rawValue: value) ?? .invalid
	}

	public func setPoolLengthUnit(_ value: DisplayMeasure) throws {
		try setFieldValue(fieldNum: WorkoutMesg.poolLengthUnitFieldNum, value: value.rawValue)
	}

	public func getWktDescription() -> String? {
		guard let value = getFieldValue(fieldNum: WorkoutMesg.wktDescriptionFieldNum, index:0) as? String else {
            return nil
        }
		return value
	}

	public func setWktDescription(_ value: String) throws {
		try setFieldValue(fieldNum: WorkoutMesg.wktDescriptionFieldNum, value: value)
	}

	public class func createWorkoutMesg() -> WorkoutMesg {
        let mesg = WorkoutMesg(name: "Workout", num: Profile.MesgNum.workout)
		
		mesg.fields[WorkoutMesg.messageIndexFieldNum] = Field(name: "MessageIndex", num: WorkoutMesg.messageIndexFieldNum, type: BaseType.UINT16.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[WorkoutMesg.sportFieldNum] = Field(name: "Sport", num: WorkoutMesg.sportFieldNum, type: BaseType.ENUM.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[WorkoutMesg.capabilitiesFieldNum] = Field(name: "Capabilities", num: WorkoutMesg.capabilitiesFieldNum, type: BaseType.UINT32Z.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[WorkoutMesg.numValidStepsFieldNum] = Field(name: "NumValidSteps", num: WorkoutMesg.numValidStepsFieldNum, type: BaseType.UINT16.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[WorkoutMesg.wktNameFieldNum] = Field(name: "WktName", num: WorkoutMesg.wktNameFieldNum, type: BaseType.STRING.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[WorkoutMesg.subSportFieldNum] = Field(name: "SubSport", num: WorkoutMesg.subSportFieldNum, type: BaseType.ENUM.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[WorkoutMesg.poolLengthFieldNum] = Field(name: "PoolLength", num: WorkoutMesg.poolLengthFieldNum, type: BaseType.UINT16.rawValue, scale: 100, offset: 0, units: "m", accumulated: false)
		mesg.fields[WorkoutMesg.poolLengthUnitFieldNum] = Field(name: "PoolLengthUnit", num: WorkoutMesg.poolLengthUnitFieldNum, type: BaseType.ENUM.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[WorkoutMesg.wktDescriptionFieldNum] = Field(name: "WktDescription", num: WorkoutMesg.wktDescriptionFieldNum, type: BaseType.STRING.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
        return mesg
    }
}