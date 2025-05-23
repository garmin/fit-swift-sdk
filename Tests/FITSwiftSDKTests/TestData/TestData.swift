/////////////////////////////////////////////////////////////////////////////////////////////
// Copyright 2025 Garmin International, Inc.
// Licensed under the Flexible and Interoperable Data Transfer (FIT) Protocol License; you
// may not use this file except in compliance with the Flexible and Interoperable Data
// Transfer (FIT) Protocol License.
/////////////////////////////////////////////////////////////////////////////////////////////


import Foundation

let fitFileShort = Data([
    0x0E, 0x20, 0x8B, 0x08, 0x24, 0x00, 0x00, 0x00, 0x2E, 0x46, 0x49, 0x54, 0x8E, 0xA3, // File Header - 14 Bytes
    0x40, 0x00, 0x00, 0x00, 0x00, 0x04, 0x00, 0x01, 0x00, 0x01, 0x02, 0x84, 0x04, 0x04, 0x86, 0x08, 0x0A, 0x07, // Message Definition - 18 bytes
    0x00, 0x04, 0x01, 0x00, 0x00, 0xCA, 0x9A, 0x3B, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69, 0x00, // Message - 18 bytes
    0x5D, 0xF2]) // CRC - 2 bytes

let fitFileShortInvalidHeader = Data([
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // File Header
    0x40, 0x00, 0x00, 0x00, 0x00, 0x04, 0x00, 0x01, 0x00, 0x01, 0x02, 0x84, 0x04, 0x04, 0x86, 0x08, 0x0A, 0x07, // Message Definition
    0x00, 0x04, 0x01, 0x00, 0x00, 0xCA, 0x9A, 0x3B, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69, 0x00, // Message
    0x5D, 0xF2
]) // CRC

let fitFileShortDataOnly = Data([
    0x40, 0x00, 0x00, 0x00, 0x00, 0x04, 0x00, 0x01, 0x00, 0x01, 0x02, 0x84, 0x04, 0x04, 0x86, 0x08, 0x0A, 0x07, // Message Definition
    0x00, 0x04, 0x01, 0x00, 0x00, 0xCA, 0x9A, 0x3B, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69, 0x00, // Message
    0x5D, 0xF2
]) // CRC

let fitFileShortInvalidCRC = Data([
    0x0E, 0x20, 0x8B, 0x08, 0x24, 0x00, 0x00, 0x00, 0x2E, 0x46, 0x49, 0x54, 0x8E, 0xA3, // File Header
    0x40, 0x00, 0x00, 0x00, 0x00, 0x04, 0x00, 0x01, 0x00, 0x01, 0x02, 0x84, 0x04, 0x04, 0x86, 0x08, 0x0A, 0x07, // Message Definition
    0x00, 0x04, 0x01, 0x00, 0x00, 0xCA, 0x9A, 0x3B, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69, 0x00, // Message
    0x00, 0x00
]) // CRC

let fitFileShortDevData = Data([
    0x0E, 0x20, 0x9A, 0x52, 0x4C, 0x00, 0x00, 0x00, 0x2E, 0x46, 0x49, 0x54,
    0x5B, 0xDE, 0x40, 0x00, 0x00, 0xCF, 0x00, 0x01, 0x03, 0x01, 0x02, 0x00,
    0x00, 0x40, 0x00, 0x00, 0xCE, 0x00, 0x07, 0x00, 0x01, 0x02, 0x01, 0x01,
    0x02, 0x02, 0x01, 0x02, 0x03, 0x0B, 0x07, 0x08, 0x04, 0x07, 0x0F, 0x01,
    0x02, 0x0E, 0x02, 0x84, 0x00, 0x00, 0x01, 0x02, 0x48, 0x65, 0x61, 0x72,
    0x74, 0x20, 0x52, 0x61, 0x74, 0x65, 0x00, 0x62, 0x70, 0x6D, 0x00, 0x03,
    0x14, 0x00, 0x60, 0x00, 0x00, 0x14, 0x00, 0x01, 0x03, 0x01, 0x02, 0x01,
    0x01, 0x01, 0x00, 0x00, 0x3C, 0x3F, 0xEF, 0x35
])

