{ config, pkgs, lib, ... }:
{
	# NixOS wants to enable GRUB by default
	boot.loader.grub.enable = false;

	# Enables the generation of /boot/extlinux/extlinux.conf
	boot.loader.generic-extlinux-compatible.enable = true;

	#	 !!! If your board is a Raspberry Pi 3, select not latest (5.8 at the time)
	#	 !!! as it is currently broken (see https://github.com/NixOS/nixpkgs/issues/97064)
	boot.kernelPackages = pkgs.linuxPackages;

	# !!! Needed for the virtual console to work on the RPi 3, as the default of 16M doesn't seem to be enough.
	boot.kernelParams = ["cma=32M"];

	# File systems configuration for using the installer's partition layout
	fileSystems = {
		"/" = {
			device = "/dev/disk/by-label/NIXOS_SD";
			fsType = "ext4";
		};
	};

	swapDevices = [ { device = "/swapfile"; size = 1024; } ];
}