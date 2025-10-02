_: {
  fileSystems."/" = {
    device = "/dev/disk/by-label/disk-sda-ESP";
    #fsType = "exfat";
    options = [
      # If you don't have this options attribute, it'll default to "defaults"
      "exec" # Permit execution of binaries and other executable files
    ];
  };
}
