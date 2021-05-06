{ config, pkgs, lib, ... }:

{
	boot.loader.grub.enable = false;

	# Enables the generation of /boot/extlinux/extlinux.conf
	boot.loader.generic-extlinux-compatible.enable = true;

	boot.kernelPackages = pkgs.linuxPackages_latest;

	# Needed for the virtual console to work on the RPi3.
	boot.kernelParams = ["cma=32M"];

	# File systems configuration for using the installer's partition layout
	fileSystem = {
		"/" = {
				device = "/dev/disk/by-label/NIXOS_SD";
				fsType = "ext4";
		};
	};

	swapDevices = [ { device = "/swapfile"; size = 1024; } ];

	networking.hostName = "RPi3";

	# Allow Unfree
	nixpkgs.config.allowUnfree = true;

	environment.systemPackages = with pkgs; [
		git
		vim
	];
}