3. Vérification
🌞 Lister les périphériques de stockage branchés à la machine :

mohamed@tpos:~$ lsblk
NAME               MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda                  8:0    0   20G  0 disk
└─sda1               8:1    0   20G  0 part
  ├─pentakill-root 254:0    0  9.3G  0 lvm  /
  ├─pentakill-Swap 254:1    0  1.9G  0 lvm  [SWAP]
  ├─pentakill-home 254:2    0  1.9G  0 lvm  /home
  └─pentakill-var  254:3    0  2.8G  0 lvm  /var
sr0                 11:0    1 1024M  0 rom


🌞 Lister les partitions en cours d'utilisation :

mohamed@tpos:~$ df -hT
Filesystem                 Type      Size  Used Avail Use% Mounted on
udev                       devtmpfs  951M     0  951M   0% /dev
tmpfs                      tmpfs     197M  1.0M  196M   1% /run
/dev/mapper/pentakill-root ext4      9.1G  4.0G  4.7G  46% /
tmpfs                      tmpfs     984M     0  984M   0% /dev/shm
tmpfs                      tmpfs     5.0M  8.0K  5.0M   1% /run/lock
/dev/mapper/pentakill-home ext4      1.8G  1.7M  1.7G   1% /home
/dev/mapper/pentakill-var  ext4      2.7G  379M  2.2G  15% /var
tmpfs                      tmpfs     197M   52K  197M   1% /run/user/1000
tmpfs                      tmpfs     197M   48K  197M   1% /run/user/108



1. Taille et inodes
🌞 Lister la quantité d'inodes disponibles sur chaque partition :

mohamed@tpos:~$ df -i
Filesystem                 Inodes  IUsed  IFree IUse% Mounted on
udev                       243442    436 243006    1% /dev
tmpfs                      251812    719 251093    1% /run
/dev/mapper/pentakill-root 610800 117884 492916   20% /
tmpfs                      251812      1 251811    1% /dev/shm
tmpfs                      251812      5 251807    1% /run/lock
/dev/mapper/pentakill-home 121920     84 121836    1% /home
/dev/mapper/pentakill-var  183264   6436 176828    4% /var
tmpfs                       50362     67  50295    1% /run/user/1000
tmpfs                       50362     60  50302    1% /run/user/108


🌞 Déterminer la taille (avec du) et l'inode (avec ls) de chacun des fichiers suivants :

mohamed@tpos:~$ du -h /boot/vmlinuz*  && ls -i /boot/vmlinuz*
7.9M    /boot/vmlinuz-6.1.0-25-amd64
7.9M    /boot/vmlinuz-6.1.0-27-amd64
130308 /boot/vmlinuz-6.1.0-25-amd64  130313 /boot/vmlinuz-6.1.0-27-amd64
utsu@utsu:~$ du -h $(which bash) && ls -i $(which bash)
1.3M    /usr/bin/bash
392425 /usr/bin/bash
mohamed@tpos:~$ du -h /etc/passwd && ls -i /etc/passwd
4.0K    /etc/passwd
412432 /etc/passwd



II. Partitioning

1. d disk partou
🌞 Repérer le nom des nouveaux disques :

mohamed@tpos:~$ lsblk
NAME               MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda                  8:0    0   20G  0 disk
└─sda1               8:1    0   20G  0 part
  ├─pentakill-root 254:0    0  9.3G  0 lvm  /
  ├─pentakill-Swap 254:1    0  1.9G  0 lvm  [SWAP]
  ├─pentakill-home 254:2    0  1.9G  0 lvm  /home
  └─pentakill-var  254:3    0  2.8G  0 lvm  /var
sdb                  8:16   0   10G  0 disk
sdc                  8:32   0   10G  0 disk
sr0                 11:0    1 1024M  0 rom


🌞 Ajouter ces deux disques comme des PV LVM :

mohamed@tpos:~$ sudo pvcreate /dev/sdb
  Physical volume "/dev/sdb" successfully created.
mohamed@tpos:~$ sudo pvcreate /dev/sdc
  Physical volume "/dev/sdc" successfully created.
mohamed@tpos:~$ sudo pvs
  PV         VG        Fmt  Attr PSize   PFree
  /dev/sda1  pentakill lvm2 a--  <20.00g  4.17g
  /dev/sdb             lvm2 ---   10.00g 10.00g
  /dev/sdc             lvm2 ---   10.00g 10.00g


🌞 Créer un VG nommé cat :

mohamed@tpos:~$ sudo vgcreate cat /dev/sdb /dev/sdc
  Volume group "cat" successfully created
