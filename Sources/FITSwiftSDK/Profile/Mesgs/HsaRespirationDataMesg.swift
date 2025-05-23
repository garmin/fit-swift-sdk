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


open class HsaRespirationDataMesg : Mesg {
    public static let timestampFieldNum:UInt8 = 253
    public static let processingIntervalFieldNum:UInt8 = 0
    public static let respirationRateFieldNum:UInt8 = 1

	public init() {
        super.init(mesg: HsaRespirationDataMesg.createHsaRespirationDataMesg())
    }

    public override init(mesg: Mesg) {
        super.init(mesg: mesg)
    }

    fileprivate override init(name: String, num: UInt16) {
        super.init(name: name, num: num)
    }

	public func getTimestamp() -> DateTime? {
		guard let value = getFieldValue(fieldNum: HsaRespirationDataMesg.timestampFieldNum, index:0) as? UInt32 else {
            return nil
        }
		return DateTime(timestamp: value)
	}

	public func setTimestamp(_ value: DateTime) throws {
		try setFieldValue(fieldNum: HsaRespirationDataMesg.timestampFieldNum, value: value.timestamp)
	}

	public func getProcessingInterval() -> UInt16? {
		guard let value = getFieldValue(fieldNum: HsaRespirationDataMesg.processingIntervalFieldNum, index:0) as? UInt16 else {
            return nil
        }
		return value
	}

	public func setProcessingInterval(_ value: UInt16) throws {
		try setFieldValue(fieldNum: HsaRespirationDataMesg.processingIntervalFieldNum, value: value)
	}

	public func getNumRespirationRate() -> UInt8 {
		guard let field = getField(fieldNum: HsaRespirationDataMesg.respirationRateFieldNum) else {
			return 0
		}

		return field.numValues
	}

	public func getRespirationRate() -> [Float64?]? {
		guard let field = getField(fieldNum: HsaRespirationDataMesg.respirationRateFieldNum) else {
			return nil
		}
		return field.toArray() as [Float64?]
	}

	public func getRespirationRate(index: Int) -> Float64? {
		guard let value = getFieldValue(fieldNum: HsaRespirationDataMesg.respirationRateFieldNum, index: index) as? Float64 else {
            return nil
        }
		return value
	}

	public func setRespirationRate(index: Int, value: Float64) throws {
		try setFieldValue(fieldNum: HsaRespirationDataMesg.respirationRateFieldNum, value: value, index: index)
	}

	public class func createHsaRespirationDataMesg() -> HsaRespirationDataMesg {
        let mesg = HsaRespirationDataMesg(name: "HsaRespirationData", num: Profile.MesgNum.hsaRespirationData)
		
		mesg.fields[HsaRespirationDataMesg.timestampFieldNum] = Field(name: "Timestamp", num: HsaRespirationDataMesg.timestampFieldNum, type: BaseType.UINT32.rawValue, scale: 1, offset: 0, units: "s", accumulated: false)
		mesg.fields[HsaRespirationDataMesg.processingIntervalFieldNum] = Field(name: "ProcessingInterval", num: HsaRespirationDataMesg.processingIntervalFieldNum, type: BaseType.UINT16.rawValue, scale: 1, offset: 0, units: "s", accumulated: false)
		mesg.fields[HsaRespirationDataMesg.respirationRateFieldNum] = Field(name: "RespirationRate", num: HsaRespirationDataMesg.respirationRateFieldNum, type: BaseType.SINT16.rawValue, scale: 100, offset: 0, units: "breaths/min", accumulated: false)
        return mesg
    }
}