import Foundation

public final class CMTime {
    internal let value: Int64
    internal let timescale: Int32

    internal init(value: Int64,
                  timescale: Int32) {
        self.value = value
        self.timescale = timescale
    }
}

public func CMTimeMake(value: Int64,
                       timescale: Int32) -> CMTime {
    return CMTime(value: value,
                  timescale: timescale)
}
