import Foundation

public final class AVPlayerItem {
    public enum Status: String {
        case unknown
        case readyToPlay
        case failed
    }

    private let _asset: AVAsset

    public var asset: AVAsset {
        return self._asset
    }

    public var duration: CMTime {
        get {
            preconditionFailure()
        }

        set {
            preconditionFailure()
        }
    }

    public var status: Status {
        get {
            preconditionFailure()
        }
    }


    public init(asset: AVAsset,
                automaticallyLoadedAssetKeys: [String]?) {
        self._asset = asset
    }

    public func add(_ output: AVPlayerItemOutput) {
    }

    public func observe <U> (_ keyPath: KeyPath <AVPlayerItem, U>,
                        context: UnsafeMutableRawPointer? = nil,
                        handler:  @escaping (AVPlayerItem,
                                             UnsafeMutableRawPointer?) -> Void) -> NSKeyValueObservation {
        preconditionFailure()
    }
}
