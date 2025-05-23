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


open class AntChannelIdMesg : Mesg {
    public static let channelNumberFieldNum:UInt8 = 0
    public static let deviceTypeFieldNum:UInt8 = 1
    public static let deviceNumberFieldNum:UInt8 = 2
    public static let transmissionTypeFieldNum:UInt8 = 3
    public static let deviceIndexFieldNum:UInt8 = 4

	public init() {
        super.init(mesg: AntChannelIdMesg.createAntChannelIdMesg())
    }

    public override init(mesg: Mesg) {
        super.init(mesg: mesg)
    }

    fileprivate override init(name: String, num: UInt16) {
        super.init(name: name, num: num)
    }

	public func getChannelNumber() -> UInt8? {
		guard let value = getFieldValue(fieldNum: AntChannelIdMesg.channelNumberFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return value
	}

	public func setChannelNumber(_ value: UInt8) throws {
		try setFieldValue(fieldNum: AntChannelIdMesg.channelNumberFieldNum, value: value)
	}

	public func getDeviceType() -> UInt8? {
		guard let value = getFieldValue(fieldNum: AntChannelIdMesg.deviceTypeFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return value
	}

	public func setDeviceType(_ value: UInt8) throws {
		try setFieldValue(fieldNum: AntChannelIdMesg.deviceTypeFieldNum, value: value)
	}

	public func getDeviceNumber() -> UInt16? {
		guard let value = getFieldValue(fieldNum: AntChannelIdMesg.deviceNumberFieldNum, index:0) as? UInt16 else {
            return nil
        }
		return value
	}

	public func setDeviceNumber(_ value: UInt16) throws {
		try setFieldValue(fieldNum: AntChannelIdMesg.deviceNumberFieldNum, value: value)
	}

	public func getTransmissionType() -> UInt8? {
		guard let value = getFieldValue(fieldNum: AntChannelIdMesg.transmissionTypeFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return value
	}

	public func setTransmissionType(_ value: UInt8) throws {
		try setFieldValue(fieldNum: AntChannelIdMesg.transmissionTypeFieldNum, value: value)
	}

	public func getDeviceIndex() -> DeviceIndex? {
		guard let value = getFieldValue(fieldNum: AntChannelIdMesg.deviceIndexFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return value
	}

	public func setDeviceIndex(_ value: DeviceIndex) throws {
		try setFieldValue(fieldNum: AntChannelIdMesg.deviceIndexFieldNum, value: value)
	}

	public class func createAntChannelIdMesg() -> AntChannelIdMesg {
        let mesg = AntChannelIdMesg(name: "AntChannelId", num: Profile.MesgNum.antChannelId)
		
		mesg.fields[AntChannelIdMesg.channelNumberFieldNum] = Field(name: "ChannelNumber", num: AntChannelIdMesg.channelNumberFieldNum, type: BaseType.UINT8.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[AntChannelIdMesg.deviceTypeFieldNum] = Field(name: "DeviceType", num: AntChannelIdMesg.deviceTypeFieldNum, type: BaseType.UINT8Z.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[AntChannelIdMesg.deviceNumberFieldNum] = Field(name: "DeviceNumber", num: AntChannelIdMesg.deviceNumberFieldNum, type: BaseType.UINT16Z.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[AntChannelIdMesg.transmissionTypeFieldNum] = Field(name: "TransmissionType", num: AntChannelIdMesg.transmissionTypeFieldNum, type: BaseType.UINT8Z.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[AntChannelIdMesg.deviceIndexFieldNum] = Field(name: "DeviceIndex", num: AntChannelIdMesg.deviceIndexFieldNum, type: BaseType.UINT8.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
        return mesg
    }
}