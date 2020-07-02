import Foundation

public typealias CVImageBuffer = CVPixelBuffer

public final class CVPixelBuffer: CVBuffer {
    internal let width: Int
    internal let height: Int
    internal let baseAddress: UnsafeMutableRawPointer?
    internal let dataSize: Int

    internal init(width: Int = 0,
                  height: Int = 0,
                  baseAddress: UnsafeMutableRawPointer? = nil,
                  dataSize: Int = 0) {
        self.width = width
        self.height = height
        self.baseAddress = baseAddress
        self.dataSize = dataSize
    }

    internal func lock() {
    }

    internal func unlock() {
    }
}

public struct CVPixelBufferLockFlags: OptionSet {
    public static let readOnly = CVPixelBufferLockFlags(rawValue: 0x1)

    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

public func CVPixelBufferGetBaseAddress(_ pixelBuffer: CVPixelBuffer) -> UnsafeMutableRawPointer? {
    return pixelBuffer.baseAddress
}

public func CVPixelBufferGetDataSize(_ pixelBuffer: CVPixelBuffer) -> Int {
    return pixelBuffer.dataSize
}

public func CVPixelBufferGetHeight(_ pixelBuffer: CVPixelBuffer) -> Int {
    return pixelBuffer.height
}

public func CVPixelBufferGetHeightOfPlane(_ pixelBuffer: CVPixelBuffer,
                                          _ planeIndex: Int) -> Int {
    return pixelBuffer.height
}

public func CVPixelBufferGetWidth(_ pixelBuffer: CVPixelBuffer) -> Int {
    return pixelBuffer.width
}

public func CVPixelBufferGetWidthOfPlane(_ pixelBuffer: CVPixelBuffer,
                                         _ planeIndex: Int) -> Int {
    return pixelBuffer.width
}

public func CVPixelBufferLockBaseAddress(_ pixelBuffer: CVPixelBuffer,
                                         _ unlockFlags: CVPixelBufferLockFlags) -> CVReturn {
    pixelBuffer.lock()
    return 0
}


public func CVPixelBufferUnlockBaseAddress(_ pixelBuffer: CVPixelBuffer,
                                           _ unlockFlags: CVPixelBufferLockFlags) -> CVReturn {
    pixelBuffer.unlock()
    return 0
}
