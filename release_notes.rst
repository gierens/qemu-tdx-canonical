========================================
Intel Trust Dodmain Extensions(TDX) QEMU
========================================

Branch v8.2.2-tdx -- based on https://github.com/intel/qemu-tdx.git tag tdx-qemu-upstream-v5
Forward ported to v9.0.2.

Match KVM TDX patches in https://github.com/intel/kernel-downstream/tree/v6.8-tdx.
Implement the following features.

- TDX VM TYPE is exposed to Qemu.
- Qemu can create/destroy guest of TDX vm type.
- Qemu can create/destroy vcpu of TDX vm type.
- Qemu can populate initial guest memory image.
- Qemu can finalize guest TD.
- Qemu can start to run vcpu.
- Qemu supports guest memfd.
- Qemu enables huge page for guest memfd.

-----------------------
Usage
-----------------------
- Remove “private=on” from “-object memory-backend-ram,id=ram1,size=4G,private=on“.
  And “memory-backend-ram” is the default set, so we can remove all this “-object” line
- Change “memory-encryption=tdx” to “confidential-guest-support=tdx” in “-machine q35,hpet=off,kernel_irqchip=split,memory-encryption=tdx,memory-backend=ram1”. “hpet=off” and “memory-backend” is the default set, can be removed.
- Example:
        qemu-system-x86_64 -accel kvm \
        -name tdxvm,process=tdxvm,debug-threads=on \
        -object tdx-guest,id=tdx \
        -m 4G -smp 4 -cpu host \
        -machine q35,kernel_irqchip=split,confidential-guest-support=tdx \
        -nodefaults \
        -device virtio-net-pci,netdev=nic0 -netdev user,id=nic0,hostfwd=tcp::10022-:22 \
        -drive file=$img,if=none,id=virtio-disk0 \
        -device virtio-blk-pci,drive=virtio-disk0 \
        -bios /usr/share/qemu/OVMF.fd \
        -nographic -vga none \
        -serial stdio
