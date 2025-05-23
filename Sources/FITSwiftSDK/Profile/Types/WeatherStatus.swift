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

public enum WeatherStatus: UInt8, CaseIterable {
    case clear = 0
    case partlyCloudy = 1
    case mostlyCloudy = 2
    case rain = 3
    case snow = 4
    case windy = 5
    case thunderstorms = 6
    case wintryMix = 7
    case fog = 8
    case hazy = 11
    case hail = 12
    case scatteredShowers = 13
    case scatteredThunderstorms = 14
    case unknownPrecipitation = 15
    case lightRain = 16
    case heavyRain = 17
    case lightSnow = 18
    case heavySnow = 19
    case lightRainSnow = 20
    case heavyRainSnow = 21
    case cloudy = 22
    case invalid = 0xFF
}
