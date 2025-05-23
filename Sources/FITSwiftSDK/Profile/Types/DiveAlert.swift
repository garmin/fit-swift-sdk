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

public enum DiveAlert: UInt8, CaseIterable {
    case ndlReached = 0
    case gasSwitchPrompted = 1
    case nearSurface = 2
    case approachingNdl = 3
    case po2Warn = 4
    case po2CritHigh = 5
    case po2CritLow = 6
    case timeAlert = 7
    case depthAlert = 8
    case decoCeilingBroken = 9
    case decoComplete = 10
    case safetyStopBroken = 11
    case safetyStopComplete = 12
    case cnsWarning = 13
    case cnsCritical = 14
    case otuWarning = 15
    case otuCritical = 16
    case ascentCritical = 17
    case alertDismissedByKey = 18
    case alertDismissedByTimeout = 19
    case batteryLow = 20
    case batteryCritical = 21
    case safetyStopStarted = 22
    case approachingFirstDecoStop = 23
    case setpointSwitchAutoLow = 24
    case setpointSwitchAutoHigh = 25
    case setpointSwitchManualLow = 26
    case setpointSwitchManualHigh = 27
    case autoSetpointSwitchIgnored = 28
    case switchedToOpenCircuit = 29
    case switchedToClosedCircuit = 30
    case tankBatteryLow = 32
    case po2CcrDilLow = 33
    case decoStopCleared = 34
    case apneaNeutralBuoyancy = 35
    case apneaTargetDepth = 36
    case apneaSurface = 37
    case apneaHighSpeed = 38
    case apneaLowSpeed = 39
    case invalid = 0xFF
}
