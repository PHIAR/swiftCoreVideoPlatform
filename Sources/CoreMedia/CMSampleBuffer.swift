import CoreVideo
import Foundation

public final class CMSampleBuffer {
    internal var imageBuffer: CVImageBuffer?

    public init(imageBuffer: CVImageBuffer) {
        self.imageBuffer = imageBuffer
    }
}

// MARK - Public API

public func CMSampleBufferGetImageBuffer(_ sbuf: CMSampleBuffer) -> CVImageBuffer? {
    return sbuf.imageBuffer
}
