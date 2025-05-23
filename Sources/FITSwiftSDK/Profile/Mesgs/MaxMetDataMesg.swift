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


open class MaxMetDataMesg : Mesg {
    public static let updateTimeFieldNum:UInt8 = 0
    public static let vo2MaxFieldNum:UInt8 = 2
    public static let sportFieldNum:UInt8 = 5
    public static let subSportFieldNum:UInt8 = 6
    public static let maxMetCategoryFieldNum:UInt8 = 8
    public static let calibratedDataFieldNum:UInt8 = 9
    public static let hrSourceFieldNum:UInt8 = 12
    public static let speedSourceFieldNum:UInt8 = 13

	public init() {
        super.init(mesg: MaxMetDataMesg.createMaxMetDataMesg())
    }

    public override init(mesg: Mesg) {
        super.init(mesg: mesg)
    }

    fileprivate override init(name: String, num: UInt16) {
        super.init(name: name, num: num)
    }

	public func getUpdateTime() -> DateTime? {
		guard let value = getFieldValue(fieldNum: MaxMetDataMesg.updateTimeFieldNum, index:0) as? UInt32 else {
            return nil
        }
		return DateTime(timestamp: value)
	}

	public func setUpdateTime(_ value: DateTime) throws {
		try setFieldValue(fieldNum: MaxMetDataMesg.updateTimeFieldNum, value: value.timestamp)
	}

	public func getVo2Max() -> Float64? {
		guard let value = getFieldValue(fieldNum: MaxMetDataMesg.vo2MaxFieldNum, index:0) as? Float64 else {
            return nil
        }
		return value
	}

	public func setVo2Max(_ value: Float64) throws {
		try setFieldValue(fieldNum: MaxMetDataMesg.vo2MaxFieldNum, value: value)
	}

	public func getSport() -> Sport? {
		guard let value = getFieldValue(fieldNum: MaxMetDataMesg.sportFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return Sport(rawValue: value) ?? .invalid
	}

	public func setSport(_ value: Sport) throws {
		try setFieldValue(fieldNum: MaxMetDataMesg.sportFieldNum, value: value.rawValue)
	}

	public func getSubSport() -> SubSport? {
		guard let value = getFieldValue(fieldNum: MaxMetDataMesg.subSportFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return SubSport(rawValue: value) ?? .invalid
	}

	public func setSubSport(_ value: SubSport) throws {
		try setFieldValue(fieldNum: MaxMetDataMesg.subSportFieldNum, value: value.rawValue)
	}

	public func getMaxMetCategory() -> MaxMetCategory? {
		guard let value = getFieldValue(fieldNum: MaxMetDataMesg.maxMetCategoryFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return MaxMetCategory(rawValue: value) ?? .invalid
	}

	public func setMaxMetCategory(_ value: MaxMetCategory) throws {
		try setFieldValue(fieldNum: MaxMetDataMesg.maxMetCategoryFieldNum, value: value.rawValue)
	}

	public func getCalibratedData() -> Bool? {
		guard let value = getFieldValue(fieldNum: MaxMetDataMesg.calibratedDataFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return value == 1 ? true : false
	}

	public func setCalibratedData(_ value: Bool) throws {
		try setFieldValue(fieldNum: MaxMetDataMesg.calibratedDataFieldNum, value: value)
	}

	public func getHrSource() -> MaxMetHeartRateSource? {
		guard let value = getFieldValue(fieldNum: MaxMetDataMesg.hrSourceFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return MaxMetHeartRateSource(rawValue: value) ?? .invalid
	}

	public func setHrSource(_ value: MaxMetHeartRateSource) throws {
		try setFieldValue(fieldNum: MaxMetDataMesg.hrSourceFieldNum, value: value.rawValue)
	}

	public func getSpeedSource() -> MaxMetSpeedSource? {
		guard let value = getFieldValue(fieldNum: MaxMetDataMesg.speedSourceFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return MaxMetSpeedSource(rawValue: value) ?? .invalid
	}

	public func setSpeedSource(_ value: MaxMetSpeedSource) throws {
		try setFieldValue(fieldNum: MaxMetDataMesg.speedSourceFieldNum, value: value.rawValue)
	}

	public class func createMaxMetDataMesg() -> MaxMetDataMesg {
        let mesg = MaxMetDataMesg(name: "MaxMetData", num: Profile.MesgNum.maxMetData)
		
		mesg.fields[MaxMetDataMesg.updateTimeFieldNum] = Field(name: "UpdateTime", num: MaxMetDataMesg.updateTimeFieldNum, type: BaseType.UINT32.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[MaxMetDataMesg.vo2MaxFieldNum] = Field(name: "Vo2Max", num: MaxMetDataMesg.vo2MaxFieldNum, type: BaseType.UINT16.rawValue, scale: 10, offset: 0, units: "mL/kg/min", accumulated: false)
		mesg.fields[MaxMetDataMesg.sportFieldNum] = Field(name: "Sport", num: MaxMetDataMesg.sportFieldNum, type: BaseType.ENUM.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[MaxMetDataMesg.subSportFieldNum] = Field(name: "SubSport", num: MaxMetDataMesg.subSportFieldNum, type: BaseType.ENUM.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[MaxMetDataMesg.maxMetCategoryFieldNum] = Field(name: "MaxMetCategory", num: MaxMetDataMesg.maxMetCategoryFieldNum, type: BaseType.ENUM.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[MaxMetDataMesg.calibratedDataFieldNum] = Field(name: "CalibratedData", num: MaxMetDataMesg.calibratedDataFieldNum, type: BaseType.ENUM.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[MaxMetDataMesg.hrSourceFieldNum] = Field(name: "HrSource", num: MaxMetDataMesg.hrSourceFieldNum, type: BaseType.ENUM.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[MaxMetDataMesg.speedSourceFieldNum] = Field(name: "SpeedSource", num: MaxMetDataMesg.speedSourceFieldNum, type: BaseType.ENUM.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
        return mesg
    }
}