mohamed@tpos:~$ sudo pvs
  PV         VG        Fmt  Attr PSize   PFree
  /dev/sda1  pentakill lvm2 a--  <20.00g   4.17g
  /dev/sdb   cat       lvm2 a--  <10.00g <10.00g
  /dev/sdc   cat       lvm2 a--  <10.00g <10.00g


🌞 Créer un LV nommé meoooow :

mohamed@tpos:~$ sudo lvcreate -L 3G cat -n meoooow
  Logical volume "meoooow" created.
mohamed@tpos:~$ sudo lvdisplay
  --- Logical volume ---
  LV Path                /dev/cat/meoooow
  LV Name                meoooow
  VG Name                cat
  LV UUID                h26fNs-p2xA-4jXE-i12M-IQl3-XbH2-gVJWja
  LV Write Access        read/write
  LV Creation host, time utsu, 2024-11-18 08:17:16 +0100
  LV Status              available
  # open                 0
  LV Size                3.00 GiB
  Current LE             768
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           254:4


🌞 Formater la partition (le LV) en autre chose que ext4 :

mohamed@tpos:~$ sudo apt-get install xfsprogs
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
xfsprogs is already the newest version (6.1.0-1).
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
mohamed@tpos:~$ sudo mkfs.xfs /dev/cat/meoooow
meta-data=/dev/cat/meoooow       isize=512    agcount=4, agsize=196608 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=0
data     =                       bsize=4096   blocks=786432, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


🌞 Créer le point de montage /mnt/meow :

mohamed@tpos:~$ sudo mkdir -p /mnt/meow



🌞 Monter la partition meoooow sur le point de montage que vous avez créé :

mohamed@tpos:~$ sudo mount /dev/cat/meoooow /mnt/meow


🌞 Vérifier avec la commande adaptée que la partition est utilisable et qu'elle fait 3G :

mohamed@tpos:~$ df -Th | grep meow
/dev/mapper/cat-meoooow    xfs       3.0G   54M  2.9G   2% /mnt/meow



1. Grow !
🌞 Il reste 2G sur le disque dur principal :

mohamed@tpos:~$ sudo lvextend -L +2G /dev/pentakill/home
  Size of logical volume pentakill/home changed from <1.86 GiB (476 extents) to <3.86 GiB (988 extents).
  Logical volume pentakill/home successfully resized.
mohamed@tpos:~$ sudo resize2fs /dev/pentakill/home
resize2fs 1.47.0 (5-Feb-2023)
Filesystem at /dev/pentakill/home is mounted on /home; on-line resizing required
old_desc_blocks = 1, new_desc_blocks = 1
The filesystem on /dev/pentakill/home is now 1011712 (4k) blocks long.


🌞 Prouvez en affichant la liste des partitions que la partition fait désormais 2G de plus :

mohamed@tpos:~$ df -h /home
Filesystem                  Size  Used Avail Use% Mounted on
/dev/mapper/pentakill-home  3.8G  1.7M  3.6G   1% /home


🌞 Agrandir la partition meoooow pour qu'elle occupe tout l'espace libre de son VG :

mohamed@tpos:~$ sudo lvextend -l 100%FREE /dev/cat/meoooow
  Size of logical volume cat/meoooow changed from 3.00 GiB (768 extents) to 16.99 GiB (4350 extents).
  Logical volume cat/meoooow successfully resized.
mohamed@tpos:~$ sudo xfs_growfs /mnt/meow
meta-data=/dev/mapper/cat-meoooow isize=512    agcount=4, agsize=196608 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=0
data     =                       bsize=4096   blocks=786432, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
data blocks changed from 786432 to 4454400


🌞 Déterminer la taille de la nouvelle partition:

mohamed@tpos:~$ df -h /mnt/meow
Filesystem               Size  Used Avail Use% Mounted on
/dev/mapper/cat-meoooow   17G  155M   17G   1% /mnt/meow



1. Montage automatique
🌞 Modifier le fichier /etc/fstab pour que la partition soit montée /mnt/meow automatiquement :

mohamed@tpos:~$ sudo nano /etc/fstab



  GNU nano 7.2                                                         /etc/fstab                                                                   # /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# systemd generates mount units based on this file, see systemd.mount(5).
# Please run 'systemctl daemon-reload' after making changes here.
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
/dev/mapper/pentakill-root /               ext4    errors=remount-ro 0       1
/dev/mapper/pentakill-home /home           ext4    defaults        0       2
/dev/mapper/pentakill-var /var            ext4    defaults        0       2
/dev/mapper/pentakill-Swap none            swap    sw              0       0
/dev/sr0        /media/cdrom0   udf,iso9660 user,noauto     0       0
/dev/cat/meoooow  /mnt/meow  xfs  defaults,noexec,nosuid,nodev  0  0