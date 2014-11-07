KDE Connect Indicator
=====================

This Indicator is written to make [KDE Connect](https://community.kde.org/KDEConnect) usable in Ubuntu and Pantheon DE.
It's started as an [AppIndicator](https://unity.ubuntu.com/projects/appindicators/) but later i add a binary file to send file and url easily through KDE Connect.

Features: 
-------
 1. Indicator in the panel which show your devices, with its name, status, and battery.
 2. menu to request for pairing and unpairing
 3. menu to start sftp and open file browser
 4. a small program, `kdeconnect-send` to help sending file and choosing device
 5. a .contractor file, so you can send file from any of elementary OS's applications

Limitation
-------
Currently this is have some limitation:
 1. As Ubuntu and Pantheon notification doesn't (yet) support applying or rejecting pair request, you can only request to pair from desktop to your phone.
 2. Will work better in KDE Connect 0.7.1 and up

Usage Suggestions
-------
 To make life better you can try to apply this:

 1. add KDE Connect Indicator to your startup applications, on your System Setting
 2. for Nautilus or Thunar user, create a Nautilus-actions or Thunar-actions entry with  `kdeconnect-send %f`as  command

Please report issues and suggestion here:
https://github.com/vikoadi/indicator-kdeconnect