let fitFileShortDevDataLittleEndian = Data([
    0x0E, 0x20, 0x9A, 0x52, 0x45, 0x00, 0x00, 0x00, 0x2E, 0x46, 0x49, 0x54,
    0x9B, 0xB4, 0x40, 0x00, 0x00, 0xCF, 0x00, 0x01, 0x03, 0x01, 0x02, 0x00,
    0x00, 0x40, 0x00, 0x00, 0xCE, 0x00, 0x06, 0x00, 0x01, 0x02, 0x01, 0x01,
    0x02, 0x02, 0x01, 0x02, 0x03, 0x06, 0x07, 0x08, 0x04, 0x07, 0x0E, 0x02,
    0x84, 0x00, 0x00, 0x01, 0x84, 0x44, 0x65, 0x76, 0x48, 0x72, 0x00, 0x62,
    0x70, 0x6D, 0x00, 0x14, 0x00, 0x60, 0x00, 0x00, 0x14, 0x00, 0x01, 0x07,
    0x02, 0x84, 0x01, 0x01, 0x02, 0x00, 0x00, 0xCD, 0xAB, 0x34, 0x12, 0x1F,
    0xFB
])

let fitFileShortDevDataBigEndian = Data([
    0x0E, 0x20, 0x99, 0x52, 0x45, 0x00, 0x00, 0x00, 0x2E, 0x46, 0x49, 0x54,
    0x6B, 0xBB, 0x40, 0x00, 0x01, 0x00, 0xCF, 0x01, 0x03, 0x01, 0x02, 0x00,
    0x00, 0x40, 0x00, 0x01, 0x00, 0xCE, 0x06, 0x00, 0x01, 0x02, 0x01, 0x01,
    0x02, 0x02, 0x01, 0x02, 0x03, 0x06, 0x07, 0x08, 0x04, 0x07, 0x0E, 0x02,
    0x84, 0x00, 0x00, 0x01, 0x84, 0x44, 0x65, 0x76, 0x48, 0x72, 0x00, 0x62,
    0x70, 0x6D, 0x00, 0x00, 0x14, 0x60, 0x00, 0x01, 0x00, 0x14, 0x01, 0x07,
    0x02, 0x84, 0x01, 0x01, 0x02, 0x00, 0x00, 0xAB, 0xCD, 0x12, 0x34, 0x38,
    0x06
])


let fitFileDevDataShortTwoFields = Data([
    0x0E, 0x20, 0x9A, 0x52, 0x8C, 0x00, 0x00, 0x00, 0x2E, 0x46, 0x49, 0x54,
    0x57, 0x8E, 0x40, 0x00, 0x00, 0xCF, 0x00, 0x01, 0x03, 0x01, 0x02, 0x00,
    0x00, 0x40, 0x00, 0x00, 0xCE, 0x00, 0x06, 0x00, 0x01, 0x02, 0x01, 0x01,
    0x02, 0x02, 0x01, 0x02, 0x03, 0x11, 0x07, 0x08, 0x0A, 0x07, 0x0E, 0x02,
    0x84, 0x00, 0x00, 0x00, 0x88, 0x44, 0x6F, 0x75, 0x67, 0x68, 0x6E, 0x75,
    0x74, 0x73, 0x20, 0x45, 0x61, 0x72, 0x6E, 0x65, 0x64, 0x00, 0x64, 0x6F,
    0x75, 0x67, 0x68, 0x6E, 0x75, 0x74, 0x73, 0x00, 0x14, 0x00, 0x40, 0x00,
    0x00, 0xCE, 0x00, 0x07, 0x00, 0x01, 0x02, 0x01, 0x01, 0x02, 0x02, 0x01,
    0x02, 0x03, 0x0B, 0x07, 0x08, 0x04, 0x07, 0x0F, 0x01, 0x02, 0x0E, 0x02,
    0x84, 0x00, 0x00, 0x01, 0x02, 0x48, 0x65, 0x61, 0x72, 0x74, 0x20, 0x52,
    0x61, 0x74, 0x65, 0x00, 0x62, 0x70, 0x6D, 0x00, 0x03, 0x14, 0x00, 0x60,
    0x00, 0x00, 0x14, 0x00, 0x01, 0x03, 0x01, 0x02, 0x02, 0x00, 0x04, 0x00,
    0x01, 0x01, 0x00, 0x00, 0x3C, 0x33, 0x33, 0x23, 0x41, 0x3F, 0x3B, 0xE6
])

