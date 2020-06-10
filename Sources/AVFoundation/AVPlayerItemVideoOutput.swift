import Foundation

public final class AVPlayerItemVideoOutput: AVPlayerItemOutput {
    public init(outputSettings: [String: Any]?) {
    }

    public init(pixelBufferAttributes: [String: Any]?) {
    }

    public func copyPixelBuffer(forItemTime itemTime: CMTime,
                                itemTimeForDisplay outItemTimeForDisplay: UnsafeMutablePointer<CMTime>?) -> CVPixelBuffer? {
        preconditionFailure()
    }

    public func hasNewPixelBuffer(forItemTime itemTime: CMTime) -> Bool {
        preconditionFailure()
    }
}
