import CV4L2

internal final class CameraInstance {
    private let capability: v4l2_capability
    private let cropCap: v4l2_cropcap
    private let crop: v4l2_crop
    private let format: v4l2_format

    internal init(capability: v4l2_capability,
                  cropCap: v4l2_cropcap,
                  crop: v4l2_crop,
                  format: v4l2_format) {
        self.capability = capability
        self.cropCap = cropCap
        self.crop = crop
        self.format = format
    }
}