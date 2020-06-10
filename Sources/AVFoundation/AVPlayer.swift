import Foundation

public final class AVPlayer {
    public var rate: Float {
        get {
            preconditionFailure()
        }

        set {
            preconditionFailure()
        }
    }

    public init(playerItem item: AVPlayerItem?) {
    }

    @discardableResult
    public func addPeriodicTimeObserver(forInterval interval: CMTime,
                                        queue: DispatchQueue?,
                                        using block: @escaping (CMTime) -> Void) -> Any {
        preconditionFailure()
    }

    public func pause() {
    }

    public func play() {
    }

    public func preroll(atRate rate: Float,
                        completionHandler: ((Bool) -> Void)? = nil) {
    }

    public func replaceCurrentItem(with item: AVPlayerItem?) {
    }

    public func seek(to time: CMTime) {
    }

    public func seek(to time: CMTime,
                     toleranceBefore: CMTime,
                     toleranceAfter: CMTime) {
    }
}