let fitFileDevDataIncorrectDeveloperDataIndex = Data([
    0x0E, 0x20, 0x9B, 0x52, 0x4C, 0x00, 0x00, 0x00, 0x2E, 0x46, 0x49, 0x54,
    0x0A, 0x1B, 0x40, 0x00, 0x00, 0xCF, 0x00, 0x01, 0x03, 0x01, 0x02, 0x00,
    0x00, 0x40, 0x00, 0x00, 0xCE, 0x00, 0x07, 0x00, 0x01, 0x02, 0x01, 0x01,
    0x02, 0x02, 0x01, 0x02, 0x03, 0x0B, 0x07, 0x08, 0x04, 0x07, 0x0F, 0x01,
    0x02, 0x0E, 0x02, 0x84, 0x00, 0x01, 0x01, 0x02, 0x48, 0x65, 0x61, 0x72,
    0x74, 0x20, 0x52, 0x61, 0x74, 0x65, 0x00, 0x62, 0x70, 0x6D, 0x00, 0x03,
    0x14, 0x00, 0x60, 0x00, 0x00, 0x14, 0x00, 0x01, 0x03, 0x01, 0x02, 0x01,
    0x01, 0x01, 0x01, 0x00, 0x3C, 0x3F, 0xF2, 0x59
])

let fileIdMesgGarminProductSubfieldWithoutManufacturer = Data([
    0x0E, 0x20, 0x9B, 0x52, 0x0C, 0x00, 0x00, 0x00, 0x2E, 0x46, 0x49, 0x54,
    0x0E, 0x2B, 0x40, 0x00, 0x00, 0x00, 0x00, 0x01, 0x02, 0x02, 0x84, 0x00,
    0xB8, 0x11, 0xF3, 0x21
])

let fileIdMesgGarminProductSubfieldWithGarminManufacturer = Data([
    0x0E, 0x20, 0x9B, 0x52, 0x11, 0x00, 0x00, 0x00, 0x2E, 0x46, 0x49, 0x54,
    0xCE, 0xBE, 0x40, 0x00, 0x00, 0x00, 0x00, 0x02, 0x01, 0x02, 0x84, 0x02,
    0x02, 0x84, 0x00, 0x01, 0x00, 0xB8, 0x11, 0x31, 0x8E
])

let fileIdMesgGarminProductSubfieldWithDevelopmentManufacturer = Data([
    0x0E, 0x20, 0x9B, 0x52, 0x11, 0x00, 0x00, 0x00, 0x2E, 0x46, 0x49, 0x54,
    0xCE, 0xBE, 0x40, 0x00, 0x00, 0x00, 0x00, 0x02, 0x01, 0x02, 0x84, 0x02,
    0x02, 0x84, 0x00, 0xFF, 0x00, 0xB8, 0x11, 0x00, 0x66
])

