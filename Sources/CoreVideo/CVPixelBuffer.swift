import Foundation

public typealias OSType = UInt32

public final class CVPixelBuffer {
    internal let width: Int
    internal let height: Int

    internal init(width: Int = 0,
                  height: Int = 0) {
        self.width = width
        self.height = height
    }
}

public let kCVPixelFormatType_32BGRA = UInt32(0x42475241)
public let kCVPixelBufferMetalCompatibilityKey = "CVPixelBufferMetalCompatibility"

public func CVPixelBufferGetHeight(_ pixelBuffer: CVPixelBuffer) -> Int {
    return pixelBuffer.height
}

public func CVPixelBufferGetWidth(_ pixelBuffer: CVPixelBuffer) -> Int {
    return pixelBuffer.width
}


