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


open class AccelerometerDataMesg : Mesg {
    public static let timestampFieldNum:UInt8 = 253
    public static let timestampMsFieldNum:UInt8 = 0
    public static let sampleTimeOffsetFieldNum:UInt8 = 1
    public static let accelXFieldNum:UInt8 = 2
    public static let accelYFieldNum:UInt8 = 3
    public static let accelZFieldNum:UInt8 = 4
    public static let calibratedAccelXFieldNum:UInt8 = 5
    public static let calibratedAccelYFieldNum:UInt8 = 6
    public static let calibratedAccelZFieldNum:UInt8 = 7
    public static let compressedCalibratedAccelXFieldNum:UInt8 = 8
    public static let compressedCalibratedAccelYFieldNum:UInt8 = 9
    public static let compressedCalibratedAccelZFieldNum:UInt8 = 10

	public init() {
        super.init(mesg: AccelerometerDataMesg.createAccelerometerDataMesg())
    }

    public override init(mesg: Mesg) {
        super.init(mesg: mesg)
    }

    fileprivate override init(name: String, num: UInt16) {
        super.init(name: name, num: num)
    }

	public func getTimestamp() -> DateTime? {
		guard let value = getFieldValue(fieldNum: AccelerometerDataMesg.timestampFieldNum, index:0) as? UInt32 else {
            return nil
        }
		return DateTime(timestamp: value)
	}

	public func setTimestamp(_ value: DateTime) throws {
		try setFieldValue(fieldNum: AccelerometerDataMesg.timestampFieldNum, value: value.timestamp)
	}

	public func getTimestampMs() -> UInt16? {
		guard let value = getFieldValue(fieldNum: AccelerometerDataMesg.timestampMsFieldNum, index:0) as? UInt16 else {
            return nil
        }
		return value
	}

	public func setTimestampMs(_ value: UInt16) throws {
		try setFieldValue(fieldNum: AccelerometerDataMesg.timestampMsFieldNum, value: value)
	}

	public func getNumSampleTimeOffset() -> UInt8 {
		guard let field = getField(fieldNum: AccelerometerDataMesg.sampleTimeOffsetFieldNum) else {
			return 0
		}

		return field.numValues
	}

	public func getSampleTimeOffset() -> [UInt16?]? {
		guard let field = getField(fieldNum: AccelerometerDataMesg.sampleTimeOffsetFieldNum) else {
			return nil
		}
		return field.toArray() as [UInt16?]
	}

	public func getSampleTimeOffset(index: Int) -> UInt16? {
		guard let value = getFieldValue(fieldNum: AccelerometerDataMesg.sampleTimeOffsetFieldNum, index: index) as? UInt16 else {
            return nil
        }
		return value
	}

	public func setSampleTimeOffset(index: Int, value: UInt16) throws {
		try setFieldValue(fieldNum: AccelerometerDataMesg.sampleTimeOffsetFieldNum, value: value, index: index)
	}

	public func getNumAccelX() -> UInt8 {
		guard let field = getField(fieldNum: AccelerometerDataMesg.accelXFieldNum) else {
			return 0
		}

		return field.numValues
	}

	public func getAccelX() -> [UInt16?]? {
		guard let field = getField(fieldNum: AccelerometerDataMesg.accelXFieldNum) else {
			return nil
		}
		return field.toArray() as [UInt16?]
	}

	public func getAccelX(index: Int) -> UInt16? {
		guard let value = getFieldValue(fieldNum: AccelerometerDataMesg.accelXFieldNum, index: index) as? UInt16 else {
            return nil
        }
		return value
	}

	public func setAccelX(index: Int, value: UInt16) throws {
		try setFieldValue(fieldNum: AccelerometerDataMesg.accelXFieldNum, value: value, index: index)
	}

	public func getNumAccelY() -> UInt8 {
		guard let field = getField(fieldNum: AccelerometerDataMesg.accelYFieldNum) else {
			return 0
		}

		return field.numValues
	}

	public func getAccelY() -> [UInt16?]? {
		guard let field = getField(fieldNum: AccelerometerDataMesg.accelYFieldNum) else {
			return nil
		}
		return field.toArray() as [UInt16?]
	}

	public func getAccelY(index: Int) -> UInt16? {
		guard let value = getFieldValue(fieldNum: AccelerometerDataMesg.accelYFieldNum, index: index) as? UInt16 else {
            return nil
        }
		return value
	}

	public func setAccelY(index: Int, value: UInt16) throws {
		try setFieldValue(fieldNum: AccelerometerDataMesg.accelYFieldNum, value: value, index: index)
	}

	public func getNumAccelZ() -> UInt8 {
		guard let field = getField(fieldNum: AccelerometerDataMesg.accelZFieldNum) else {
			return 0
		}

		return field.numValues
	}

	public func getAccelZ() -> [UInt16?]? {
		guard let field = getField(fieldNum: AccelerometerDataMesg.accelZFieldNum) else {
			return nil
		}
		return field.toArray() as [UInt16?]
	}

