{ config, pkgs, lib, ... }:
{
	boot.loader.grub.enable = false;

	boot.kernelPackages = pkgs.linuxPackages_latest;

	boot.kernelParams = ["cma=256M"];
	boot.loader.raspberryPi.enable = true;
	boot.loader.raspberryPi.version = 3;
	boot.loader.raspberryPi.uboot.enable = true;
	boot.loader.raspberryPi.firmwareConfig = ''
	  gpu_mem=256
	'';
	environment.systemPackages = with pkgs; [
	  raspberrypi-tools
	];

	fileSystems = {
		"/boot" = {
			device = "/dev/disk/by-label/NIXOS_BOOT";
			fsType = "vfat";
		};
		"/" = {
			device = "/dev/disk/by-label/NIXOS_SD";
			fsType = "ext4";
		};
	};

	# Preserve space by disabling documantion and history
	services.nixosManual.enable = false;
	nix.gc.automatic = true;
	nix.gc.options = "--delete-older-than 30d";
	boot.cleanTmpDir = true;

	# Configure basic SSH
	services.openssh.enable = true;
	services.openssh.permitRootLogin = "yes";

	swapDevices = [ { device = "/swapfile"; size = 1024; } ];
}