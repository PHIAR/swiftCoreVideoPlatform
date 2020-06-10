import Foundation

public final class AVAssetWriterInput {
    private init() {
    }

    public convenience init(mediaType: AVMediaType,
                            outputSettings: [String : Any]?) {
        self.init()
    }

    public var isReadyForMoreMediaData: Bool {
        preconditionFailure()
    }
}
