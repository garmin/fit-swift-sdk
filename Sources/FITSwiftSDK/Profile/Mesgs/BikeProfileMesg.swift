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


open class BikeProfileMesg : Mesg {
    public static let messageIndexFieldNum:UInt8 = 254
    public static let nameFieldNum:UInt8 = 0
    public static let sportFieldNum:UInt8 = 1
    public static let subSportFieldNum:UInt8 = 2
    public static let odometerFieldNum:UInt8 = 3
    public static let bikeSpdAntIdFieldNum:UInt8 = 4
    public static let bikeCadAntIdFieldNum:UInt8 = 5
    public static let bikeSpdcadAntIdFieldNum:UInt8 = 6
    public static let bikePowerAntIdFieldNum:UInt8 = 7
    public static let customWheelsizeFieldNum:UInt8 = 8
    public static let autoWheelsizeFieldNum:UInt8 = 9
    public static let bikeWeightFieldNum:UInt8 = 10
    public static let powerCalFactorFieldNum:UInt8 = 11
    public static let autoWheelCalFieldNum:UInt8 = 12
    public static let autoPowerZeroFieldNum:UInt8 = 13
    public static let idFieldNum:UInt8 = 14
    public static let spdEnabledFieldNum:UInt8 = 15
    public static let cadEnabledFieldNum:UInt8 = 16
    public static let spdcadEnabledFieldNum:UInt8 = 17
    public static let powerEnabledFieldNum:UInt8 = 18
    public static let crankLengthFieldNum:UInt8 = 19
    public static let enabledFieldNum:UInt8 = 20
    public static let bikeSpdAntIdTransTypeFieldNum:UInt8 = 21
    public static let bikeCadAntIdTransTypeFieldNum:UInt8 = 22
    public static let bikeSpdcadAntIdTransTypeFieldNum:UInt8 = 23
    public static let bikePowerAntIdTransTypeFieldNum:UInt8 = 24
    public static let odometerRolloverFieldNum:UInt8 = 37
    public static let frontGearNumFieldNum:UInt8 = 38
    public static let frontGearFieldNum:UInt8 = 39
    public static let rearGearNumFieldNum:UInt8 = 40
    public static let rearGearFieldNum:UInt8 = 41
    public static let shimanoDi2EnabledFieldNum:UInt8 = 44

	public init() {
        super.init(mesg: BikeProfileMesg.createBikeProfileMesg())
    }

    public override init(mesg: Mesg) {
        super.init(mesg: mesg)
    }

    fileprivate override init(name: String, num: UInt16) {
        super.init(name: name, num: num)
    }

	public func getMessageIndex() -> MessageIndex? {
		guard let value = getFieldValue(fieldNum: BikeProfileMesg.messageIndexFieldNum, index:0) as? UInt16 else {
            return nil
        }
		return value
	}

	public func setMessageIndex(_ value: MessageIndex) throws {
		try setFieldValue(fieldNum: BikeProfileMesg.messageIndexFieldNum, value: value)
	}

	public func getName() -> String? {
		guard let value = getFieldValue(fieldNum: BikeProfileMesg.nameFieldNum, index:0) as? String else {
            return nil
        }
		return value
	}

	public func setName(_ value: String) throws {
		try setFieldValue(fieldNum: BikeProfileMesg.nameFieldNum, value: value)
	}

