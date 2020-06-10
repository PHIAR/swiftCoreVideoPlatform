import Foundation

public final class AVAssetWriter {
    public init(outputURL: URL,
                fileType outputFileType: AVFileType) throws {
    }

    public func add(_ input: AVAssetWriterInput) {
        preconditionFailure()
    }

    public func endSession(atSourceTime endTime: CMTime) {
        preconditionFailure()
    }

    public func finishWriting(completionHandler handler: @escaping () -> Void) {
        preconditionFailure()
    }

    public func startSession(atSourceTime startTime: CMTime) {
        preconditionFailure()
    }

    @discardableResult
    public func startWriting() -> Bool {
        preconditionFailure()
    }
}
