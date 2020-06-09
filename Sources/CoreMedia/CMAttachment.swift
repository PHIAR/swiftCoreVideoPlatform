import Foundation

// MARK - CMAttachment types

public typealias CMAttachmentBearer = Any
public typealias CMAttachmentMode = UInt32

// MARK - Constants

public let kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix = "CMSampleBufferAttachmentKey.CameraIntrinsicMatrix"

// MARK - Public API

public func CMGetAttachment(_ target: CMAttachmentBearer,
                            key: String,
                            attachmentModeOut: UnsafeMutablePointer <CMAttachmentMode>?) -> Any? {
    preconditionFailure()
}
