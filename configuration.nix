{ config, pkgs, lib, ... }:
{
	# NixOS wants to enable GRUB by default
	boot.loader.grub.enable = false;

	# Hostname
	networking.hostName = "raspi3";

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
	services.openssh.permitRootLogin = "yes";
	services.openssh.ports = [461];
}