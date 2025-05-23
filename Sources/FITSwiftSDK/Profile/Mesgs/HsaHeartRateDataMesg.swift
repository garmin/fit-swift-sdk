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


open class HsaHeartRateDataMesg : Mesg {
    public static let timestampFieldNum:UInt8 = 253
    public static let processingIntervalFieldNum:UInt8 = 0
    public static let statusFieldNum:UInt8 = 1
    public static let heartRateFieldNum:UInt8 = 2

	public init() {
        super.init(mesg: HsaHeartRateDataMesg.createHsaHeartRateDataMesg())
    }

    public override init(mesg: Mesg) {
        super.init(mesg: mesg)
    }

    fileprivate override init(name: String, num: UInt16) {
        super.init(name: name, num: num)
    }

	public func getTimestamp() -> DateTime? {
		guard let value = getFieldValue(fieldNum: HsaHeartRateDataMesg.timestampFieldNum, index:0) as? UInt32 else {
            return nil
        }
		return DateTime(timestamp: value)
	}

	public func setTimestamp(_ value: DateTime) throws {
		try setFieldValue(fieldNum: HsaHeartRateDataMesg.timestampFieldNum, value: value.timestamp)
	}

	public func getProcessingInterval() -> UInt16? {
		guard let value = getFieldValue(fieldNum: HsaHeartRateDataMesg.processingIntervalFieldNum, index:0) as? UInt16 else {
            return nil
        }
		return value
	}

	public func setProcessingInterval(_ value: UInt16) throws {
		try setFieldValue(fieldNum: HsaHeartRateDataMesg.processingIntervalFieldNum, value: value)
	}

	public func getStatus() -> UInt8? {
		guard let value = getFieldValue(fieldNum: HsaHeartRateDataMesg.statusFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return value
	}

	public func setStatus(_ value: UInt8) throws {
		try setFieldValue(fieldNum: HsaHeartRateDataMesg.statusFieldNum, value: value)
	}

	public func getNumHeartRate() -> UInt8 {
		guard let field = getField(fieldNum: HsaHeartRateDataMesg.heartRateFieldNum) else {
			return 0
		}

		return field.numValues
	}

	public func getHeartRate() -> [UInt8?]? {
		guard let field = getField(fieldNum: HsaHeartRateDataMesg.heartRateFieldNum) else {
			return nil
		}
		return field.toArray() as [UInt8?]
	}

	public func getHeartRate(index: Int) -> UInt8? {
		guard let value = getFieldValue(fieldNum: HsaHeartRateDataMesg.heartRateFieldNum, index: index) as? UInt8 else {
            return nil
        }
		return value
	}

	public func setHeartRate(index: Int, value: UInt8) throws {
		try setFieldValue(fieldNum: HsaHeartRateDataMesg.heartRateFieldNum, value: value, index: index)
	}

	public class func createHsaHeartRateDataMesg() -> HsaHeartRateDataMesg {
        let mesg = HsaHeartRateDataMesg(name: "HsaHeartRateData", num: Profile.MesgNum.hsaHeartRateData)
		
		mesg.fields[HsaHeartRateDataMesg.timestampFieldNum] = Field(name: "Timestamp", num: HsaHeartRateDataMesg.timestampFieldNum, type: BaseType.UINT32.rawValue, scale: 1, offset: 0, units: "s", accumulated: false)
		mesg.fields[HsaHeartRateDataMesg.processingIntervalFieldNum] = Field(name: "ProcessingInterval", num: HsaHeartRateDataMesg.processingIntervalFieldNum, type: BaseType.UINT16.rawValue, scale: 1, offset: 0, units: "s", accumulated: false)
		mesg.fields[HsaHeartRateDataMesg.statusFieldNum] = Field(name: "Status", num: HsaHeartRateDataMesg.statusFieldNum, type: BaseType.UINT8.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[HsaHeartRateDataMesg.heartRateFieldNum] = Field(name: "HeartRate", num: HsaHeartRateDataMesg.heartRateFieldNum, type: BaseType.UINT8.rawValue, scale: 1, offset: 0, units: "bpm", accumulated: false)
        return mesg
    }
}