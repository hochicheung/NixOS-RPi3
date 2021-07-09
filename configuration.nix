{ config, pkgs, lib, ... }:
{
	# NixOS wants to enable GRUB by default
	boot.loader.grub.enable = false;

	# Kernel options
	boot.kernelPackages = pkgs.linuxPackages_5_4;

	boot.loader.raspberryPi.enable = true;
	boot.loader.raspberryPi.version = 3;
	boot.loader.raspberryPi.uboot.enable = true;

	# Filesystem configuration
	fileSystems = {
	  "/" = {
		  device = "/dev/disk/by-label/NIXOS_SD";
			fsType = "ext4";
		};
	};
	
	# Swap
	swapDevices = [ { device = "/swapfile"; size = 1024;}];
	
	# Nix garbage collector
	nix.gc.automatic = true;

	# Don't use swap unless ram is full
	boot.kernel.sysctl = {
		"vm.swappiness" = 0;
	};
	services.fstrim.enable = true;

	# Clean /tmp on boot
	boot.cleanTmpDir = true;

	# User Management
	users.users.samcheung = {
		isNormalUser = true;
		home = "/home/samcheung";
		extraGroups = ["wheel" "networkmanager"];
	};

	# Time & Date
	time.timeZone = "Europe/Stockholm";
	services.localtime.enable = true;

	# Networking
	networking = {
	  hostName = "raspi-nix";
	  networkmanager.enable = true;
		
		firewall.enable = true;
		firewall.allowedTCPPorts = [80 443 461];
	};

	# Auto-upgrade
	system.autoUpgrade.enable = true;
	system.autoUpgrade.allowReboot = true;

	# Packages
	environment.systemPackages = with pkgs; [
		git
		vim
		libraspberrypi
	];

	# SSH
	services.openssh.enable = true;
	services.openssh.permitRootLogin = "yes";
	services.openssh.ports = [461];
	
}