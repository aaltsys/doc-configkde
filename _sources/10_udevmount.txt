######################################
 Mounting Devices through udev
######################################

eSATA hot-mount drive setup
======================================

.. Note:: This guide registers a *BUFFALO External* drive and mounts it at */home/mnt/backup*.

#. The permanent logical mount point for the backup device will be ``/home/mnt/backup``.
#. Display a terminal command line on the server console, or *ssh* to a server command shell.
#. Plug in the hot-pluggable device on a **USB** or **eSATA** port.
#. At the command prompt, type::

	dmesg | tail 20

#. Output similar to the following will be displayed::
	
	...
	[ 5891.570018] ata6: link is slow to respond, please be patient (ready=0)
	[ 5893.250023] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
	[ 5893.260131] ata6.00: ATA-6: BUFFALO External HDD, CC46, max UDMA/133
	[ 5893.260136] ata6.00: 1953525168 sectors, multi 0: LBA48 
	[ 5893.271998] ata6.00: configured for UDMA/133
	[ 5893.272007] ata6: EH complete
	[ 5893.272117] scsi 5:0:0:0: Direct-Access     ATA      BUFFALO External CC46 PQ: 0 ANSI: 5
	[ 5893.272339] sd 5:0:0:0: Attached scsi generic sg3 type 0
	[ 5893.272669] sd 5:0:0:0: [sdc] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
	[ 5893.272727] sd 5:0:0:0: [sdc] Write Protect is off
	[ 5893.272731] sd 5:0:0:0: [sdc] Mode Sense: 00 3a 00 00
	[ 5893.272762] sd 5:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn''t support DPO or FUA
	[ 5893.272939]  sdc: sdc1 < sdc5 >
	[ 5893.293515] sd 5:0:0:0: [sdc] Attached SCSI disk

#. This shows a ``BUFFALO External`` device as ``sdc``. Enumerate the system device information for ``sdc`` with the command::

	udevadm info --name=sdc --attribute-walk

#. Now scroll up the output to find the *BUFFALO External* parent device section. Note the subsystem, model, and state::

	 looking at parent device '/devices/pci0000:00/0000:00:1f.2/host5/target5:0:0/5:0:0:0':
	    KERNELS=="5:0:0:0"
	    SUBSYSTEMS=="scsi"
	    DRIVERS=="**sd**"
	    ATTRS{device_blocked}=="0"
	    ATTRS{type}=="0"
	    ATTRS{scsi_level}=="6"
	    ATTRS{vendor}=="ATA     "
	    ATTRS{model}=="BUFFALO External"
	    ATTRS{rev}=="CC46"
	    ATTRS{state}=="running"
	    ...

#. Add a ``udev`` rule in directory ``/etc/udev/rules.d/`` to establish a mount for the device. We chose the filename::

	/etc/udev/rules.d/20-buffalo.rules

#. Edit the file and insert the rule. Our data for the command, based on the attributes above and the specified mount point, is::

	 KERNEL=="sd?", SUBSYSTEMS=="scsi", ATTRS{model}=="BUFFALO External", ATTRS{state}=="running", RUN+="/bin/mount /dev/%k5 /home/mnt/backup"

#. After saving the rule, and with the device connected, verify the rule with the command::

	sudo reload udev 
	sudo udevadm test /block/sdc

#. The command output should be similar to the following::

	 ...
	 udevadm_test: ID_ATA_SATA=1
	 udevadm_test: ID_ATA_SATA_SIGNAL_RATE_GEN2=1
	 udevadm_test: ID_ATA_SATA_SIGNAL_RATE_GEN1=1
	 udevadm_test: ID_SCSI_COMPAT=SATA_BUFFALO_Externa_6VPB88MX
	 udevadm_test: ID_PATH=pci-0000:00:1f.2-scsi-2:0:0:0
	 udevadm_test: ID_PART_TABLE_TYPE=dos
	 udevadm_test: UDISKS_PRESENTATION_NOPOLICY=0
	 udevadm_test: UDISKS_PARTITION_TABLE=1
	 udevadm_test: UDISKS_PARTITION_TABLE_SCHEME=mbr
	 udevadm_test: UDISKS_PARTITION_TABLE_COUNT=2
	 udevadm_test: UDISKS_ATA_SMART_IS_AVAILABLE=1
	 udevadm_test: run: '/bin/mount /dev/sdc5 /home/mnt/backup'
	 udevadm_test: run: '/lib/udev/hdparm'
	 udevadm_test: run: 'socket:@/org/freedesktop/hal/udev_event'

#. Now unplug the ``eSATA`` or ``USB`` cable, and then plug it back into the device.
#. Run the command :kbd:`mount` and look for the device in the command output, as for example the following::

	 /dev/mapper/ddf1_aaltsys1 on / type ext4 (rw,errors=remount-ro)
	 ...
	 none on /var/lib/ureadahead/debugfs type debugfs (rw,relatime)
	 /dev/mapper/ddf1_aaltsys6 on /home type ext4 (rw,usrquota,grpquota,acl)
	 rpc_pipefs on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)
	 nfsd on /proc/fs/nfsd type nfsd (rw)
	 /dev/sdc5 on /home/mnt/backup type fuseblk (rw,nosuid,nodev,allow_other,blksize=4096)

The device is mounted and ready. Now it may be hot connected and disconnected, and it will auto-mount on connection.

Disconnecting a hot-mounted drive
======================================

Unmount a device before disconnecting it. In this example, the unmount command would be::

	umount /home/mnt/backup

.. Warning:: Before disconnecting a hot-mounted device it must be unmounted. Otherwise the device may become corrupted or unusable.


References
=======================================

#. We found the following guide useful: `http://cdfx.penguins-on-hudson.com/2010/01/20/automount-removable-devices-on-ubuntu-servers/`. Be aware that all the **udev** command syntax has changed since the guide was written, as the following table shows.

 +------------------------------------+------------------------------------------------+
 | Command in Penguins Guide          | Current Command Syntax Equivalent              |
 +====================================+================================================+
 | udevinfo -a -p /sys/block/sdb      | udevadm info --name=sdb --attribute-walk       |
 +------------------------------------+------------------------------------------------+
 | sudo udevcontrol reload_rules      | sudo reload udev                               |
 +------------------------------------+------------------------------------------------+
 | udevtest /sys/block/sdb/sdb1 usb   | sudo udevadm test /block/sdb                   |
 +------------------------------------+------------------------------------------------+
