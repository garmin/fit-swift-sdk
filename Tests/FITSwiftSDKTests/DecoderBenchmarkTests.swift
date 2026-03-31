import XCTest
@testable import FITSwiftSDK

final class DecoderBenchmarkTests: XCTestCase {

    /// A realistic 1-hour activity FIT file encoded in memory (~3600 record messages).
    /// Built once per test class and reused across benchmark runs.
    nonisolated(unsafe) private static var activityData: Data!

    override class func setUp() {
        super.setUp()
        activityData = try! Self.encodeActivityData(recordCount: 3600)
    }

    // MARK: - Benchmarks

    /// Measures full decode (header validation + CRC + message parsing + listener routing).
    func testDecodeFull() throws {
        let data = Self.activityData!

        measure {
            let stream = FITSwiftSDK.InputStream(data: data)
            let decoder = Decoder(stream: stream)
            let listener = FitListener()
            decoder.addMesgListener(listener)
            try! decoder.read(decodeMode: .normal)
        }
    }

    /// Measures decode with header skipped (isolates CRC overhead).
    func testDecodeSkipHeader() throws {
        let data = Self.activityData!

        measure {
            let stream = FITSwiftSDK.InputStream(data: data)
            let decoder = Decoder(stream: stream)
            let listener = FitListener()
            decoder.addMesgListener(listener)
            try! decoder.read(decodeMode: .skipHeader)
        }
    }

    /// Measures decode without any listener (isolates parsing from broadcasting overhead).
    func testDecodeNoListener() throws {
        let data = Self.activityData!

        measure {
            let stream = FITSwiftSDK.InputStream(data: data)
            let decoder = Decoder(stream: stream)
            try! decoder.read(decodeMode: .normal)
        }
    }

    /// Measures decode with the MesgBroadcaster routing to typed listeners.
    func testDecodeWithMesgBroadcaster() throws {
        let data = Self.activityData!

        measure {
            let stream = FITSwiftSDK.InputStream(data: data)
            let decoder = Decoder(stream: stream)
            let broadcaster = MesgBroadcaster()
            let sink = RecordCounter()
            broadcaster.addListener(sink as RecordMesgListener)
            decoder.addMesgListener(broadcaster)
            try! decoder.read(decodeMode: .normal)
        }
    }

    /// Measures CRC calculation in isolation over the full file data.
    func testCRCCalculation() throws {
        let data = Self.activityData!

        measure {
            _ = CrcCalculator.calculateCRC(data: data)
        }
    }

    /// Measures decoding a larger file (~10800 records, simulating a 3-hour activity).
    func testDecodeLargeFile() throws {
        let data = try Self.encodeActivityData(recordCount: 10800)

        measure {
            let stream = FITSwiftSDK.InputStream(data: data)
            let decoder = Decoder(stream: stream)
            let listener = FitListener()
            decoder.addMesgListener(listener)
            try! decoder.read(decodeMode: .normal)
        }
    }

    // MARK: - Helpers

    /// Encodes a synthetic activity FIT file with the given number of record messages.
    private static func encodeActivityData(recordCount: Int) throws -> Data {
        let twoPI = Double.pi * 2.0
        let semicirclesPerMeter = 107.173

        let startTime = DateTime()
        var timestamp = startTime

        let encoder = Encoder()

        // File ID (required)
        let fileIdMesg = FileIdMesg()
        try fileIdMesg.setType(.activity)
        try fileIdMesg.setManufacturer(.development)
        try fileIdMesg.setProduct(0)
        try fileIdMesg.setTimeCreated(startTime)
        try fileIdMesg.setSerialNumber(12345)
        encoder.write(mesg: fileIdMesg)

        // Device Info
        let deviceInfoMesg = DeviceInfoMesg()
        try deviceInfoMesg.setDeviceIndex(DeviceIndexValues.creator)
        try deviceInfoMesg.setManufacturer(.development)
        try deviceInfoMesg.setProduct(0)
        try deviceInfoMesg.setSerialNumber(12345)
        try deviceInfoMesg.setSoftwareVersion(1.0)
        try deviceInfoMesg.setTimestamp(startTime)
        encoder.write(mesg: deviceInfoMesg)

        // Start event
        let eventStart = EventMesg()
        try eventStart.setTimestamp(startTime)
        try eventStart.setEvent(.timer)
        try eventStart.setEventType(.start)
        encoder.write(mesg: eventStart)

        // Record messages
        for i in 0..<recordCount {
            let recordMesg = RecordMesg()
            try recordMesg.setTimestamp(timestamp)
            try recordMesg.setDistance(Float64(i))
            try recordMesg.setSpeed(1.0)
            try recordMesg.setHeartRate(UInt8((sin(twoPI * (0.01 * Double(i) + 10)) + 1.0) * 127.0))
            try recordMesg.setCadence(UInt8(i % 255))
            try recordMesg.setPower(UInt16((i % 255) < 127 ? 150 : 250))
            try recordMesg.setAltitude(Float64(abs(Float(i).truncatingRemainder(dividingBy: 255.0) - 127.0)))
            try recordMesg.setPositionLat(0)
            try recordMesg.setPositionLong(Int32(round(Double(i) * semicirclesPerMeter)))
            encoder.write(mesg: recordMesg)

            timestamp = DateTime(timestamp: timestamp.timestamp + 1)
        }

        // Stop event
        let eventStop = EventMesg()
        try eventStop.setTimestamp(timestamp)
        try eventStop.setEvent(.timer)
        try eventStop.setEventType(.stopAll)
        encoder.write(mesg: eventStop)

        // Lap
        let lapMesg = LapMesg()
        try lapMesg.setMessageIndex(0)
        try lapMesg.setTimestamp(timestamp)
        try lapMesg.setStartTime(startTime)
        try lapMesg.setTotalElapsedTime(Float64(timestamp.timestamp - startTime.timestamp))
        try lapMesg.setTotalTimerTime(Float64(timestamp.timestamp - startTime.timestamp))
        encoder.write(mesg: lapMesg)

        // Session
        let sessionMesg = SessionMesg()
        try sessionMesg.setMessageIndex(0)
        try sessionMesg.setTimestamp(timestamp)
        try sessionMesg.setStartTime(startTime)
        try sessionMesg.setTotalElapsedTime(Float64(timestamp.timestamp - startTime.timestamp))
        try sessionMesg.setTotalTimerTime(Float64(timestamp.timestamp - startTime.timestamp))
        try sessionMesg.setSport(.cycling)
        try sessionMesg.setSubSport(.generic)
        try sessionMesg.setFirstLapIndex(0)
        try sessionMesg.setNumLaps(1)
        encoder.write(mesg: sessionMesg)

        // Activity
        let activityMesg = ActivityMesg()
        try activityMesg.setTimestamp(timestamp)
        try activityMesg.setTotalTimerTime(Float64(timestamp.timestamp - startTime.timestamp))
        try activityMesg.setNumSessions(1)
        try activityMesg.setLocalTimestamp(LocalDateTime(Int(timestamp.timestamp)))
        encoder.write(mesg: activityMesg)

        return encoder.close()
    }
}

// MARK: - Listener that just counts record messages (minimal overhead)

private class RecordCounter: RecordMesgListener {
    var count = 0
    func onMesg(_ mesg: RecordMesg) throws {
        count += 1
    }
}
