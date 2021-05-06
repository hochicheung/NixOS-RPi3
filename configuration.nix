{ config, pkgs, ... }:

{
  imports =
    [ 
			./rpi3.nix
    ];

	# Don't use swap unless ram is full
	boot.kernel.sysctl = {
  	"vm.swappiness" = 0;
	};
	services.fstrim.enable = true;

	# Clean /tmp on boot
	boot.cleanTmpDir = true;

	# Time & Date
	time.timeZone = "Europe/Stockholm";
	services.localtime.enable = true;
  
  # Networking
  networking.networkmanager.enable = true;

  # User Management
  users.users.samcheung = {
    isNormalUser = true;
    home = "/home/samcheung";
    extraGroups = ["wheel" "networkmanager" "video"];
  };

	# Nix garbage collector
	nix.gc.automatic = true;

	system.autoUpgrade.enable = true;
	system.autoUpgrade.allowReboot = true;
}