#!/bin/bash
FILE_SYSTEM=./x86_rootfs$2.img 
KERNEL=./shm_version/popcorn_x86/arch/x86/boot/bzImage
SOCKET1=/tmp/ivshmem_socket
SOCKET2=/tmp/cross_ipi_chr

if [ "$1" = "1" ]; then
    sudo ../build/qemu-system-x86_64 \
        -machine pc -m 8G -nographic \
		-chardev pty,id=char0 -serial chardev:char0 \
		-monitor stdio \
        -chardev socket,path=$SOCKET1,id=vintchar \
        -chardev socket,path=$SOCKET2,id=x86_chr \
        -drive id=root,if=none,readonly=off,media=disk,file=$FILE_SYSTEM \
        -device virtio-blk-pci,drive=root \
        -drive file=disk1.img,readonly=on,if=none,id=D1 \
        -device virtio-blk-pci,drive=D1,serial=1234 \
        -kernel $KERNEL \
        -append "root=/dev/vda rw console=ttyS0"
else
    sudo ../build/qemu-system-x86_64$2 \
        -machine pc -m 8G -nographic \
        -chardev socket,path=$SOCKET1,id=vintchar \
        -chardev socket,path=$SOCKET2,id=x86_chr \
        -drive id=root,if=none,readonly=off,me1dia=disk,file=$FILE_SYSTEM \
        -device virtio-blk-pci,drive=root \
        -drive file=disk1.img,readonly=on,if=none,id=D1 \
        -device virtio-blk-pci,drive=D1,serial=1234 \
        -kernel $KERNEL \
        -append "root=/dev/vda rw console=ttyS0" \
        -plugin ../build/contrib/plugins/libcache-sim.so \
        -d plugin \
        -icount shift=1
fi
