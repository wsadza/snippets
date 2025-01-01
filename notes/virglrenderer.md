# Setting Up Venus Driver with Virglrenderer

## Prerequisites

Install the required dependencies:

```sh
sudo apt-get install pkg-config libepoxy-dev libdrm-dev libvulkan-dev libgbm-dev libglvnd-dev libva-dev
```

Clone the `virglrenderer` repository:

```sh
git clone https://gitlab.freedesktop.org/virgl/virglrenderer.git
```

## Running Tests

### Test OpenGL and Vulkan Applications

#### Start the Virgl Test Server
```sh
VK_DRIVER_FILES=/etc/vulkan/icd.d/nvidia_icd.json ./virgl_test_server --venus --use-glx
```
#### Run Vulkan Cube
```sh
VK_DRIVER_FILES=/usr/share/vulkan/icd.d/virtio_icd.x86_64.json VN_DEBUG=all LIBGL_ALWAYS_SOFTWARE=1 GALLIUM_DRIVER=virpipe __GLX_VENDOR_LIBRARY_NAME=mesa vkcube
```

#### Run GLX Gears
```sh
VK_DRIVER_FILES=/usr/share/vulkan/icd.d/virtio_icd.x86_64.json VN_DEBUG=vtest LIBGL_ALWAYS_SOFTWARE=1 GALLIUM_DRIVER=virpipe __GLX_VENDOR_LIBRARY_NAME=mesa glxgears
```

## Status as of 01.01.25

- OpenGL: Works fine.  
- Vulkan: Limited success; only `vulkaninfo` runs successfully.

## Docker Example

A Docker-based example is available here:  
https://gitlab.freedesktop.org/igor.torrente/virglrenderer/-/tree/podman-integration?ref_type=heads
