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


public class Decoder: MesgSource, MesgDefinitionSource {
    private var stream: InputStream
    private var decoderMesgIndex = 0
    private var localMesgDefinitions: [LocalMesgNum: MesgDefinition] = [:]
    private let accumulator = Accumulator()
    
    public enum DecoderError: Error {
        case isNotFitFile
        case crcFailed
        case compressedTimestampDataMessageNotSupported
        case messageDefinitionNotFound(localMesgNum: LocalMesgNum)
    }
    
    public enum DecodeMode{
        case normal
        case skipHeader
        case dataOnly
    }
    
    public init(stream: InputStream) {
        self.stream = stream
    }
    
    // MARK: Integrity Methods
    public class func isFIT(stream: InputStream) throws -> Bool {
        let position = stream.position
        defer {
            try? stream.seek(position: position)
        }
        
        if (!stream.hasBytesAvailable) {
            return false
        }
        
        let fileHeaderSize = stream.peekByte();
        if ([UInt8(FIT.HEADER_WITH_CRC_SIZE), UInt8(FIT.HEADER_WITHOUT_CRC_SIZE)].contains(fileHeaderSize) != true) {
            return false
        }
        
        if (stream.count < fileHeaderSize + FIT.CRC_SIZE) {
            return false
        }
        
        let fileHeader = try FileHeader(stream: stream)
        if (fileHeader.dataType != .fit) {
            return false;
        }
        
        return true;
    }
    
    public func isFIT() throws -> Bool {
        return try Decoder.isFIT(stream: stream)
    }
    
    public func checkIntegrity() throws -> Bool {
        let position = stream.position
        defer {
            try! stream.seek(position: position)
        }
        
        if (try !isFIT()) {
            return false;
        }
        
        let fileHeader = try FileHeader(stream: stream)
        
        if (stream.count < Int(fileHeader.headerSize) + Int(fileHeader.dataSize) + Int(FIT.CRC_SIZE)) {
            return false;
        }
        
        if (fileHeader.headerType == .withCRC && fileHeader.crc != UInt16(0)) {
            let headerBytes = stream[position..<(position + 12)]
            let calculatedFileHeaderCrc =  CrcCalculator.calculateCRC(data: headerBytes)
            
            if(fileHeader.crc != calculatedFileHeaderCrc) {
                return false;
            }
        }
        
        let fileData = stream[position..<(position + Int(fileHeader.headerSize) + Int(fileHeader.dataSize))]
        let calculatedCrc = CrcCalculator.calculateCRC(data: fileData)
        
        try stream.seek(position: position + Int(fileHeader.headerSize) + Int(fileHeader.dataSize))
        let fileCrc: UInt16 = try stream.readNumeric()
        

        if(calculatedCrc != fileCrc) {
            return false;
        }
    
        return true;
    }
    
    // MARK: Decoding Methods
    public func read(decodeMode: DecodeMode = .normal) throws -> Void {
        while(stream.hasBytesAvailable) {
            
            try decodeNextFile(decodeMode: decodeMode);
        }
    }
    
    private func decodeNextFile(decodeMode: DecodeMode) throws -> Void {
        let position = stream.position;
        
        if try ((decodeMode == .normal) && (!isFIT())) {
            throw DecoderError.isNotFitFile
        }
        
        var headerSize: UInt8 = 0
        var dataSize: UInt32 = 0
        
        if (decodeMode == .normal) {
        let fileHeader = try FileHeader(stream: stream)
            headerSize = fileHeader.headerSize
            dataSize = fileHeader.dataSize
        }
        else {
            if (decodeMode == .skipHeader){
                try stream.seek(position:Int(FIT.HEADER_WITH_CRC_SIZE));
            }
            
            headerSize = decodeMode == .skipHeader ? FIT.HEADER_WITH_CRC_SIZE : 0
            dataSize = UInt32(stream.count) - UInt32(headerSize) - UInt32(FIT.CRC_SIZE)
        }
        
        // Read data messages and definitions
        while (stream.position < (UInt32(position) + UInt32(headerSize) + UInt32(dataSize))) {
            try decodeNextRecord();
        }
        
        // Check the CRC
        let fileData = stream[position..<stream.position]
        let calculatedCrc = CrcCalculator.calculateCRC(data: fileData)
        
        let fileCrc: UInt16 = try stream.readNumeric();
        
        if((decodeMode == .normal) && (calculatedCrc != fileCrc)) {
            throw DecoderError.crcFailed
        }
    }
    
    private func decodeNextRecord() throws -> Void {
        let recordHeader = stream.peekByte();
        
        if ((recordHeader & FIT.COMPRESSED_HEADER_MASK) == FIT.COMPRESSED_HEADER_MASK) {
            return try decodeCompressedTimestampDataMessage();
        }
        
        if ((recordHeader & FIT.MESG_DEFINITION_MASK) == FIT.MESG_HEADER_MASK) {
            return try decodeMessage();
        }
        
        if ((recordHeader & FIT.MESG_DEFINITION_MASK) == FIT.MESG_DEFINITION_MASK) {
            return try decodeMessageDefinition();
        }
    }
    