	public func getAccelZ(index: Int) -> UInt16? {
		guard let value = getFieldValue(fieldNum: AccelerometerDataMesg.accelZFieldNum, index: index) as? UInt16 else {
            return nil
        }
		return value
	}

	public func setAccelZ(index: Int, value: UInt16) throws {
		try setFieldValue(fieldNum: AccelerometerDataMesg.accelZFieldNum, value: value, index: index)
	}

	public func getNumCalibratedAccelX() -> UInt8 {
		guard let field = getField(fieldNum: AccelerometerDataMesg.calibratedAccelXFieldNum) else {
			return 0
		}

		return field.numValues
	}

	public func getCalibratedAccelX() -> [Float32?]? {
		guard let field = getField(fieldNum: AccelerometerDataMesg.calibratedAccelXFieldNum) else {
			return nil
		}
		return field.toArray() as [Float32?]
	}

	public func getCalibratedAccelX(index: Int) -> Float32? {
		guard let value = getFieldValue(fieldNum: AccelerometerDataMesg.calibratedAccelXFieldNum, index: index) as? Float32 else {
            return nil
        }
		return value
	}

	public func setCalibratedAccelX(index: Int, value: Float32) throws {
		try setFieldValue(fieldNum: AccelerometerDataMesg.calibratedAccelXFieldNum, value: value, index: index)
	}

	public func getNumCalibratedAccelY() -> UInt8 {
		guard let field = getField(fieldNum: AccelerometerDataMesg.calibratedAccelYFieldNum) else {
			return 0
		}

		return field.numValues
	}

	public func getCalibratedAccelY() -> [Float32?]? {
		guard let field = getField(fieldNum: AccelerometerDataMesg.calibratedAccelYFieldNum) else {
			return nil
		}
		return field.toArray() as [Float32?]
	}

	public func getCalibratedAccelY(index: Int) -> Float32? {
		guard let value = getFieldValue(fieldNum: AccelerometerDataMesg.calibratedAccelYFieldNum, index: index) as? Float32 else {
            return nil
        }
		return value
	}

	public func setCalibratedAccelY(index: Int, value: Float32) throws {
		try setFieldValue(fieldNum: AccelerometerDataMesg.calibratedAccelYFieldNum, value: value, index: index)
	}

	public func getNumCalibratedAccelZ() -> UInt8 {
		guard let field = getField(fieldNum: AccelerometerDataMesg.calibratedAccelZFieldNum) else {
			return 0
		}

		return field.numValues
	}

	public func getCalibratedAccelZ() -> [Float32?]? {
		guard let field = getField(fieldNum: AccelerometerDataMesg.calibratedAccelZFieldNum) else {
			return nil
		}
		return field.toArray() as [Float32?]
	}

	public func getCalibratedAccelZ(index: Int) -> Float32? {
		guard let value = getFieldValue(fieldNum: AccelerometerDataMesg.calibratedAccelZFieldNum, index: index) as? Float32 else {
            return nil
        }
		return value
	}

	public func setCalibratedAccelZ(index: Int, value: Float32) throws {
		try setFieldValue(fieldNum: AccelerometerDataMesg.calibratedAccelZFieldNum, value: value, index: index)
	}

	public func getNumCompressedCalibratedAccelX() -> UInt8 {
		guard let field = getField(fieldNum: AccelerometerDataMesg.compressedCalibratedAccelXFieldNum) else {
			return 0
		}

		return field.numValues
	}

	public func getCompressedCalibratedAccelX() -> [Int16?]? {
		guard let field = getField(fieldNum: AccelerometerDataMesg.compressedCalibratedAccelXFieldNum) else {
			return nil
		}
		return field.toArray() as [Int16?]
	}

	public func getCompressedCalibratedAccelX(index: Int) -> Int16? {
		guard let value = getFieldValue(fieldNum: AccelerometerDataMesg.compressedCalibratedAccelXFieldNum, index: index) as? Int16 else {
            return nil
        }
		return value
	}

	public func setCompressedCalibratedAccelX(index: Int, value: Int16) throws {
		try setFieldValue(fieldNum: AccelerometerDataMesg.compressedCalibratedAccelXFieldNum, value: value, index: index)
	}

	public func getNumCompressedCalibratedAccelY() -> UInt8 {
		guard let field = getField(fieldNum: AccelerometerDataMesg.compressedCalibratedAccelYFieldNum) else {
			return 0
		}

		return field.numValues
	}

	public func getCompressedCalibratedAccelY() -> [Int16?]? {
		guard let field = getField(fieldNum: AccelerometerDataMesg.compressedCalibratedAccelYFieldNum) else {
			return nil
		}
		return field.toArray() as [Int16?]
	}

	public func getCompressedCalibratedAccelY(index: Int) -> Int16? {
		guard let value = getFieldValue(fieldNum: AccelerometerDataMesg.compressedCalibratedAccelYFieldNum, index: index) as? Int16 else {
            return nil
        }
		return value
	}