let fitFileDevDataApplicationId = Data([
    0x0E, 0x20, 0x9A, 0x52, 0x21, 0x01, 0x00, 0x00, 0x2E, 0x46, 0x49, 0x54,
    0x8C, 0xAF, 0x40, 0x00, 0x00, 0x00, 0x00, 0x05, 0x00, 0x01, 0x00, 0x01,
    0x02, 0x84, 0x02, 0x02, 0x84, 0x04, 0x04, 0x86, 0x03, 0x04, 0x8C, 0x00,
    0x04, 0xFF, 0x00, 0x00, 0x00, 0x53, 0x1A, 0x74, 0x41, 0xBF, 0x84, 0x7C,
    0x5D, 0x40, 0x00, 0x00, 0x17, 0x00, 0x07, 0x00, 0x01, 0x02, 0x02, 0x02,
    0x84, 0x04, 0x02, 0x84, 0x1B, 0x0D, 0x07, 0x03, 0x04, 0x8C, 0x05, 0x02,
    0x84, 0xFD, 0x04, 0x86, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0x46, 0x49,
    0x54, 0x20, 0x43, 0x6F, 0x6F, 0x6B, 0x62, 0x6F, 0x6F, 0x6B, 0x00, 0xBF,
    0x84, 0x7C, 0x5D, 0x64, 0x00, 0x53, 0x1A, 0x74, 0x41, 0x40, 0x00, 0x00,
    0x15, 0x00, 0x03, 0xFD, 0x04, 0x86, 0x00, 0x01, 0x00, 0x01, 0x01, 0x00,
    0x00, 0x53, 0x1A, 0x74, 0x41, 0x00, 0x00, 0x40, 0x00, 0x00, 0xCF, 0x00,
    0x03, 0x01, 0x10, 0x0D, 0x03, 0x01, 0x02, 0x04, 0x04, 0x86, 0x00, 0x03,
    0x02, 0x01, 0x00, 0x05, 0x04, 0x07, 0x06, 0x08, 0x09, 0x0A, 0x0B, 0x0C,
    0x0D, 0x0E, 0x0F, 0x00, 0x6E, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00, 0xCE,
    0x00, 0x06, 0x00, 0x01, 0x02, 0x01, 0x01, 0x02, 0x02, 0x01, 0x02, 0x03,
    0x11, 0x07, 0x08, 0x0A, 0x07, 0x0E, 0x02, 0x84, 0x00, 0x00, 0x00, 0x88,
    0x44, 0x6F, 0x75, 0x67, 0x68, 0x6E, 0x75, 0x74, 0x73, 0x20, 0x45, 0x61,
    0x72, 0x6E, 0x65, 0x64, 0x00, 0x64, 0x6F, 0x75, 0x67, 0x68, 0x6E, 0x75,
    0x74, 0x73, 0x00, 0x12, 0x00, 0x40, 0x00, 0x00, 0xCE, 0x00, 0x07, 0x00,
    0x01, 0x02, 0x01, 0x01, 0x02, 0x02, 0x01, 0x02, 0x03, 0x0B, 0x07, 0x08,
    0x04, 0x07, 0x0F, 0x01, 0x02, 0x0E, 0x02, 0x84, 0x00, 0x00, 0x01, 0x02,
    0x48, 0x65, 0x61, 0x72, 0x74, 0x20, 0x52, 0x61, 0x74, 0x65, 0x00, 0x62,
    0x70, 0x6D, 0x00, 0x03, 0x14, 0x00, 0x40, 0x00, 0x00, 0x22, 0x00, 0x04,
    0xFD, 0x04, 0x86, 0x01, 0x02, 0x84, 0x05, 0x04, 0x86, 0x00, 0x04, 0x86,
    0x00, 0x53, 0x1A, 0x74, 0x41, 0x01, 0x00, 0xE3, 0xB7, 0x73, 0x41, 0x00,
    0x00, 0x00, 0x00, 0x2D, 0x43
])

let fitFileMonitoringData = Data([
    0x0E, 0x10, 0x28, 0x23, 0x37, 0x00, 0x00, 0x00, 0x2E, 0x46, 0x49, 0x54,
    0x2C, 0xC6, 0x41, 0x00, 0x01, 0x00, 0x37, 0x03, 0xFD, 0x04, 0x86, 0x18,
    0x01, 0x0D, 0x03, 0x04, 0x86, 0x01, 0x3F, 0x2A, 0xE2, 0xFF, 0x61, 0x00,
    0x00, 0x00, 0x14, 0x01, 0x3F, 0x2A, 0xE2, 0xFF, 0x06, 0x00, 0x00, 0x00,
    0x3C, 0x01, 0x3F, 0x2A, 0xE2, 0xFF, 0x1E, 0x00, 0x00, 0x00, 0x1E, 0x01,
    0x3F, 0x2A, 0xE2, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x1E, 0xED, 0xF9
])