	public func getSport() -> Sport? {
		guard let value = getFieldValue(fieldNum: BikeProfileMesg.sportFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return Sport(rawValue: value) ?? .invalid
	}

	public func setSport(_ value: Sport) throws {
		try setFieldValue(fieldNum: BikeProfileMesg.sportFieldNum, value: value.rawValue)
	}

	public func getSubSport() -> SubSport? {
		guard let value = getFieldValue(fieldNum: BikeProfileMesg.subSportFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return SubSport(rawValue: value) ?? .invalid
	}

	public func setSubSport(_ value: SubSport) throws {
		try setFieldValue(fieldNum: BikeProfileMesg.subSportFieldNum, value: value.rawValue)
	}

	public func getOdometer() -> Float64? {
		guard let value = getFieldValue(fieldNum: BikeProfileMesg.odometerFieldNum, index:0) as? Float64 else {
            return nil
        }
		return value
	}

	public func setOdometer(_ value: Float64) throws {
		try setFieldValue(fieldNum: BikeProfileMesg.odometerFieldNum, value: value)
	}

	public func getBikeSpdAntId() -> UInt16? {
		guard let value = getFieldValue(fieldNum: BikeProfileMesg.bikeSpdAntIdFieldNum, index:0) as? UInt16 else {
            return nil
        }
		return value
	}

	public func setBikeSpdAntId(_ value: UInt16) throws {
		try setFieldValue(fieldNum: BikeProfileMesg.bikeSpdAntIdFieldNum, value: value)
	}

	public func getBikeCadAntId() -> UInt16? {
		guard let value = getFieldValue(fieldNum: BikeProfileMesg.bikeCadAntIdFieldNum, index:0) as? UInt16 else {
            return nil
        }
		return value
	}

	public func setBikeCadAntId(_ value: UInt16) throws {
		try setFieldValue(fieldNum: BikeProfileMesg.bikeCadAntIdFieldNum, value: value)
	}

	public func getBikeSpdcadAntId() -> UInt16? {
		guard let value = getFieldValue(fieldNum: BikeProfileMesg.bikeSpdcadAntIdFieldNum, index:0) as? UInt16 else {
            return nil
        }
		return value
	}

	public func setBikeSpdcadAntId(_ value: UInt16) throws {
		try setFieldValue(fieldNum: BikeProfileMesg.bikeSpdcadAntIdFieldNum, value: value)
	}

	public func getBikePowerAntId() -> UInt16? {
		guard let value = getFieldValue(fieldNum: BikeProfileMesg.bikePowerAntIdFieldNum, index:0) as? UInt16 else {
            return nil
        }
		return value
	}

	public func setBikePowerAntId(_ value: UInt16) throws {
		try setFieldValue(fieldNum: BikeProfileMesg.bikePowerAntIdFieldNum, value: value)
	}

	public func getCustomWheelsize() -> Float64? {
		guard let value = getFieldValue(fieldNum: BikeProfileMesg.customWheelsizeFieldNum, index:0) as? Float64 else {
            return nil
        }
		return value
	}

	public func setCustomWheelsize(_ value: Float64) throws {
		try setFieldValue(fieldNum: BikeProfileMesg.customWheelsizeFieldNum, value: value)
	}

	public func getAutoWheelsize() -> Float64? {
		guard let value = getFieldValue(fieldNum: BikeProfileMesg.autoWheelsizeFieldNum, index:0) as? Float64 else {
            return nil
        }
		return value
	}

	public func setAutoWheelsize(_ value: Float64) throws {
		try setFieldValue(fieldNum: BikeProfileMesg.autoWheelsizeFieldNum, value: value)
	}

	public func getBikeWeight() -> Float64? {
		guard let value = getFieldValue(fieldNum: BikeProfileMesg.bikeWeightFieldNum, index:0) as? Float64 else {
            return nil
        }
		return value
	}

	public func setBikeWeight(_ value: Float64) throws {
		try setFieldValue(fieldNum: BikeProfileMesg.bikeWeightFieldNum, value: value)
	}

	public func getPowerCalFactor() -> Float64? {
		guard let value = getFieldValue(fieldNum: BikeProfileMesg.powerCalFactorFieldNum, index:0) as? Float64 else {
            return nil
        }
		return value
	}

	public func setPowerCalFactor(_ value: Float64) throws {
		try setFieldValue(fieldNum: BikeProfileMesg.powerCalFactorFieldNum, value: value)
	}

	public func getAutoWheelCal() -> Bool? {
		guard let value = getFieldValue(fieldNum: BikeProfileMesg.autoWheelCalFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return value == 1 ? true : false
	}

	public func setAutoWheelCal(_ value: Bool) throws {
		try setFieldValue(fieldNum: BikeProfileMesg.autoWheelCalFieldNum, value: value)
	}

	public func getAutoPowerZero() -> Bool? {
		guard let value = getFieldValue(fieldNum: BikeProfileMesg.autoPowerZeroFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return value == 1 ? true : false
	}

	public func setAutoPowerZero(_ value: Bool) throws {
		try setFieldValue(fieldNum: BikeProfileMesg.autoPowerZeroFieldNum, value: value)
	}

	public func getId() -> UInt8? {
		guard let value = getFieldValue(fieldNum: BikeProfileMesg.idFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return value
	}

	public func setId(_ value: UInt8) throws {
		try setFieldValue(fieldNum: BikeProfileMesg.idFieldNum, value: value)
	}

	public func getSpdEnabled() -> Bool? {
		guard let value = getFieldValue(fieldNum: BikeProfileMesg.spdEnabledFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return value == 1 ? true : false
	}

	public func setSpdEnabled(_ value: Bool) throws {
		try setFieldValue(fieldNum: BikeProfileMesg.spdEnabledFieldNum, value: value)
	}

	public func getCadEnabled() -> Bool? {
		guard let value = getFieldValue(fieldNum: BikeProfileMesg.cadEnabledFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return value == 1 ? true : false
	}

	public func setCadEnabled(_ value: Bool) throws {
		try setFieldValue(fieldNum: BikeProfileMesg.cadEnabledFieldNum, value: value)
	}

	public func getSpdcadEnabled() -> Bool? {
		guard let value = getFieldValue(fieldNum: BikeProfileMesg.spdcadEnabledFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return value == 1 ? true : false
	}

	public func setSpdcadEnabled(_ value: Bool) throws {
		try setFieldValue(fieldNum: BikeProfileMesg.spdcadEnabledFieldNum, value: value)
	}

	public func getPowerEnabled() -> Bool? {
		guard let value = getFieldValue(fieldNum: BikeProfileMesg.powerEnabledFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return value == 1 ? true : false
	}

	public func setPowerEnabled(_ value: Bool) throws {
		try setFieldValue(fieldNum: BikeProfileMesg.powerEnabledFieldNum, value: value)
	}

	public func getCrankLength() -> Float64? {
		guard let value = getFieldValue(fieldNum: BikeProfileMesg.crankLengthFieldNum, index:0) as? Float64 else {
            return nil
        }
		return value
	}

	public func setCrankLength(_ value: Float64) throws {
		try setFieldValue(fieldNum: BikeProfileMesg.crankLengthFieldNum, value: value)
	}

	public func getEnabled() -> Bool? {
		guard let value = getFieldValue(fieldNum: BikeProfileMesg.enabledFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return value == 1 ? true : false
	}

	public func setEnabled(_ value: Bool) throws {
		try setFieldValue(fieldNum: BikeProfileMesg.enabledFieldNum, value: value)
	}

	public func getBikeSpdAntIdTransType() -> UInt8? {
		guard let value = getFieldValue(fieldNum: BikeProfileMesg.bikeSpdAntIdTransTypeFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return value
	}

	public func setBikeSpdAntIdTransType(_ value: UInt8) throws {
		try setFieldValue(fieldNum: BikeProfileMesg.bikeSpdAntIdTransTypeFieldNum, value: value)
	}

	public func getBikeCadAntIdTransType() -> UInt8? {
		guard let value = getFieldValue(fieldNum: BikeProfileMesg.bikeCadAntIdTransTypeFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return value
	}

	public func setBikeCadAntIdTransType(_ value: UInt8) throws {
		try setFieldValue(fieldNum: BikeProfileMesg.bikeCadAntIdTransTypeFieldNum, value: value)
	}

	public func getBikeSpdcadAntIdTransType() -> UInt8? {
		guard let value = getFieldValue(fieldNum: BikeProfileMesg.bikeSpdcadAntIdTransTypeFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return value
	}

	public func setBikeSpdcadAntIdTransType(_ value: UInt8) throws {
		try setFieldValue(fieldNum: BikeProfileMesg.bikeSpdcadAntIdTransTypeFieldNum, value: value)
	}

	public func getBikePowerAntIdTransType() -> UInt8? {
		guard let value = getFieldValue(fieldNum: BikeProfileMesg.bikePowerAntIdTransTypeFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return value
	}

	public func setBikePowerAntIdTransType(_ value: UInt8) throws {
		try setFieldValue(fieldNum: BikeProfileMesg.bikePowerAntIdTransTypeFieldNum, value: value)
	}

	public func getOdometerRollover() -> UInt8? {
		guard let value = getFieldValue(fieldNum: BikeProfileMesg.odometerRolloverFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return value
	}

	public func setOdometerRollover(_ value: UInt8) throws {
		try setFieldValue(fieldNum: BikeProfileMesg.odometerRolloverFieldNum, value: value)
	}

	public func getFrontGearNum() -> UInt8? {
		guard let value = getFieldValue(fieldNum: BikeProfileMesg.frontGearNumFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return value
	}

	public func setFrontGearNum(_ value: UInt8) throws {
		try setFieldValue(fieldNum: BikeProfileMesg.frontGearNumFieldNum, value: value)
	}

	public func getNumFrontGear() -> UInt8 {
		guard let field = getField(fieldNum: BikeProfileMesg.frontGearFieldNum) else {
			return 0
		}

		return field.numValues
	}

	public func getFrontGear() -> [UInt8?]? {
		guard let field = getField(fieldNum: BikeProfileMesg.frontGearFieldNum) else {
			return nil
		}
		return field.toArray() as [UInt8?]
	}

	public func getFrontGear(index: Int) -> UInt8? {
		guard let value = getFieldValue(fieldNum: BikeProfileMesg.frontGearFieldNum, index: index) as? UInt8 else {
            return nil
        }
		return value
	}

	public func setFrontGear(index: Int, value: UInt8) throws {
		try setFieldValue(fieldNum: BikeProfileMesg.frontGearFieldNum, value: value, index: index)
	}

	public func getRearGearNum() -> UInt8? {
		guard let value = getFieldValue(fieldNum: BikeProfileMesg.rearGearNumFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return value
	}

	public func setRearGearNum(_ value: UInt8) throws {
		try setFieldValue(fieldNum: BikeProfileMesg.rearGearNumFieldNum, value: value)
	}

	public func getNumRearGear() -> UInt8 {
		guard let field = getField(fieldNum: BikeProfileMesg.rearGearFieldNum) else {
			return 0
		}

		return field.numValues
	}

	public func getRearGear() -> [UInt8?]? {
		guard let field = getField(fieldNum: BikeProfileMesg.rearGearFieldNum) else {
			return nil
		}
		return field.toArray() as [UInt8?]
	}

	public func getRearGear(index: Int) -> UInt8? {
		guard let value = getFieldValue(fieldNum: BikeProfileMesg.rearGearFieldNum, index: index) as? UInt8 else {
            return nil
        }
		return value
	}

	public func setRearGear(index: Int, value: UInt8) throws {
		try setFieldValue(fieldNum: BikeProfileMesg.rearGearFieldNum, value: value, index: index)
	}

	public func getShimanoDi2Enabled() -> Bool? {
		guard let value = getFieldValue(fieldNum: BikeProfileMesg.shimanoDi2EnabledFieldNum, index:0) as? UInt8 else {
            return nil
        }
		return value == 1 ? true : false
	}

	public func setShimanoDi2Enabled(_ value: Bool) throws {
		try setFieldValue(fieldNum: BikeProfileMesg.shimanoDi2EnabledFieldNum, value: value)
	}

	public class func createBikeProfileMesg() -> BikeProfileMesg {
        let mesg = BikeProfileMesg(name: "BikeProfile", num: Profile.MesgNum.bikeProfile)
		
		mesg.fields[BikeProfileMesg.messageIndexFieldNum] = Field(name: "MessageIndex", num: BikeProfileMesg.messageIndexFieldNum, type: BaseType.UINT16.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[BikeProfileMesg.nameFieldNum] = Field(name: "Name", num: BikeProfileMesg.nameFieldNum, type: BaseType.STRING.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[BikeProfileMesg.sportFieldNum] = Field(name: "Sport", num: BikeProfileMesg.sportFieldNum, type: BaseType.ENUM.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[BikeProfileMesg.subSportFieldNum] = Field(name: "SubSport", num: BikeProfileMesg.subSportFieldNum, type: BaseType.ENUM.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[BikeProfileMesg.odometerFieldNum] = Field(name: "Odometer", num: BikeProfileMesg.odometerFieldNum, type: BaseType.UINT32.rawValue, scale: 100, offset: 0, units: "m", accumulated: false)
		mesg.fields[BikeProfileMesg.bikeSpdAntIdFieldNum] = Field(name: "BikeSpdAntId", num: BikeProfileMesg.bikeSpdAntIdFieldNum, type: BaseType.UINT16Z.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[BikeProfileMesg.bikeCadAntIdFieldNum] = Field(name: "BikeCadAntId", num: BikeProfileMesg.bikeCadAntIdFieldNum, type: BaseType.UINT16Z.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[BikeProfileMesg.bikeSpdcadAntIdFieldNum] = Field(name: "BikeSpdcadAntId", num: BikeProfileMesg.bikeSpdcadAntIdFieldNum, type: BaseType.UINT16Z.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[BikeProfileMesg.bikePowerAntIdFieldNum] = Field(name: "BikePowerAntId", num: BikeProfileMesg.bikePowerAntIdFieldNum, type: BaseType.UINT16Z.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[BikeProfileMesg.customWheelsizeFieldNum] = Field(name: "CustomWheelsize", num: BikeProfileMesg.customWheelsizeFieldNum, type: BaseType.UINT16.rawValue, scale: 1000, offset: 0, units: "m", accumulated: false)
		mesg.fields[BikeProfileMesg.autoWheelsizeFieldNum] = Field(name: "AutoWheelsize", num: BikeProfileMesg.autoWheelsizeFieldNum, type: BaseType.UINT16.rawValue, scale: 1000, offset: 0, units: "m", accumulated: false)
		mesg.fields[BikeProfileMesg.bikeWeightFieldNum] = Field(name: "BikeWeight", num: BikeProfileMesg.bikeWeightFieldNum, type: BaseType.UINT16.rawValue, scale: 10, offset: 0, units: "kg", accumulated: false)
		mesg.fields[BikeProfileMesg.powerCalFactorFieldNum] = Field(name: "PowerCalFactor", num: BikeProfileMesg.powerCalFactorFieldNum, type: BaseType.UINT16.rawValue, scale: 10, offset: 0, units: "%", accumulated: false)
		mesg.fields[BikeProfileMesg.autoWheelCalFieldNum] = Field(name: "AutoWheelCal", num: BikeProfileMesg.autoWheelCalFieldNum, type: BaseType.ENUM.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[BikeProfileMesg.autoPowerZeroFieldNum] = Field(name: "AutoPowerZero", num: BikeProfileMesg.autoPowerZeroFieldNum, type: BaseType.ENUM.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[BikeProfileMesg.idFieldNum] = Field(name: "Id", num: BikeProfileMesg.idFieldNum, type: BaseType.UINT8.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[BikeProfileMesg.spdEnabledFieldNum] = Field(name: "SpdEnabled", num: BikeProfileMesg.spdEnabledFieldNum, type: BaseType.ENUM.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[BikeProfileMesg.cadEnabledFieldNum] = Field(name: "CadEnabled", num: BikeProfileMesg.cadEnabledFieldNum, type: BaseType.ENUM.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[BikeProfileMesg.spdcadEnabledFieldNum] = Field(name: "SpdcadEnabled", num: BikeProfileMesg.spdcadEnabledFieldNum, type: BaseType.ENUM.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[BikeProfileMesg.powerEnabledFieldNum] = Field(name: "PowerEnabled", num: BikeProfileMesg.powerEnabledFieldNum, type: BaseType.ENUM.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[BikeProfileMesg.crankLengthFieldNum] = Field(name: "CrankLength", num: BikeProfileMesg.crankLengthFieldNum, type: BaseType.UINT8.rawValue, scale: 2, offset: -110, units: "mm", accumulated: false)
		mesg.fields[BikeProfileMesg.enabledFieldNum] = Field(name: "Enabled", num: BikeProfileMesg.enabledFieldNum, type: BaseType.ENUM.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[BikeProfileMesg.bikeSpdAntIdTransTypeFieldNum] = Field(name: "BikeSpdAntIdTransType", num: BikeProfileMesg.bikeSpdAntIdTransTypeFieldNum, type: BaseType.UINT8Z.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[BikeProfileMesg.bikeCadAntIdTransTypeFieldNum] = Field(name: "BikeCadAntIdTransType", num: BikeProfileMesg.bikeCadAntIdTransTypeFieldNum, type: BaseType.UINT8Z.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[BikeProfileMesg.bikeSpdcadAntIdTransTypeFieldNum] = Field(name: "BikeSpdcadAntIdTransType", num: BikeProfileMesg.bikeSpdcadAntIdTransTypeFieldNum, type: BaseType.UINT8Z.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[BikeProfileMesg.bikePowerAntIdTransTypeFieldNum] = Field(name: "BikePowerAntIdTransType", num: BikeProfileMesg.bikePowerAntIdTransTypeFieldNum, type: BaseType.UINT8Z.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[BikeProfileMesg.odometerRolloverFieldNum] = Field(name: "OdometerRollover", num: BikeProfileMesg.odometerRolloverFieldNum, type: BaseType.UINT8.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[BikeProfileMesg.frontGearNumFieldNum] = Field(name: "FrontGearNum", num: BikeProfileMesg.frontGearNumFieldNum, type: BaseType.UINT8Z.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[BikeProfileMesg.frontGearFieldNum] = Field(name: "FrontGear", num: BikeProfileMesg.frontGearFieldNum, type: BaseType.UINT8Z.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[BikeProfileMesg.rearGearNumFieldNum] = Field(name: "RearGearNum", num: BikeProfileMesg.rearGearNumFieldNum, type: BaseType.UINT8Z.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[BikeProfileMesg.rearGearFieldNum] = Field(name: "RearGear", num: BikeProfileMesg.rearGearFieldNum, type: BaseType.UINT8Z.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[BikeProfileMesg.shimanoDi2EnabledFieldNum] = Field(name: "ShimanoDi2Enabled", num: BikeProfileMesg.shimanoDi2EnabledFieldNum, type: BaseType.ENUM.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
        return mesg
    }
}