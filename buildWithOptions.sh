#!/bin/sh

#      Copyright (C) 2005-2008 Team XBMC
#      http://www.xbmc.org
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with XBMC; see the file COPYING.  If not, write to
#  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
#  http://www.gnu.org/copyleft/gpl.html

# Using apt-cacher(-ng) to speed up apt-get downloads

SDK_BUILDHOOKS=""

# getopt-parse.bash

TEMP=$(getopt -o anp:ulkgih:xPNiemX --long amd-only,nvidia-only,proxy:,usb-image,live-only,keep-workarea,grub2,intel-only,hook:,x-swat,proposed,newestlivebuild,interactive,ext2fs,minimal,x86_64 -- "$@")
eval set -- "$TEMP"

while true
do
	case $1 in
	-n|--nvidia-only)
		echo "Enable option: NVIDIA support only"
		export SDK_BUILDHOOKS="$SDK_BUILDHOOKS ./buildHook-nvidiaOnly.sh"
		shift
		;;
	-a|--amd-only)
		echo "Enable option: AMD support only"
		export SDK_BUILDHOOKS="$SDK_BUILDHOOKS ./buildHook-amdOnly.sh"
		shift
		;;
	-u|--usb-image)
		echo "Enable option: Generate USBHDD disk image"
		export SDK_BUILDHOOKS="$SDK_BUILDHOOKS ./buildHook-usbhddImage.sh"
		shift
		;;
	-l|--live-only)
		echo "Enable option: Do not include Debian Installer"
		export SDK_BUILDHOOKS="$SDK_BUILDHOOKS ./buildHook-liveOnly.sh"
		shift
		;;
	-k|--keep-workarea)
		echo "Enable option: Do not delete temporary workarea"
		export KEEP_WORKAREA=1
		shift
		;;
	-g|--grub2)
		echo "Enable option: Use grub2"
		export SDK_BUILDHOOKS="$SDK_BUILDHOOKS ./buildHook-grub2.sh"
		shift
		;;
	-i|--intel-only)
		echo "Enable option: Intel support only"
		export SDK_BUILDHOOKS="$SDK_BUILDHOOKS ./buildHook-intelOnly.sh"
		shift
		;;
	-h|--hook)
		case "$2" in
			"") echo "No hook name provided, exiting"; exit ;;
			*)  HOOKNAME=$2;;
		esac
		echo "Enable option: Custom hook $HOOKNAME"
		export SDK_BUILDHOOKS="$SDK_BUILDHOOKS $HOOKNAME"
		shift 2
		;;
	-N|--newestlivebuild)
		echo "Enable option: use latest debian live_build files"
		export SDK_USELATESTLIVEBUILD=1
		shift
		;;
	-I|--interactive)
		echo "Enable option: interactive mode (opens a shell in chroot after package configuring)"
		export SDK_CHROOTSHELL=1
		shift
		;;
        -e|--ext2fs)
                echo "Enable option: ext2 root filesystem (does not compress root filesystem)"
                export SDK_EXT2ROOTFS=1
                shift
                ;;
	-m|--minimal)
		echo "Enable option: minimal build (required packages only)"
		export SDK_BUILDHOOKS="$SDK_BUILDHOOKS ./buildHook-minimal.sh"
		shift
		;;
	-X|--x86_64)
		echo "Enable option: 64bit (x86_64) build"
		export SDK_ARCH="amd64"
		shift
		;;
	-p|--proxy)
		echo "Enable option: Use APT proxy"
		case "$2" in
			"") echo "No proxy URL provided, exiting"; exit ;;
			*)  PROXY_URL=$2;;
		esac

		export APT_HTTP_PROXY=$PROXY_URL
		export APT_FTP_PROXY=$PROXY_URL

		# We use apt-cacher when retrieving d-i udebs, too
		export http_proxy=$PROXY_URL
		export ftp_proxy=$PROXY_URL
		shift 2
		;;
	--) shift ; break ;;
	esac
done

./build.sh
