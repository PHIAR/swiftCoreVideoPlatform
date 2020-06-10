import Foundation

public final class CMClock {
}

// MARK - Public API

public func clock_gettime_nsec_np(_ clock_id: clockid_t) -> UInt64 {
    preconditionFailure()
}

public func CMClockGetHostTimeClock() -> CMClock {
    preconditionFailure()
}

public func CMClockGetTime(_ clock: CMClock) -> CMTime {
    preconditionFailure()
}
