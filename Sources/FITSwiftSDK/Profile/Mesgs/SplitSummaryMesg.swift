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


open class SplitSummaryMesg : Mesg {
    public static let messageIndexFieldNum:UInt8 = 254
    public static let splitTypeFieldNum:UInt8 = 0
    public static let numSplitsFieldNum:UInt8 = 3
    public static let totalTimerTimeFieldNum:UInt8 = 4
    public static let totalDistanceFieldNum:UInt8 = 5
    public static let avgSpeedFieldNum:UInt8 = 6
    public static let maxSpeedFieldNum:UInt8 = 7
    public static let totalAscentFieldNum:UInt8 = 8
    public static let totalDescentFieldNum:UInt8 = 9
    public static let avgHeartRateFieldNum:UInt8 = 10
    public static let maxHeartRateFieldNum:UInt8 = 11
    public static let avgVertSpeedFieldNum:UInt8 = 12
    public static let totalCaloriesFieldNum:UInt8 = 13
    public static let totalMovingTimeFieldNum:UInt8 = 77

	public init() {
        super.init(mesg: SplitSummaryMesg.createSplitSummaryMesg())
    }

    public override init(mesg: Mesg) {
        super.init(mesg: mesg)
    }

    fileprivate override init(name: String, num: UInt16) {
        super.init(name: name, num: num)
    }

	public func getMessageIndex() -> MessageIndex? {
		guard let value = getFieldValue(fieldNum: SplitSummaryMesg.messageIndexFieldNum, index:0) as? UInt16 else {
            return nil
        }
		return value
	}

	public func setMessageIndex(_ value: MessageIndex) throws {
		try setFieldValue(fieldNum: SplitSummaryMesg.messageIndexFieldNum, value: value)
	}

