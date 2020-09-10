# vmware-vm-hardening
Script to verify and automatic apply hardening policies.

The script verify and fix the following points.
1) isolation.tools.copy.disable #Set to $true
2) isolation.tools.dnd.disable #Set to $true
3) isolation.tools.setGUIOptions.enable #Set to $false
4) isolation.tools.paste.disable #Set to $true
5) isolation.tools.diskShrink.disable #Set to $true
6) isolation.tools.diskWiper.disable #Set to $true
7) isolation.tools.hgfs.disable #Set to $true
8) disable-independent-nonpersistent
9) mks.enable3d #Set to $false
10) isolation.tools.memSchedFakeSampleStats.disable #Set to $true
11) detect floppy devices.
12) detect parallel devices
13) detect serial devices
14) detect usb devices
15) tools.setInfo.sizeLimit # Set to "1048576 (1MB)"
16) RemoteDisplay.vnc.enabled #Set to $false
17) tools.guestlib.enableHostInfo #Set to $false
18) Mem.ShareForceSalting #Set to 1
19) RemoteDisplay.maxConnections #Set to 1
20) isolation.device.edit.disable #Set to $true
21) isolation.device.connectable.disable #Set to $true 
22) log.keepOld #Set to 10
23) log.rotateSize #Set to 1024000 (1MB)
24) PCI-Passthrough

Items:
8
11
12
13
14
24
Just check if it exists or not. Because each infrastructure has its own policy, but the recommendation is not to use the options unless it is necessary.
