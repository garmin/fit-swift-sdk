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


open class HsaAccelerometerDataMesg : Mesg {
    public static let timestampFieldNum:UInt8 = 253
    public static let timestampMsFieldNum:UInt8 = 0
    public static let samplingIntervalFieldNum:UInt8 = 1
    public static let accelXFieldNum:UInt8 = 2
    public static let accelYFieldNum:UInt8 = 3
    public static let accelZFieldNum:UInt8 = 4
    public static let timestamp32kFieldNum:UInt8 = 5

	public init() {
        super.init(mesg: HsaAccelerometerDataMesg.createHsaAccelerometerDataMesg())
    }

    public override init(mesg: Mesg) {
        super.init(mesg: mesg)
    }

    fileprivate override init(name: String, num: UInt16) {
        super.init(name: name, num: num)
    }

	public func getTimestamp() -> DateTime? {
		guard let value = getFieldValue(fieldNum: HsaAccelerometerDataMesg.timestampFieldNum, index:0) as? UInt32 else {
            return nil
        }
		return DateTime(timestamp: value)
	}

	public func setTimestamp(_ value: DateTime) throws {
		try setFieldValue(fieldNum: HsaAccelerometerDataMesg.timestampFieldNum, value: value.timestamp)
	}

	public func getTimestampMs() -> UInt16? {
		guard let value = getFieldValue(fieldNum: HsaAccelerometerDataMesg.timestampMsFieldNum, index:0) as? UInt16 else {
            return nil
        }
		return value
	}

	public func setTimestampMs(_ value: UInt16) throws {
		try setFieldValue(fieldNum: HsaAccelerometerDataMesg.timestampMsFieldNum, value: value)
	}

	public func getSamplingInterval() -> UInt16? {
		guard let value = getFieldValue(fieldNum: HsaAccelerometerDataMesg.samplingIntervalFieldNum, index:0) as? UInt16 else {
            return nil
        }
		return value
	}

	public func setSamplingInterval(_ value: UInt16) throws {
		try setFieldValue(fieldNum: HsaAccelerometerDataMesg.samplingIntervalFieldNum, value: value)
	}

	public func getNumAccelX() -> UInt8 {
		guard let field = getField(fieldNum: HsaAccelerometerDataMesg.accelXFieldNum) else {
			return 0
		}

		return field.numValues
	}

	public func getAccelX() -> [Float64?]? {
		guard let field = getField(fieldNum: HsaAccelerometerDataMesg.accelXFieldNum) else {
			return nil
		}
		return field.toArray() as [Float64?]
	}

	public func getAccelX(index: Int) -> Float64? {
		guard let value = getFieldValue(fieldNum: HsaAccelerometerDataMesg.accelXFieldNum, index: index) as? Float64 else {
            return nil
        }
		return value
	}

	public func setAccelX(index: Int, value: Float64) throws {
		try setFieldValue(fieldNum: HsaAccelerometerDataMesg.accelXFieldNum, value: value, index: index)
	}

	public func getNumAccelY() -> UInt8 {
		guard let field = getField(fieldNum: HsaAccelerometerDataMesg.accelYFieldNum) else {
			return 0
		}

		return field.numValues
	}

	public func getAccelY() -> [Float64?]? {
		guard let field = getField(fieldNum: HsaAccelerometerDataMesg.accelYFieldNum) else {
			return nil
		}
		return field.toArray() as [Float64?]
	}

	public func getAccelY(index: Int) -> Float64? {
		guard let value = getFieldValue(fieldNum: HsaAccelerometerDataMesg.accelYFieldNum, index: index) as? Float64 else {
            return nil
        }
		return value
	}

	public func setAccelY(index: Int, value: Float64) throws {
		try setFieldValue(fieldNum: HsaAccelerometerDataMesg.accelYFieldNum, value: value, index: index)
	}

	public func getNumAccelZ() -> UInt8 {
		guard let field = getField(fieldNum: HsaAccelerometerDataMesg.accelZFieldNum) else {
			return 0
		}

		return field.numValues
	}

	public func getAccelZ() -> [Float64?]? {
		guard let field = getField(fieldNum: HsaAccelerometerDataMesg.accelZFieldNum) else {
			return nil
		}
		return field.toArray() as [Float64?]
	}

	public func getAccelZ(index: Int) -> Float64? {
		guard let value = getFieldValue(fieldNum: HsaAccelerometerDataMesg.accelZFieldNum, index: index) as? Float64 else {
            return nil
        }
		return value
	}

	public func setAccelZ(index: Int, value: Float64) throws {
		try setFieldValue(fieldNum: HsaAccelerometerDataMesg.accelZFieldNum, value: value, index: index)
	}

	public func getTimestamp32k() -> UInt32? {
		guard let value = getFieldValue(fieldNum: HsaAccelerometerDataMesg.timestamp32kFieldNum, index:0) as? UInt32 else {
            return nil
        }
		return value
	}

	public func setTimestamp32k(_ value: UInt32) throws {
		try setFieldValue(fieldNum: HsaAccelerometerDataMesg.timestamp32kFieldNum, value: value)
	}

	public class func createHsaAccelerometerDataMesg() -> HsaAccelerometerDataMesg {
        let mesg = HsaAccelerometerDataMesg(name: "HsaAccelerometerData", num: Profile.MesgNum.hsaAccelerometerData)
		
		mesg.fields[HsaAccelerometerDataMesg.timestampFieldNum] = Field(name: "Timestamp", num: HsaAccelerometerDataMesg.timestampFieldNum, type: BaseType.UINT32.rawValue, scale: 1, offset: 0, units: "s", accumulated: false)
		mesg.fields[HsaAccelerometerDataMesg.timestampMsFieldNum] = Field(name: "TimestampMs", num: HsaAccelerometerDataMesg.timestampMsFieldNum, type: BaseType.UINT16.rawValue, scale: 1, offset: 0, units: "ms", accumulated: false)
		mesg.fields[HsaAccelerometerDataMesg.samplingIntervalFieldNum] = Field(name: "SamplingInterval", num: HsaAccelerometerDataMesg.samplingIntervalFieldNum, type: BaseType.UINT16.rawValue, scale: 1, offset: 0, units: "ms", accumulated: false)
		mesg.fields[HsaAccelerometerDataMesg.accelXFieldNum] = Field(name: "AccelX", num: HsaAccelerometerDataMesg.accelXFieldNum, type: BaseType.SINT16.rawValue, scale: 1.024, offset: 0, units: "mG", accumulated: false)
		mesg.fields[HsaAccelerometerDataMesg.accelYFieldNum] = Field(name: "AccelY", num: HsaAccelerometerDataMesg.accelYFieldNum, type: BaseType.SINT16.rawValue, scale: 1.024, offset: 0, units: "mG", accumulated: false)
		mesg.fields[HsaAccelerometerDataMesg.accelZFieldNum] = Field(name: "AccelZ", num: HsaAccelerometerDataMesg.accelZFieldNum, type: BaseType.SINT16.rawValue, scale: 1.024, offset: 0, units: "mG", accumulated: false)
		mesg.fields[HsaAccelerometerDataMesg.timestamp32kFieldNum] = Field(name: "Timestamp32k", num: HsaAccelerometerDataMesg.timestamp32kFieldNum, type: BaseType.UINT32.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
        return mesg
    }
}