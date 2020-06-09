import Foundation

// MARK - Dispatch time conversions

public let NSEC_PER_SEC = UInt64(1000000000)
public let NSEC_PER_MSEC = NSEC_PER_SEC / USEC_PER_SEC * 1000
public let NSEC_PER_USEC = NSEC_PER_SEC / USEC_PER_SEC
public let USEC_PER_SEC = UInt64(1000000)

// MARK - Pixel formats

public typealias OSType = UInt32
public let kCVPixelFormatType_32BGRA = UInt32(0x42475241)

// MARK - Pixel buffer creation keys

public let kCVPixelBufferMetalCompatibilityKey = "CVPixelBufferMetalCompatibility"
public let kCVPixelBufferPixelFormatTypeKey = "CVPixelBufferPixelFormatType"
