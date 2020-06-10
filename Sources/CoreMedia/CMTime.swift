import Foundation

public typealias CMTimeScale = Int32
public typealias CMTimeValue = Int64

public enum CMTimeRoundingMethod {
    public static var `default`: CMTimeRoundingMethod = .roundHalfAwayFromZero

    case quickTime
    case roundAwayFromZero
    case roundHalfAwayFromZero
    case roundTowardNegativeInfinity
    case roundTowardPositiveInfinity
    case roundTowardZero
}

public struct CMTime {
    public static let zero: CMTime = CMTimeMake(value: 0,
                                                timescale: 0)

    public var value: CMTimeValue
    public var timescale: CMTimeScale

    public var seconds: Double {
        preconditionFailure()
    }

    public static func - (left: CMTime,
                          right: CMTime) -> CMTime {
        preconditionFailure()
    }

    public static func < (left: CMTime,
                          right: CMTime) -> Bool {
        preconditionFailure()
    }

    public static func == (left: CMTime,
                           right: CMTime) -> Bool {
        preconditionFailure()
    }

    public static func <= (left: CMTime,
                           right: CMTime) -> Bool {
        preconditionFailure()
    }

    public static func > (left: CMTime,
                          right: CMTime) -> Bool {
        preconditionFailure()
    }

    public static func >= (left: CMTime,
                           right: CMTime) -> Bool {
        preconditionFailure()
    }

    public init(seconds: Double,
                preferredTimescale: CMTimeScale) {
        preconditionFailure()
    }

    public init(value: CMTimeValue,
                timescale: CMTimeScale) {
        self.value = value
        self.timescale = timescale
    }

    public func convertScale(_ newTimescale: Int32,
                             method: CMTimeRoundingMethod) -> CMTime {
        preconditionFailure()
    }
}

// MARK - Public API

public func CMTimeMake(value: CMTimeValue,
                       timescale: CMTimeScale) -> CMTime {
    return CMTime(value: value,
                  timescale: timescale)
}
