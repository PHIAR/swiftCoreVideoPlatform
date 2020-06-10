import CoreMedia
import CoreVideo
import Foundation

public final class AVAssetWriterInputPixelBufferAdaptor {
    public init(assetWriterInput input: AVAssetWriterInput,
                sourcePixelBufferAttributes: [String : Any]? = nil) {
    }

    @discardableResult
    public func append(_ pixelBuffer: CVPixelBuffer,
                       withPresentationTime presentationTime: CMTime) -> Bool {
        preconditionFailure()
    }
}
