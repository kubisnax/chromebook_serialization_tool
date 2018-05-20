# chromebook_serialization_tool
The Chromebook Serialization Tool (CST) was created to simplify the process of applying custom serial numbers to Chromebook devices. This is an open-source project written in Bash and can be run via the developer terminal on any Chromebook device. 

Instructions for Use:
1.	Enable & boot to Developer Mode on target device.
2.	Insert USB containing CST.
3.	Enter Browse as Guest to allow USB device to mount properly
4.	Enter developer shell with Ctrl+Alt+        keys pressed simultaneously. 
5.	Login as user chronos
6.	Enter command sudu su
7.	Enter command /bin/bash /media/removable/$USB cst.sh
(CST will then display the current serial number as well as service tag if applicable.)
8.	User will be prompted to then enter their custom serial number i.e. KKAAA999T3
(CST will use vpd to write the entered custom serial to the target device.)
9.	User will be prompted to enter 1 to finish the process or enter 2 to restart the process.
</br>a.	Restarting the process will follow the same instruction as the initial serialization process and can be redone as many times as necessary.
</br>b.	The finish process will set gbb_flags to 0x0, dump vpd logs, delete mlb_serial_number and delete stable_device_secret_DO_NOT_SHARE then shutdown the system. 
