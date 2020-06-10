import Foundation

// MARK - Return values

public typealias CVReturn = Int

public let kCVReturnSuccess = 0

// MARK - Pixel formats

public typealias OSType = UInt32

public let kCVPixelFormatType_32BGRA = UInt32(0x42475241)
public let kCVPixelFormatType_420YpCbCr8BiPlanarFullRange = UInt32(0x34323066)

// MARK - Pixel buffer creation keys

public let kCVPixelBufferMetalCompatibilityKey = "CVPixelBufferMetalCompatibility"
public let kCVPixelBufferPixelFormatTypeKey = "CVPixelBufferPixelFormatType"

// MARK - Texture cache creation keys

public typealias CVOptionFlags = UInt64

public let kCVMetalTextureUsage = "CVMetalTextureUsage"