    private func decodeMessageDefinition() throws -> Void {
        let mesgDefinition = try MesgDefinition(stream: stream)
        localMesgDefinitions[mesgDefinition.localMesgNum] = mesgDefinition
        
        broadcastMesgDefinition(mesgDefinition)
    }
    
    private func decodeMessage() throws -> Void {
        let recordHeader: UInt8 = try stream.readNumeric();
        
        let localMesgNum = LocalMesgNum(rawValue: recordHeader & FIT.LOCAL_MESG_NUM_MASK)!
        let mesgDefinition = localMesgDefinitions[localMesgNum]
        
        if (mesgDefinition == nil) {
            throw DecoderError.messageDefinitionNotFound(localMesgNum: localMesgNum)
        }
        
        let mesg = Factory.createMesg(mesgNum: mesgDefinition!.globalMessageNumber)
        
        mesg.decoderMesgIndex = self.decoderMesgIndex
        self.decoderMesgIndex = self.decoderMesgIndex + 1
        
        try mesg.read(stream: stream, mesgDefinition: mesgDefinition!, accumulator: accumulator)
        
        // Add Developer Field Mesgs to Lookup
        switch mesg.mesgNum {
        case MesgNum.developerDataId.rawValue:
            DeveloperDataLookup.shared.addDeveloperDataIdMesg(mesg: mesg as! DeveloperDataIdMesg)
        case MesgNum.fieldDescription.rawValue:
            guard let description = DeveloperDataLookup.shared.addFieldDescriptionMesg(mesg: mesg as! FieldDescriptionMesg) else {
                break
            }
            broadcastDeveloperFieldDescription(description)
        default:
            break
        }
        
        broadcastMesg(mesg)
    }
    
    private func decodeCompressedTimestampDataMessage() throws -> Void {
        throw DecoderError.compressedTimestampDataMessageNotSupported
    }
    
    // MARK: MesgSource
    private struct MesgListenerWeakRef {
        weak var listener: MesgListener?
    }
    
    private var mesgListeners = [ObjectIdentifier : MesgListenerWeakRef]()
    
    public func addMesgListener(_ listener: MesgListener) {
        let id = ObjectIdentifier(listener)
        mesgListeners[id] = MesgListenerWeakRef(listener: listener)
    }
    
    public func removeMesgListener(_ listener: MesgListener) {
        let id = ObjectIdentifier(listener)
        mesgListeners.removeValue(forKey: id)
    }
    
    func broadcastMesg(_ mesg: Mesg) {
        for (id, mesgListenerWeakRef) in mesgListeners {
            guard let mesgListener = mesgListenerWeakRef.listener else {
                mesgListeners.removeValue(forKey: id)
                continue
            }
            
            mesgListener.onMesg(Mesg(mesg: mesg))
        }
    }
    
    // MARK: MesgDefinitionSource
    private struct MesgDefinitionListenerWeakRef {
        weak var listener: MesgDefinitionListener?
    }
    
    private var mesgDefinitionListeners = [ObjectIdentifier : MesgDefinitionListenerWeakRef]()
    
    public func addMesgDefinitionListener(_ listener: MesgDefinitionListener) {
        let id = ObjectIdentifier(listener)
        mesgDefinitionListeners[id] = MesgDefinitionListenerWeakRef(listener: listener)
    }
    
    public func removeMesgDefinitionListener(_ listener: MesgDefinitionListener) {
        let id = ObjectIdentifier(listener)
        mesgDefinitionListeners.removeValue(forKey: id)
    }
    
    func broadcastMesgDefinition(_ mesgDefinition: MesgDefinition) {
        for (id, mesgDefinitionListenerWeakRef) in mesgDefinitionListeners {
            guard let mesgDefinitionListener = mesgDefinitionListenerWeakRef.listener else {
                mesgDefinitionListeners.removeValue(forKey: id)
                continue
            }
            
            mesgDefinitionListener.onMesgDefinition(mesgDefinition)
        }
    }
    
    // MARK: DeveloperFieldDescriptionListener
    private struct DeveloperFieldDescriptionListenerWeakRef {
        weak var listener: DeveloperFieldDescriptionListener?
    }
    
    private var developerFieldDescriptionListeners = [ObjectIdentifier : DeveloperFieldDescriptionListenerWeakRef]()
    
    public func addDeveloperFieldDescriptionListener(_ listener: DeveloperFieldDescriptionListener) {
        let id = ObjectIdentifier(listener)
        developerFieldDescriptionListeners[id] = DeveloperFieldDescriptionListenerWeakRef(listener: listener)
    }
    
    public func removeDeveloperFieldDescriptionListener(_ listener: DeveloperFieldDescriptionListener) {
        let id = ObjectIdentifier(listener)
        developerFieldDescriptionListeners.removeValue(forKey: id)
    }
    
    func broadcastDeveloperFieldDescription(_ description: DeveloperFieldDescription) {
        for (id, developerFieldDescriptionListenerWeakRef) in developerFieldDescriptionListeners {
            guard let developerFieldDescriptionListener = developerFieldDescriptionListenerWeakRef.listener else {
                developerFieldDescriptionListeners.removeValue(forKey: id)
                continue
            }
            
            developerFieldDescriptionListener.onDescription(description)
        }
    }
}
