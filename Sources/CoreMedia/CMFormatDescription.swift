import Foundation

public typealias CMVideoFormatDescription = CMFormatDescription

public struct CMVideoDimensions {
    public let width: Int32
    public let height: Int32

    public init(width: Int32 = 0,
                height: Int32 = 0) {
        self.width = width
        self.height = height
    }
}

public class CMFormatDescription {
}

// MARK - Public API

public func CMVideoFormatDescriptionGetDimensions(_ videoDesc: CMVideoFormatDescription) -> CMVideoDimensions {
    let dimensions = CMVideoDimensions()

    return dimensions
}
