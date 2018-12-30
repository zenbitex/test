
Debian
====================
This directory contains files used to package futurexcod/futurexco-qt
for Debian-based Linux systems. If you compile futurexcod/futurexco-qt yourself, there are some useful files here.

## futurexco: URI support ##


futurexco-qt.desktop  (Gnome / Open Desktop)
To install:

	sudo desktop-file-install futurexco-qt.desktop
	sudo update-desktop-database

If you build yourself, you will either need to modify the paths in
the .desktop file or copy or symlink your futurexcoqt binary to `/usr/bin`
and the `../../share/pixmaps/futurexco128.png` to `/usr/share/pixmaps`

futurexco-qt.protocol (KDE)