	public func setCompressedCalibratedAccelY(index: Int, value: Int16) throws {
		try setFieldValue(fieldNum: AccelerometerDataMesg.compressedCalibratedAccelYFieldNum, value: value, index: index)
	}

	public func getNumCompressedCalibratedAccelZ() -> UInt8 {
		guard let field = getField(fieldNum: AccelerometerDataMesg.compressedCalibratedAccelZFieldNum) else {
			return 0
		}

		return field.numValues
	}

	public func getCompressedCalibratedAccelZ() -> [Int16?]? {
		guard let field = getField(fieldNum: AccelerometerDataMesg.compressedCalibratedAccelZFieldNum) else {
			return nil
		}
		return field.toArray() as [Int16?]
	}

	public func getCompressedCalibratedAccelZ(index: Int) -> Int16? {
		guard let value = getFieldValue(fieldNum: AccelerometerDataMesg.compressedCalibratedAccelZFieldNum, index: index) as? Int16 else {
            return nil
        }
		return value
	}

	public func setCompressedCalibratedAccelZ(index: Int, value: Int16) throws {
		try setFieldValue(fieldNum: AccelerometerDataMesg.compressedCalibratedAccelZFieldNum, value: value, index: index)
	}

	public class func createAccelerometerDataMesg() -> AccelerometerDataMesg {
        let mesg = AccelerometerDataMesg(name: "AccelerometerData", num: Profile.MesgNum.accelerometerData)
		
		mesg.fields[AccelerometerDataMesg.timestampFieldNum] = Field(name: "Timestamp", num: AccelerometerDataMesg.timestampFieldNum, type: BaseType.UINT32.rawValue, scale: 1, offset: 0, units: "s", accumulated: false)
		mesg.fields[AccelerometerDataMesg.timestampMsFieldNum] = Field(name: "TimestampMs", num: AccelerometerDataMesg.timestampMsFieldNum, type: BaseType.UINT16.rawValue, scale: 1, offset: 0, units: "ms", accumulated: false)
		mesg.fields[AccelerometerDataMesg.sampleTimeOffsetFieldNum] = Field(name: "SampleTimeOffset", num: AccelerometerDataMesg.sampleTimeOffsetFieldNum, type: BaseType.UINT16.rawValue, scale: 1, offset: 0, units: "ms", accumulated: false)
		mesg.fields[AccelerometerDataMesg.accelXFieldNum] = Field(name: "AccelX", num: AccelerometerDataMesg.accelXFieldNum, type: BaseType.UINT16.rawValue, scale: 1, offset: 0, units: "counts", accumulated: false)
		mesg.fields[AccelerometerDataMesg.accelYFieldNum] = Field(name: "AccelY", num: AccelerometerDataMesg.accelYFieldNum, type: BaseType.UINT16.rawValue, scale: 1, offset: 0, units: "counts", accumulated: false)
		mesg.fields[AccelerometerDataMesg.accelZFieldNum] = Field(name: "AccelZ", num: AccelerometerDataMesg.accelZFieldNum, type: BaseType.UINT16.rawValue, scale: 1, offset: 0, units: "counts", accumulated: false)
		mesg.fields[AccelerometerDataMesg.calibratedAccelXFieldNum] = Field(name: "CalibratedAccelX", num: AccelerometerDataMesg.calibratedAccelXFieldNum, type: BaseType.FLOAT32.rawValue, scale: 1, offset: 0, units: "g", accumulated: false)
		mesg.fields[AccelerometerDataMesg.calibratedAccelYFieldNum] = Field(name: "CalibratedAccelY", num: AccelerometerDataMesg.calibratedAccelYFieldNum, type: BaseType.FLOAT32.rawValue, scale: 1, offset: 0, units: "g", accumulated: false)
		mesg.fields[AccelerometerDataMesg.calibratedAccelZFieldNum] = Field(name: "CalibratedAccelZ", num: AccelerometerDataMesg.calibratedAccelZFieldNum, type: BaseType.FLOAT32.rawValue, scale: 1, offset: 0, units: "g", accumulated: false)
		mesg.fields[AccelerometerDataMesg.compressedCalibratedAccelXFieldNum] = Field(name: "CompressedCalibratedAccelX", num: AccelerometerDataMesg.compressedCalibratedAccelXFieldNum, type: BaseType.SINT16.rawValue, scale: 1, offset: 0, units: "mG", accumulated: false)
		mesg.fields[AccelerometerDataMesg.compressedCalibratedAccelYFieldNum] = Field(name: "CompressedCalibratedAccelY", num: AccelerometerDataMesg.compressedCalibratedAccelYFieldNum, type: BaseType.SINT16.rawValue, scale: 1, offset: 0, units: "mG", accumulated: false)
		mesg.fields[AccelerometerDataMesg.compressedCalibratedAccelZFieldNum] = Field(name: "CompressedCalibratedAccelZ", num: AccelerometerDataMesg.compressedCalibratedAccelZFieldNum, type: BaseType.SINT16.rawValue, scale: 1, offset: 0, units: "mG", accumulated: false)
        return mesg
    }
}