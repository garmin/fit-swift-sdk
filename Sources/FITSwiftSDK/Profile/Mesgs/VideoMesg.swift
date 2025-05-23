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


open class VideoMesg : Mesg {
    public static let urlFieldNum:UInt8 = 0
    public static let hostingProviderFieldNum:UInt8 = 1
    public static let durationFieldNum:UInt8 = 2

	public init() {
        super.init(mesg: VideoMesg.createVideoMesg())
    }

    public override init(mesg: Mesg) {
        super.init(mesg: mesg)
    }

    fileprivate override init(name: String, num: UInt16) {
        super.init(name: name, num: num)
    }

	public func getUrl() -> String? {
		guard let value = getFieldValue(fieldNum: VideoMesg.urlFieldNum, index:0) as? String else {
            return nil
        }
		return value
	}

	public func setUrl(_ value: String) throws {
		try setFieldValue(fieldNum: VideoMesg.urlFieldNum, value: value)
	}

	public func getHostingProvider() -> String? {
		guard let value = getFieldValue(fieldNum: VideoMesg.hostingProviderFieldNum, index:0) as? String else {
            return nil
        }
		return value
	}

	public func setHostingProvider(_ value: String) throws {
		try setFieldValue(fieldNum: VideoMesg.hostingProviderFieldNum, value: value)
	}

	public func getDuration() -> UInt32? {
		guard let value = getFieldValue(fieldNum: VideoMesg.durationFieldNum, index:0) as? UInt32 else {
            return nil
        }
		return value
	}

	public func setDuration(_ value: UInt32) throws {
		try setFieldValue(fieldNum: VideoMesg.durationFieldNum, value: value)
	}

	public class func createVideoMesg() -> VideoMesg {
        let mesg = VideoMesg(name: "Video", num: Profile.MesgNum.video)
		
		mesg.fields[VideoMesg.urlFieldNum] = Field(name: "Url", num: VideoMesg.urlFieldNum, type: BaseType.STRING.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[VideoMesg.hostingProviderFieldNum] = Field(name: "HostingProvider", num: VideoMesg.hostingProviderFieldNum, type: BaseType.STRING.rawValue, scale: 1, offset: 0, units: "", accumulated: false)
		mesg.fields[VideoMesg.durationFieldNum] = Field(name: "Duration", num: VideoMesg.durationFieldNum, type: BaseType.UINT32.rawValue, scale: 1, offset: 0, units: "ms", accumulated: false)
        return mesg
    }
}