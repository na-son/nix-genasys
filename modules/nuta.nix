{
  config,
  pkgs,
  lib,
  ...
}:
# nutanix-specific configuration, should be compatible with *most* qemu / kvm hypervisors
{
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 42;
      };
      efi.canTouchEfiVariables = true;
    };

    # hypervisor specific
    initrd.availableKernelModules = [
      "ata_piix"
      "virtio_pci"
      "virtio_scsi"
      "uhci_hcd"
      "sd_mod"
      "sr_mod"
    ];

    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [
      "tun"
    ];
  };
}
