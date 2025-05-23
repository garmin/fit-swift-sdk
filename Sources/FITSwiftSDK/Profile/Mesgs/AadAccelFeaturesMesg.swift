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


open class AadAccelFeaturesMesg : Mesg {
    public static let timestampFieldNum:UInt8 = 253
    public static let timeFieldNum:UInt8 = 0
    public static let energyTotalFieldNum:UInt8 = 1
    public static let zeroCrossCntFieldNum:UInt8 = 2
    public static let instanceFieldNum:UInt8 = 3
    public static let timeAboveThresholdFieldNum:UInt8 = 4

	public init() {
        super.init(mesg: AadAccelFeaturesMesg.createAadAccelFeaturesMesg())
    }

    public override init(mesg: Mesg) {
        super.init(mesg: mesg)
    }

    fileprivate override init(name: String, num: UInt16) {
        super.init(name: name, num: num)
    }

	public func getTimestamp() -> DateTime? {
		guard let value = getFieldValue(fieldNum: AadAccelFeaturesMesg.timestampFieldNum, index:0) as? UInt32 else {
            return nil
        }
		return DateTime(timestamp: value)
	}

	public func setTimestamp(_ value: DateTime) throws {
		try setFieldValue(fieldNum: AadAccelFeaturesMesg.timestampFieldNum, value: value.timestamp)
	}

	public func getTime() -> UInt16? {
		guard let value = getFieldValue(fieldNum: AadAccelFeaturesMesg.timeFieldNum, index:0) as? UInt16 else {
            return nil
        }
		return value
	}

	public func setTime(_ value: UInt16) throws {
		try setFieldValue(fieldNum: AadAccelFeaturesMesg.timeFieldNum, value: value)
	}

	public func getEnergyTotal() -> UInt32? {
		guard let value = getFieldValue(fieldNum: AadAccelFeaturesMesg.energyTotalFieldNum, index:0) as? UInt32 else {
            return nil
        }
		return value
	}

	public func setEnergyTotal(_ value: UInt32) throws {
		try setFieldValue(fieldNum: AadAccelFeaturesMesg.energyTotalFieldNum, value: value)
	}

	public func getZeroCrossCnt() -> UInt16? {
		guard let value = getFieldValue(fieldNum: AadAccelFeaturesMesg.zeroCrossCntFieldNum, index:0) as? UInt16 else {
            return nil
        }
		return value
	}

	public func setZeroCrossCnt(_ value: UInt16) throws {
		try setFieldValue(fieldNum: AadAccelFeaturesMesg.zeroCrossCntFieldNum, value: value)
	}

	public func getInstance() -> UInt8? {
		guard let value = getFieldValue(fieldNum: AadAccelFeaturesMesg.instanceFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return value
	}

	public func setInstance(_ value: UInt8) throws {
		try setFieldValue(fieldNum: AadAccelFeaturesMesg.instanceFieldNum, value: value)
	}

	public func getTimeAboveThreshold() -> Float64? {
		guard let value = getFieldValue(fieldNum: AadAccelFeaturesMesg.timeAboveThresholdFieldNum, index:0) as? Float64 else {
            return nil
        }
		return value
	}

	public func setTimeAboveThreshold(_ value: Float64) throws {
		try setFieldValue(fieldNum: AadAccelFeaturesMesg.timeAboveThresholdFieldNum, value: value)
	}

	public class func createAadAccelFeaturesMesg() -> AadAccelFeaturesMesg {
        let mesg = AadAccelFeaturesMesg(name: "AadAccelFeatures", num: Profile.MesgNum.aadAccelFeatures)
		
		mesg.fields[AadAccelFeaturesMesg.timestampFieldNum] = Field(name: "Timestamp", num: AadAccelFeaturesMesg.timestampFieldNum, type: BaseType.UINT32.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[AadAccelFeaturesMesg.timeFieldNum] = Field(name: "Time", num: AadAccelFeaturesMesg.timeFieldNum, type: BaseType.UINT16.rawValue, scale: 1, offset: 0, units: "s", accumulated: false)
		mesg.fields[AadAccelFeaturesMesg.energyTotalFieldNum] = Field(name: "EnergyTotal", num: AadAccelFeaturesMesg.energyTotalFieldNum, type: BaseType.UINT32.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[AadAccelFeaturesMesg.zeroCrossCntFieldNum] = Field(name: "ZeroCrossCnt", num: AadAccelFeaturesMesg.zeroCrossCntFieldNum, type: BaseType.UINT16.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[AadAccelFeaturesMesg.instanceFieldNum] = Field(name: "Instance", num: AadAccelFeaturesMesg.instanceFieldNum, type: BaseType.UINT8.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[AadAccelFeaturesMesg.timeAboveThresholdFieldNum] = Field(name: "TimeAboveThreshold", num: AadAccelFeaturesMesg.timeAboveThresholdFieldNum, type: BaseType.UINT16.rawValue, scale: 25, offset: 0, units: "s", accumulated: false)
        return mesg
    }
}