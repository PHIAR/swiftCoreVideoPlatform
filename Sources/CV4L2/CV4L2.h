#pragma once

#include <stdint.h>
#include <linux/videodev2.h>
#include <sys/ioctl.h>

typedef enum video_ioctl_request_e {
    video_ioctl_request_crop_cap = VIDIOC_CROPCAP,
    video_ioctl_request_get_format = VIDIOC_G_FMT,
    video_ioctl_request_query_cap = VIDIOC_QUERYCAP,
    video_ioctl_request_set_crop_cap = VIDIOC_S_CROP,
    video_ioctl_request_set_format = VIDIOC_S_FMT,
} video_ioctl_request_e;

// Convenience helpers

static inline int32_t
ioctl_1_arg(int32_t fd,
            int32_t request,
            void *argument)
{
    return ioctl(fd, request, argument);
}