	public func getSplitType() -> SplitType? {
		guard let value = getFieldValue(fieldNum: SplitSummaryMesg.splitTypeFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return SplitType(rawValue: value) ?? .invalid
	}

	public func setSplitType(_ value: SplitType) throws {
		try setFieldValue(fieldNum: SplitSummaryMesg.splitTypeFieldNum, value: value.rawValue)
	}

	public func getNumSplits() -> UInt16? {
		guard let value = getFieldValue(fieldNum: SplitSummaryMesg.numSplitsFieldNum, index:0) as? UInt16 else {
            return nil
        }
		return value
	}

	public func setNumSplits(_ value: UInt16) throws {
		try setFieldValue(fieldNum: SplitSummaryMesg.numSplitsFieldNum, value: value)
	}

	public func getTotalTimerTime() -> Float64? {
		guard let value = getFieldValue(fieldNum: SplitSummaryMesg.totalTimerTimeFieldNum, index:0) as? Float64 else {
            return nil
        }
		return value
	}

	public func setTotalTimerTime(_ value: Float64) throws {
		try setFieldValue(fieldNum: SplitSummaryMesg.totalTimerTimeFieldNum, value: value)
	}

	public func getTotalDistance() -> Float64? {
		guard let value = getFieldValue(fieldNum: SplitSummaryMesg.totalDistanceFieldNum, index:0) as? Float64 else {
            return nil
        }
		return value
	}

	public func setTotalDistance(_ value: Float64) throws {
		try setFieldValue(fieldNum: SplitSummaryMesg.totalDistanceFieldNum, value: value)
	}

	public func getAvgSpeed() -> Float64? {
		guard let value = getFieldValue(fieldNum: SplitSummaryMesg.avgSpeedFieldNum, index:0) as? Float64 else {
            return nil
        }
		return value
	}

	public func setAvgSpeed(_ value: Float64) throws {
		try setFieldValue(fieldNum: SplitSummaryMesg.avgSpeedFieldNum, value: value)
	}

	public func getMaxSpeed() -> Float64? {
		guard let value = getFieldValue(fieldNum: SplitSummaryMesg.maxSpeedFieldNum, index:0) as? Float64 else {
            return nil
        }
		return value
	}

	public func setMaxSpeed(_ value: Float64) throws {
		try setFieldValue(fieldNum: SplitSummaryMesg.maxSpeedFieldNum, value: value)
	}

	public func getTotalAscent() -> UInt16? {
		guard let value = getFieldValue(fieldNum: SplitSummaryMesg.totalAscentFieldNum, index:0) as? UInt16 else {
            return nil
        }
		return value
	}

	public func setTotalAscent(_ value: UInt16) throws {
		try setFieldValue(fieldNum: SplitSummaryMesg.totalAscentFieldNum, value: value)
	}

	public func getTotalDescent() -> UInt16? {
		guard let value = getFieldValue(fieldNum: SplitSummaryMesg.totalDescentFieldNum, index:0) as? UInt16 else {
            return nil
        }
		return value
	}

	public func setTotalDescent(_ value: UInt16) throws {
		try setFieldValue(fieldNum: SplitSummaryMesg.totalDescentFieldNum, value: value)
	}

	public func getAvgHeartRate() -> UInt8? {
		guard let value = getFieldValue(fieldNum: SplitSummaryMesg.avgHeartRateFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return value
	}

	public func setAvgHeartRate(_ value: UInt8) throws {
		try setFieldValue(fieldNum: SplitSummaryMesg.avgHeartRateFieldNum, value: value)
	}

	public func getMaxHeartRate() -> UInt8? {
		guard let value = getFieldValue(fieldNum: SplitSummaryMesg.maxHeartRateFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return value
	}

	public func setMaxHeartRate(_ value: UInt8) throws {
		try setFieldValue(fieldNum: SplitSummaryMesg.maxHeartRateFieldNum, value: value)
	}

	public func getAvgVertSpeed() -> Float64? {
		guard let value = getFieldValue(fieldNum: SplitSummaryMesg.avgVertSpeedFieldNum, index:0) as? Float64 else {
            return nil
        }
		return value
	}

	public func setAvgVertSpeed(_ value: Float64) throws {
		try setFieldValue(fieldNum: SplitSummaryMesg.avgVertSpeedFieldNum, value: value)
	}

	public func getTotalCalories() -> UInt32? {
		guard let value = getFieldValue(fieldNum: SplitSummaryMesg.totalCaloriesFieldNum, index:0) as? UInt32 else {
            return nil
        }
		return value
	}

	public func setTotalCalories(_ value: UInt32) throws {
		try setFieldValue(fieldNum: SplitSummaryMesg.totalCaloriesFieldNum, value: value)
	}

	public func getTotalMovingTime() -> Float64? {
		guard let value = getFieldValue(fieldNum: SplitSummaryMesg.totalMovingTimeFieldNum, index:0) as? Float64 else {
            return nil
        }
		return value
	}

	public func setTotalMovingTime(_ value: Float64) throws {
		try setFieldValue(fieldNum: SplitSummaryMesg.totalMovingTimeFieldNum, value: value)
	}

	public class func createSplitSummaryMesg() -> SplitSummaryMesg {
        let mesg = SplitSummaryMesg(name: "SplitSummary", num: Profile.MesgNum.splitSummary)
		
		mesg.fields[SplitSummaryMesg.messageIndexFieldNum] = Field(name: "MessageIndex", num: SplitSummaryMesg.messageIndexFieldNum, type: BaseType.UINT16.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[SplitSummaryMesg.splitTypeFieldNum] = Field(name: "SplitType", num: SplitSummaryMesg.splitTypeFieldNum, type: BaseType.ENUM.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[SplitSummaryMesg.numSplitsFieldNum] = Field(name: "NumSplits", num: SplitSummaryMesg.numSplitsFieldNum, type: BaseType.UINT16.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[SplitSummaryMesg.totalTimerTimeFieldNum] = Field(name: "TotalTimerTime", num: SplitSummaryMesg.totalTimerTimeFieldNum, type: BaseType.UINT32.rawValue, scale: 1000, offset: 0, units: "s", accumulated: false)
		mesg.fields[SplitSummaryMesg.totalDistanceFieldNum] = Field(name: "TotalDistance", num: SplitSummaryMesg.totalDistanceFieldNum, type: BaseType.UINT32.rawValue, scale: 100, offset: 0, units: "m", accumulated: false)
		mesg.fields[SplitSummaryMesg.avgSpeedFieldNum] = Field(name: "AvgSpeed", num: SplitSummaryMesg.avgSpeedFieldNum, type: BaseType.UINT32.rawValue, scale: 1000, offset: 0, units: "m/s", accumulated: false)
		mesg.fields[SplitSummaryMesg.maxSpeedFieldNum] = Field(name: "MaxSpeed", num: SplitSummaryMesg.maxSpeedFieldNum, type: BaseType.UINT32.rawValue, scale: 1000, offset: 0, units: "m/s", accumulated: false)
		mesg.fields[SplitSummaryMesg.totalAscentFieldNum] = Field(name: "TotalAscent", num: SplitSummaryMesg.totalAscentFieldNum, type: BaseType.UINT16.rawValue, scale: 1, offset: 0, units: "m", accumulated: false)
		mesg.fields[SplitSummaryMesg.totalDescentFieldNum] = Field(name: "TotalDescent", num: SplitSummaryMesg.totalDescentFieldNum, type: BaseType.UINT16.rawValue, scale: 1, offset: 0, units: "m", accumulated: false)
		mesg.fields[SplitSummaryMesg.avgHeartRateFieldNum] = Field(name: "AvgHeartRate", num: SplitSummaryMesg.avgHeartRateFieldNum, type: BaseType.UINT8.rawValue, scale: 1, offset: 0, units: "bpm", accumulated: false)
		mesg.fields[SplitSummaryMesg.maxHeartRateFieldNum] = Field(name: "MaxHeartRate", num: SplitSummaryMesg.maxHeartRateFieldNum, type: BaseType.UINT8.rawValue, scale: 1, offset: 0, units: "bpm", accumulated: false)
		mesg.fields[SplitSummaryMesg.avgVertSpeedFieldNum] = Field(name: "AvgVertSpeed", num: SplitSummaryMesg.avgVertSpeedFieldNum, type: BaseType.SINT32.rawValue, scale: 1000, offset: 0, units: "m/s", accumulated: false)
		mesg.fields[SplitSummaryMesg.totalCaloriesFieldNum] = Field(name: "TotalCalories", num: SplitSummaryMesg.totalCaloriesFieldNum, type: BaseType.UINT32.rawValue, scale: 1, offset: 0, units: "kcal", accumulated: false)
		mesg.fields[SplitSummaryMesg.totalMovingTimeFieldNum] = Field(name: "TotalMovingTime", num: SplitSummaryMesg.totalMovingTimeFieldNum, type: BaseType.UINT32.rawValue, scale: 1000, offset: 0, units: "s", accumulated: false)
        return mesg
    }
}