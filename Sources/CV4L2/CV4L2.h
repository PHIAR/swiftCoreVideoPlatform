#pragma once

#ifdef __linux__

#include <stdint.h>
#include <linux/videodev2.h>
#include <sys/ioctl.h>

typedef enum video_ioctl_request_e {
    video_ioctl_request_crop_cap = VIDIOC_CROPCAP,
    video_ioctl_request_dequeue_buffer = VIDIOC_DQBUF,
    video_ioctl_request_get_format = VIDIOC_G_FMT,
    video_ioctl_request_queue_buffer = VIDIOC_QBUF,
    video_ioctl_request_query_buffer = VIDIOC_QUERYBUF,
    video_ioctl_request_query_cap = VIDIOC_QUERYCAP,
    video_ioctl_request_request_buffers = VIDIOC_REQBUFS,
    video_ioctl_request_set_crop = VIDIOC_S_CROP,
    video_ioctl_request_set_format = VIDIOC_S_FMT,
    video_ioctl_request_stream_off = VIDIOC_STREAMOFF,
    video_ioctl_request_stream_on = VIDIOC_STREAMON,
} video_ioctl_request_e;

// Convenience helpers

static inline fd_set
get_fd_set(int32_t fd)
{
    fd_set fds;

    FD_ZERO(&fds);
    FD_SET(fd, &fds);
    return fds;
}

static inline int32_t
ioctl_1_arg(int32_t fd,
            video_ioctl_request_e request,
            void *argument)
{
    return ioctl(fd, request, argument);
}

#endif
