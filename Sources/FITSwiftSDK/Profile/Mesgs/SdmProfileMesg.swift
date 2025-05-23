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


open class SdmProfileMesg : Mesg {
    public static let messageIndexFieldNum:UInt8 = 254
    public static let enabledFieldNum:UInt8 = 0
    public static let sdmAntIdFieldNum:UInt8 = 1
    public static let sdmCalFactorFieldNum:UInt8 = 2
    public static let odometerFieldNum:UInt8 = 3
    public static let speedSourceFieldNum:UInt8 = 4
    public static let sdmAntIdTransTypeFieldNum:UInt8 = 5
    public static let odometerRolloverFieldNum:UInt8 = 7

	public init() {
        super.init(mesg: SdmProfileMesg.createSdmProfileMesg())
    }

    public override init(mesg: Mesg) {
        super.init(mesg: mesg)
    }

    fileprivate override init(name: String, num: UInt16) {
        super.init(name: name, num: num)
    }

	public func getMessageIndex() -> MessageIndex? {
		guard let value = getFieldValue(fieldNum: SdmProfileMesg.messageIndexFieldNum, index:0) as? UInt16 else {
            return nil
        }
		return value
	}

	public func setMessageIndex(_ value: MessageIndex) throws {
		try setFieldValue(fieldNum: SdmProfileMesg.messageIndexFieldNum, value: value)
	}

	public func getEnabled() -> Bool? {
		guard let value = getFieldValue(fieldNum: SdmProfileMesg.enabledFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return value == 1 ? true : false
	}

	public func setEnabled(_ value: Bool) throws {
		try setFieldValue(fieldNum: SdmProfileMesg.enabledFieldNum, value: value)
	}

	public func getSdmAntId() -> UInt16? {
		guard let value = getFieldValue(fieldNum: SdmProfileMesg.sdmAntIdFieldNum, index:0) as? UInt16 else {
            return nil
        }
		return value
	}

	public func setSdmAntId(_ value: UInt16) throws {
		try setFieldValue(fieldNum: SdmProfileMesg.sdmAntIdFieldNum, value: value)
	}

	public func getSdmCalFactor() -> Float64? {
		guard let value = getFieldValue(fieldNum: SdmProfileMesg.sdmCalFactorFieldNum, index:0) as? Float64 else {
            return nil
        }
		return value
	}

	public func setSdmCalFactor(_ value: Float64) throws {
		try setFieldValue(fieldNum: SdmProfileMesg.sdmCalFactorFieldNum, value: value)
	}

	public func getOdometer() -> Float64? {
		guard let value = getFieldValue(fieldNum: SdmProfileMesg.odometerFieldNum, index:0) as? Float64 else {
            return nil
        }
		return value
	}

	public func setOdometer(_ value: Float64) throws {
		try setFieldValue(fieldNum: SdmProfileMesg.odometerFieldNum, value: value)
	}

	public func getSpeedSource() -> Bool? {
		guard let value = getFieldValue(fieldNum: SdmProfileMesg.speedSourceFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return value == 1 ? true : false
	}

	public func setSpeedSource(_ value: Bool) throws {
		try setFieldValue(fieldNum: SdmProfileMesg.speedSourceFieldNum, value: value)
	}

	public func getSdmAntIdTransType() -> UInt8? {
		guard let value = getFieldValue(fieldNum: SdmProfileMesg.sdmAntIdTransTypeFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return value
	}

	public func setSdmAntIdTransType(_ value: UInt8) throws {
		try setFieldValue(fieldNum: SdmProfileMesg.sdmAntIdTransTypeFieldNum, value: value)
	}

	public func getOdometerRollover() -> UInt8? {
		guard let value = getFieldValue(fieldNum: SdmProfileMesg.odometerRolloverFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return value
	}

	public func setOdometerRollover(_ value: UInt8) throws {
		try setFieldValue(fieldNum: SdmProfileMesg.odometerRolloverFieldNum, value: value)
	}

	public class func createSdmProfileMesg() -> SdmProfileMesg {
        let mesg = SdmProfileMesg(name: "SdmProfile", num: Profile.MesgNum.sdmProfile)
		
		mesg.fields[SdmProfileMesg.messageIndexFieldNum] = Field(name: "MessageIndex", num: SdmProfileMesg.messageIndexFieldNum, type: BaseType.UINT16.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[SdmProfileMesg.enabledFieldNum] = Field(name: "Enabled", num: SdmProfileMesg.enabledFieldNum, type: BaseType.ENUM.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[SdmProfileMesg.sdmAntIdFieldNum] = Field(name: "SdmAntId", num: SdmProfileMesg.sdmAntIdFieldNum, type: BaseType.UINT16Z.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[SdmProfileMesg.sdmCalFactorFieldNum] = Field(name: "SdmCalFactor", num: SdmProfileMesg.sdmCalFactorFieldNum, type: BaseType.UINT16.rawValue, scale: 10, offset: 0, units: "%", accumulated: false)
		mesg.fields[SdmProfileMesg.odometerFieldNum] = Field(name: "Odometer", num: SdmProfileMesg.odometerFieldNum, type: BaseType.UINT32.rawValue, scale: 100, offset: 0, units: "m", accumulated: false)
		mesg.fields[SdmProfileMesg.speedSourceFieldNum] = Field(name: "SpeedSource", num: SdmProfileMesg.speedSourceFieldNum, type: BaseType.ENUM.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[SdmProfileMesg.sdmAntIdTransTypeFieldNum] = Field(name: "SdmAntIdTransType", num: SdmProfileMesg.sdmAntIdTransTypeFieldNum, type: BaseType.UINT8Z.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[SdmProfileMesg.odometerRolloverFieldNum] = Field(name: "OdometerRollover", num: SdmProfileMesg.odometerRolloverFieldNum, type: BaseType.UINT8.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
        return mesg
    }
}