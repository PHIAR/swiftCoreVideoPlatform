import Foundation

// MARK - Pixel formats

public typealias OSType = UInt32
public let kCVPixelFormatType_32BGRA = UInt32(0x42475241)

// MARK - Pixel buffer creation keys

public let kCVPixelBufferMetalCompatibilityKey = "CVPixelBufferMetalCompatibility"
public let kCVPixelBufferPixelFormatTypeKey = "CVPixelBufferPixelFormatType"
