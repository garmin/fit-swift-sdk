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


open class ExdScreenConfigurationMesg : Mesg {
    public static let screenIndexFieldNum:UInt8 = 0
    public static let fieldCountFieldNum:UInt8 = 1
    public static let layoutFieldNum:UInt8 = 2
    public static let screenEnabledFieldNum:UInt8 = 3

	public init() {
        super.init(mesg: ExdScreenConfigurationMesg.createExdScreenConfigurationMesg())
    }

    public override init(mesg: Mesg) {
        super.init(mesg: mesg)
    }

    fileprivate override init(name: String, num: UInt16) {
        super.init(name: name, num: num)
    }

	public func getScreenIndex() -> UInt8? {
		guard let value = getFieldValue(fieldNum: ExdScreenConfigurationMesg.screenIndexFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return value
	}

	public func setScreenIndex(_ value: UInt8) throws {
		try setFieldValue(fieldNum: ExdScreenConfigurationMesg.screenIndexFieldNum, value: value)
	}

	public func getFieldCount() -> UInt8? {
		guard let value = getFieldValue(fieldNum: ExdScreenConfigurationMesg.fieldCountFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return value
	}

	public func setFieldCount(_ value: UInt8) throws {
		try setFieldValue(fieldNum: ExdScreenConfigurationMesg.fieldCountFieldNum, value: value)
	}

	public func getLayout() -> ExdLayout? {
		guard let value = getFieldValue(fieldNum: ExdScreenConfigurationMesg.layoutFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return ExdLayout(rawValue: value) ?? .invalid
	}

	public func setLayout(_ value: ExdLayout) throws {
		try setFieldValue(fieldNum: ExdScreenConfigurationMesg.layoutFieldNum, value: value.rawValue)
	}

	public func getScreenEnabled() -> Bool? {
		guard let value = getFieldValue(fieldNum: ExdScreenConfigurationMesg.screenEnabledFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return value == 1 ? true : false
	}

	public func setScreenEnabled(_ value: Bool) throws {
		try setFieldValue(fieldNum: ExdScreenConfigurationMesg.screenEnabledFieldNum, value: value)
	}

	public class func createExdScreenConfigurationMesg() -> ExdScreenConfigurationMesg {
        let mesg = ExdScreenConfigurationMesg(name: "ExdScreenConfiguration", num: Profile.MesgNum.exdScreenConfiguration)
		
		mesg.fields[ExdScreenConfigurationMesg.screenIndexFieldNum] = Field(name: "ScreenIndex", num: ExdScreenConfigurationMesg.screenIndexFieldNum, type: BaseType.UINT8.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[ExdScreenConfigurationMesg.fieldCountFieldNum] = Field(name: "FieldCount", num: ExdScreenConfigurationMesg.fieldCountFieldNum, type: BaseType.UINT8.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[ExdScreenConfigurationMesg.layoutFieldNum] = Field(name: "Layout", num: ExdScreenConfigurationMesg.layoutFieldNum, type: BaseType.ENUM.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[ExdScreenConfigurationMesg.screenEnabledFieldNum] = Field(name: "ScreenEnabled", num: ExdScreenConfigurationMesg.screenEnabledFieldNum, type: BaseType.ENUM.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
        return mesg
    }
}