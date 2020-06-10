import Foundation

public final class AVAsset {
    public var tracks: [AVAssetTrack] {
        preconditionFailure()
    }

    private init() {
    }

    public convenience init(url URL: URL) {
        self.init()
    }

    public func tracks(withMediaType mediaType: AVMediaType) -> [AVAssetTrack] {
        preconditionFailure()
    }
}
