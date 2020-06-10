import Foundation

public typealias CVImageBuffer = CVPixelBuffer

public final class CVPixelBuffer: CVBuffer {
    internal let width: Int
    internal let height: Int

    internal init(width: Int = 0,
                  height: Int = 0) {
        self.width = width
        self.height = height
    }
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
