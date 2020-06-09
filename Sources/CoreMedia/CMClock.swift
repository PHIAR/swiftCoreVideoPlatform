import Foundation

public final class CMClock {
}

// MARK - Public API

public func CMClockGetHostTimeClock() -> CMClock {
    preconditionFailure()
}

public func CMClockGetTime(_ clock: CMClock) -> CMTime {
    preconditionFailure()
}
