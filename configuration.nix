{ config, pkgs, lib, ... }:
{
	# NixOS wants to enable GRUB by default
	boot.loader.grub.enable = false;

	# Hostname
	networking.hostName = "raspi3";

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

	# Add Swap
	swapDevices = [ { device = "/swapfile"; size = 1024; } ];

	# Load wifi device
	hardware.enableRedistributableFirmware = true;

	# User Management
	users.users.samcheung = {
		isNormalUser = true;
		home = "/home/samcheung";
		extraGroups = ["wheel" "networkmanager"];
	};

	# Nix garbage collector
	nix.gc.automatic = true;

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

	# Auto-upgrade
	system.autoUpgrade.enable = true;
	system.autoUpgrade.allowReboot = true;

	# Allow Unfree
	nixpkgs.config.allowUnfree = true;

	# Packages
	environment.systemPackages = with pkgs; [
		git
		vim
	];

	# SSH
	services.openssh.enable = true;
	services.openssh.permitRootLogin = true;
	services.openssh.ports = [461];
}