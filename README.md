Why NTFS Recovery ?
===================

Sometimes, a damaged NTFS partition has so many errors that: it can't be mounted by the NTFS driver and it can't be fixed by tools like ntfsck or ntfsfix. They ask you to use CHKDSK on Windows which is way more powerful. But sometimes the partition is so damaged that even CHKDSK doesn't recognize the file system and it refuses to fix it.

It happened to me with a phisicaly hurted hard drive that I had no way to mount. After a lot of researches I found that the ntfsls and ntfscat commands from the ntfs-3g package were able to access very specific files without mounting the whole partition. That's why I decided to create a bash script to make the copy of a complete folder with these commands automatic.

This script is probably not optimal as it has to wait 5 seconds for a remount after every met error (and it should meet a lot of errors...). Try it when you realy have no other way to backup your files. I of course can't guarantee anything, so use it at your own risk.

But anyway it was the **only** way for me to backup my hard drive. So, why wouldn't you give a cool 42-lines, WTFPL-licensed script a try ?

How to use it ?
===============

First you must get a copy of the script with the following command:

* git clone https://github.com/FlorentRevest/ntfs-recovery.git
* cd ntfs-recovery
* chmod +x ntfs-recovery
* sudo apt-get install ntfs-3g

Then you can start the recovery process by using the command as follow:

* ./ntfs-recovery.sh /dev/sdb1 Users/usr/Pictures backup

You must of course change

* */dev/sdb1* by the device file containing your partition
* *Users/usr/Pictures* by the directory **on the ntfs partition** that contains the files you want to get back
* *backup* by the target directory **on your linux system** that will receive the recovered files

Please let me know if this script helps you in any way or if there is a way to improve it. I'd be glad to learn that my work was useful.