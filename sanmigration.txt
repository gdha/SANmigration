= SAN Migration tools for itshrr0[1-3] Hands-on

The purpose of these tools are to create a snapshot of the current *_non-vg00_* SAN Volume Groups and afterwards being able to recreate the complete SAN layout from scratch. However, it requires the same amount (and sized) SAN disks on the new SAN box.
Therefore, two scripts (and and subdirectory with functions) were created to handle these tasks in a semi-automated way.
The scripts are available on the 3 servers (itshrr01.jnj.com, itshrr02.jnj.com and itshrr03.jnj.com). Of course, these can be used on any HP-UX system (at least 11.31 was tested well, 11.23 should work but cannot promise it won't break somewhere, 11.11 has not been tested yet).

So, the purpose is to recreate from scratch all volume groups, lvols, and file systems as they were before (at the moment we took the snapshot of the SAN layout). To make a SAN snapshot, run the the first script +save_san_layout.sh+.

== Saving the current SAN layout

The first step we *must* execute before vgexporting any volume group is to save the current SAN layout in a SAN Configuration file. The script +save_san_layout.sh+ will take care of this. A step by step example to clarify:

----
#-> cd /home/gdhaese1/projects/SANmigration/
#-> ./save_san_layout.sh
###############################################################################################
  Installation Script: save_san_layout.sh
              Purpose: Save the current SAN configuration file (SAN_layout_of_itshrr01.conf)
           OS Release: 11.31
                Model: ia64
    Installation Host: itshrr01
    Installation User: root
    Installation Date: 2012-08-14 @ 07:17:06
     Installation Log: /var/adm/install-logs/save_san_layout.scriptlog
###############################################################################################
 ** Running on HP-UX 11.31
 ** Created temporary directory /tmp/san016223
 ** Saving ioscan output of disks as /tmp/san016223/ioscan.out
Progress: *
Total wait time: 3 second(s)

 ** Storage box in use is of type xp
 ** Saving xpinfo output as /tmp/san016223/xpinfo.out
Progress: ***
Total wait time: 9 second(s)

 ** Saved /etc/lvmtab as /tmp/san016223/lvmtab.out
 ** Saved /etc/lvmpvg as /tmp/san016223/lvmpvg.out
 ** Analyzing disk /dev/rdisk/disk24
 ** Analyzing disk /dev/rdisk/disk35
 ** Analyzing disk /dev/rdisk/disk7
 ** Analyzing disk /dev/rdisk/disk6
 ** Analyzing disk /dev/rdisk/disk9
 ** Analyzing disk /dev/rdisk/disk12
 ** Analyzing disk /dev/rdisk/disk15
 ** Analyzing disk /dev/rdisk/disk34
 ** Analyzing disk /dev/rdisk/disk31
 ** Analyzing disk /dev/rdisk/disk42
 ** Analyzing disk /dev/rdisk/disk11
 ** Analyzing disk /dev/rdisk/disk22
 ** Analyzing disk /dev/rdisk/disk16
 ** Analyzing disk /dev/rdisk/disk13
 ** Analyzing disk /dev/rdisk/disk46
 ** Analyzing disk /dev/rdisk/disk20
 ** Analyzing disk /dev/rdisk/disk44
 ** Analyzing disk /dev/rdisk/disk53
 ** Analyzing disk /dev/rdisk/disk19
 ** Analyzing disk /dev/rdisk/disk30
 ** Analyzing disk /dev/rdisk/disk68
 ** Analyzing disk /dev/rdisk/disk41
 ** Analyzing disk /dev/rdisk/disk21
 ** Analyzing disk /dev/rdisk/disk39
 ** Analyzing disk /dev/rdisk/disk63
 ** Analyzing disk /dev/rdisk/disk60
 ** Analyzing disk /dev/rdisk/disk23
 ** Analyzing disk /dev/rdisk/disk17
 ** Analyzing disk /dev/rdisk/disk38
 ** Analyzing disk /dev/rdisk/disk18
 ** Analyzing disk /dev/rdisk/disk25
 ** Analyzing disk /dev/rdisk/disk36
 ** Analyzing disk /dev/rdisk/disk54
 ** Analyzing disk /dev/rdisk/disk55
 ** Analyzing disk /dev/rdisk/disk32
 ** Analyzing disk /dev/rdisk/disk8
 ** Analyzing disk /dev/rdisk/disk48
 ** Analyzing disk /dev/rdisk/disk33
 ** Analyzing disk /dev/rdisk/disk28
 ** Analyzing disk /dev/rdisk/disk45
 ** Analyzing disk /dev/rdisk/disk69
 ** Analyzing disk /dev/rdisk/disk56
 ** Analyzing disk /dev/rdisk/disk51
 ** Analyzing disk /dev/rdisk/disk10
 ** Analyzing disk /dev/rdisk/disk74
 ** Analyzing disk /dev/rdisk/disk47
 ** Analyzing disk /dev/rdisk/disk62
 ** Analyzing disk /dev/rdisk/disk59
 ** Analyzing disk /dev/rdisk/disk67
 ** Analyzing disk /dev/rdisk/disk73
 ** Analyzing disk /dev/rdisk/disk43
 ** Analyzing disk /dev/rdisk/disk14
 ** Analyzing disk /dev/rdisk/disk66
 ** Analyzing disk /dev/rdisk/disk29
 ** Analyzing disk /dev/rdisk/disk58
 ** Analyzing disk /dev/rdisk/disk49
 ** Analyzing disk /dev/rdisk/disk50
 ** Analyzing disk /dev/rdisk/disk61
 ** Analyzing disk /dev/rdisk/disk26
 ** Analyzing disk /dev/rdisk/disk40
 ** Analyzing disk /dev/rdisk/disk64
 ** Analyzing disk /dev/rdisk/disk27
 ** Analyzing disk /dev/rdisk/disk65
 ** Analyzing disk /dev/rdisk/disk52
 ** Analyzing disk /dev/rdisk/disk72
 ** Analyzing disk /dev/rdisk/disk70
 ** Analyzing disk /dev/rdisk/disk57
 ** Analyzing disk /dev/rdisk/disk37
 ** Analyzing disk /dev/rdisk/disk71
 ** Analyzing physical volume /dev/disk/disk24
 ** Analyzing physical volume /dev/disk/disk35
 ** Analyzing physical volume /dev/disk/disk7
 ** Analyzing physical volume /dev/disk/disk6
 ** Analyzing physical volume /dev/disk/disk9
 ** Analyzing physical volume /dev/disk/disk12
 ** Analyzing physical volume /dev/disk/disk15
 ** Analyzing physical volume /dev/disk/disk34
 ** Analyzing physical volume /dev/disk/disk31
 ** Analyzing physical volume /dev/disk/disk42
 ** Analyzing physical volume /dev/disk/disk11
 ** Analyzing physical volume /dev/disk/disk22
 ** Analyzing physical volume /dev/disk/disk16
 ** Analyzing physical volume /dev/disk/disk13
 ** Analyzing physical volume /dev/disk/disk46
 ** Analyzing physical volume /dev/disk/disk20
 ** Analyzing physical volume /dev/disk/disk44
 ** Analyzing physical volume /dev/disk/disk53
 ** Analyzing physical volume /dev/disk/disk19
 ** Analyzing physical volume /dev/disk/disk30
 ** Analyzing physical volume /dev/disk/disk68
 ** Analyzing physical volume /dev/disk/disk41
 ** Analyzing physical volume /dev/disk/disk21
 ** Analyzing physical volume /dev/disk/disk39
 ** Analyzing physical volume /dev/disk/disk63
 ** Analyzing physical volume /dev/disk/disk60
 ** Analyzing physical volume /dev/disk/disk23
 ** Analyzing physical volume /dev/disk/disk17
 ** Analyzing physical volume /dev/disk/disk38
 ** Analyzing physical volume /dev/disk/disk18
 ** Analyzing physical volume /dev/disk/disk25
 ** Analyzing physical volume /dev/disk/disk36
 ** Analyzing physical volume /dev/disk/disk54
 ** Analyzing physical volume /dev/disk/disk55
 ** Analyzing physical volume /dev/disk/disk32
 ** Analyzing physical volume /dev/disk/disk8
 ** Analyzing physical volume /dev/disk/disk48
 ** Analyzing physical volume /dev/disk/disk33
 ** Analyzing physical volume /dev/disk/disk28
 ** Analyzing physical volume /dev/disk/disk45
 ** Analyzing physical volume /dev/disk/disk69
 ** Analyzing physical volume /dev/disk/disk56
 ** Analyzing physical volume /dev/disk/disk51
 ** Analyzing physical volume /dev/disk/disk10
 ** Analyzing physical volume /dev/disk/disk74
 ** Analyzing physical volume /dev/disk/disk47
 ** Analyzing physical volume /dev/disk/disk62
 ** Analyzing physical volume /dev/disk/disk59
 ** Analyzing physical volume /dev/disk/disk67
 ** Analyzing physical volume /dev/disk/disk73
 ** Analyzing physical volume /dev/disk/disk43
 ** Analyzing physical volume /dev/disk/disk14
 ** Analyzing physical volume /dev/disk/disk66
 ** Analyzing physical volume /dev/disk/disk29
 ** Analyzing physical volume /dev/disk/disk58
 ** Analyzing physical volume /dev/disk/disk49
 ** Analyzing physical volume /dev/disk/disk50
 ** Analyzing physical volume /dev/disk/disk61
 ** Analyzing physical volume /dev/disk/disk26
 ** Analyzing physical volume /dev/disk/disk40
 ** Analyzing physical volume /dev/disk/disk64
 ** Analyzing physical volume /dev/disk/disk27
 ** Analyzing physical volume /dev/disk/disk65
 ** Analyzing physical volume /dev/disk/disk52
 ** Analyzing physical volume /dev/disk/disk72
 ** Analyzing physical volume /dev/disk/disk70
 ** Analyzing physical volume /dev/disk/disk57
 ** Analyzing physical volume /dev/disk/disk37
 ** Analyzing physical volume /dev/disk/disk71
 ** Analyzing Volume group /dev/vg_RJ1
 ** Analyzing Volume group /dev/vg_ZR1
 ** Analyzing Volume group /dev/vg_RJ7
 ** Analyzing Volume group /dev/vg_sap
 ** Analyzing Volume group /dev/vg_oracle
 ** Analyzing Volume group /dev/vg_openv
 ** Analyzing logical Volume /dev/vg_RJ1/lv_oracleRJ1_sapdata1
 ** Analyzing logical Volume /dev/vg_RJ1/lv_oracleRJ1_sapdata2
 ** Analyzing logical Volume /dev/vg_RJ1/lv_oracleRJ1_sapdata3
 ** Analyzing logical Volume /dev/vg_RJ1/lv_oracleRJ1_sapdata4
 ** Analyzing logical Volume /dev/vg_RJ1/lv_oracleRJ1_origlogB
 ** Analyzing logical Volume /dev/vg_RJ1/lv_oracleRJ1_origlogA
 ** Analyzing logical Volume /dev/vg_RJ1/lv_oracleRJ1_oraarch
 ** Analyzing logical Volume /dev/vg_RJ1/lv_oracleRJ1_mirrlogB
 ** Analyzing logical Volume /dev/vg_RJ1/lv_oracleRJ1_mirrlogA
 ** Analyzing logical Volume /dev/vg_RJ1/lv_exportsapmnt_RJ1
 ** Analyzing logical Volume /dev/vg_RJ1/lv_usrsapRJ1_DVEBMGS19
 ** Analyzing logical Volume /dev/vg_RJ1/lv_exportoracleRJ1_sapbackup
 ** Analyzing logical Volume /dev/vg_RJ1/lv_usrsapRJ1_ASCS05
 ** Analyzing logical Volume /dev/vg_RJ1/lv_oracle_RJ1
 ** Analyzing logical Volume /dev/vg_RJ1/lv_oracleRJ1_112_64
 ** Analyzing logical Volume /dev/vg_RJ1/lv_oracleRJ1_sapreorg
 ** Analyzing logical Volume /dev/vg_ZR1/lv_sapmnt_ZR1
 ** Analyzing logical Volume /dev/vg_ZR1/lv_usrsap_ZR1
 ** Analyzing logical Volume /dev/vg_RJ7/lv_oracleRJ7_sapdata1
 ** Analyzing logical Volume /dev/vg_RJ7/lv_oracleRJ7_sapdata2
 ** Analyzing logical Volume /dev/vg_RJ7/lv_oracleRJ7_origlogA
 ** Analyzing logical Volume /dev/vg_RJ7/lv_oracleRJ7_origlogB
 ** Analyzing logical Volume /dev/vg_RJ7/lv_oracleRJ7_mirrlogA
 ** Analyzing logical Volume /dev/vg_RJ7/lv_oracleRJ7_mirrlogB
 ** Analyzing logical Volume /dev/vg_RJ7/lv_oracleRJ7_102_64
 ** Analyzing logical Volume /dev/vg_RJ7/lv_oracleRJ7_oraarch
 ** Analyzing logical Volume /dev/vg_RJ7/lv_oracleRJ7_sapbackup
 ** Analyzing logical Volume /dev/vg_RJ7/lv_oracleRJ7_saparch
 ** Analyzing logical Volume /dev/vg_RJ7/lv_oracleRJ7_RJ7
 ** Analyzing logical Volume /dev/vg_sap/lv_usr_sap
 ** Analyzing logical Volume /dev/vg_sap/lv_usrsap_SMD
 ** Analyzing logical Volume /dev/vg_sap/lv_usrsapRJ1_ERS05
 ** Analyzing logical Volume /dev/vg_sap/lv_usrsapRJ6_ERS25
 ** Analyzing logical Volume /dev/vg_sap/lv_usrsapSMD_J97
 ** Analyzing logical Volume /dev/vg_sap/lv_usrsapSMD_J98
 ** Analyzing logical Volume /dev/vg_sap/lv_sapmnt
 ** Analyzing logical Volume /dev/vg_oracle/lv_oracle
 ** Analyzing logical Volume /dev/vg_oracle/lv_oracle_stage
 ** Analyzing logical Volume /dev/vg_oracle/lv_oracle_client
 ** Analyzing logical Volume /dev/vg_openv/lv_usr_openv
 ** Analyzing logical Volume /dev/vg_openv/lv_usropenvnetbackup_logs
 ** Analyzing logical Volume /dev/vg_openv/lv_usropenv_logs
 ** Analyzing logical Volume /dev/vg_openv/lv_usropenv_patches
 ** Analyzing mount point /oracle/RJ1/sapdata1 (lvol /dev/vg_RJ1/lv_oracleRJ1_sapdata1)
 ** Analyzing mount point /oracle/RJ1/sapdata2 (lvol /dev/vg_RJ1/lv_oracleRJ1_sapdata2)
 ** Analyzing mount point /oracle/RJ1/sapdata3 (lvol /dev/vg_RJ1/lv_oracleRJ1_sapdata3)
 ** Analyzing mount point /oracle/RJ1/sapdata4 (lvol /dev/vg_RJ1/lv_oracleRJ1_sapdata4)
 ** Analyzing mount point /oracle/RJ1/origlogB (lvol /dev/vg_RJ1/lv_oracleRJ1_origlogB)
 ** Analyzing mount point /oracle/RJ1/origlogA (lvol /dev/vg_RJ1/lv_oracleRJ1_origlogA)
 ** Analyzing mount point /oracle/RJ1/oraarch (lvol /dev/vg_RJ1/lv_oracleRJ1_oraarch)
 ** Analyzing mount point /oracle/RJ1/mirrlogB (lvol /dev/vg_RJ1/lv_oracleRJ1_mirrlogB)
 ** Analyzing mount point /oracle/RJ1/mirrlogA (lvol /dev/vg_RJ1/lv_oracleRJ1_mirrlogA)
 ** Analyzing mount point /export/sapmnt/RJ1 (lvol /dev/vg_RJ1/lv_exportsapmnt_RJ1)
 ** Analyzing mount point /usr/sap/RJ1/DVEBMGS19 (lvol /dev/vg_RJ1/lv_usrsapRJ1_DVEBMGS19)
 ** Analyzing mount point /export/oracle/RJ1/sapbackup (lvol /dev/vg_RJ1/lv_exportoracleRJ1_sapbackup)
 ** Analyzing mount point /usr/sap/RJ1/ASCS05 (lvol /dev/vg_RJ1/lv_usrsapRJ1_ASCS05)
 ** Analyzing mount point /oracle/RJ1 (lvol /dev/vg_RJ1/lv_oracle_RJ1)
 ** Analyzing mount point /oracle/RJ1/112_64 (lvol /dev/vg_RJ1/lv_oracleRJ1_112_64)
 ** Analyzing mount point /oracle/RJ1/sapreorg (lvol /dev/vg_RJ1/lv_oracleRJ1_sapreorg)
 ** Analyzing mount point /sapmnt/ZR1 (lvol /dev/vg_ZR1/lv_sapmnt_ZR1)
 ** Analyzing mount point /usr/sap/ZR1 (lvol /dev/vg_ZR1/lv_usrsap_ZR1)
 ** Analyzing mount point /oracle/RJ7/sapdata1 (lvol /dev/vg_RJ7/lv_oracleRJ7_sapdata1)
 ** Analyzing mount point /oracle/RJ7/sapdata2 (lvol /dev/vg_RJ7/lv_oracleRJ7_sapdata2)
 ** Analyzing mount point /oracle/RJ7/origlogA (lvol /dev/vg_RJ7/lv_oracleRJ7_origlogA)
 ** Analyzing mount point /oracle/RJ7/origlogB (lvol /dev/vg_RJ7/lv_oracleRJ7_origlogB)
 ** Analyzing mount point /oracle/RJ7/mirrlogA (lvol /dev/vg_RJ7/lv_oracleRJ7_mirrlogA)
 ** Analyzing mount point /oracle/RJ7/mirrlogB (lvol /dev/vg_RJ7/lv_oracleRJ7_mirrlogB)
 ** Analyzing mount point /oracle/RJ7/102_64 (lvol /dev/vg_RJ7/lv_oracleRJ7_102_64)
 ** Analyzing mount point /oracle/RJ7/oraarch (lvol /dev/vg_RJ7/lv_oracleRJ7_oraarch)
 ** Analyzing mount point /oracle/RJ7/sapbackup (lvol /dev/vg_RJ7/lv_oracleRJ7_sapbackup)
 ** Analyzing mount point /oracle/RJ7/saparch (lvol /dev/vg_RJ7/lv_oracleRJ7_saparch)
 ** Analyzing mount point /oracle/RJ7 (lvol /dev/vg_RJ7/lv_oracleRJ7_RJ7)
 ** Analyzing mount point /usr/sap (lvol /dev/vg_sap/lv_usr_sap)
 ** Analyzing mount point /usr/sap/SMD (lvol /dev/vg_sap/lv_usrsap_SMD)
 ** Analyzing mount point /usr/sap/RJ1/ERS05 (lvol /dev/vg_sap/lv_usrsapRJ1_ERS05)
 ** Analyzing mount point /usr/sap/RJ6/ERS25 (lvol /dev/vg_sap/lv_usrsapRJ6_ERS25)
 ** Analyzing mount point /usr/sap/SMD/J97 (lvol /dev/vg_sap/lv_usrsapSMD_J97)
 ** Analyzing mount point /usr/sap/SMD/J98 (lvol /dev/vg_sap/lv_usrsapSMD_J98)
 ** Analyzing mount point /sapmnt (lvol /dev/vg_sap/lv_sapmnt)
 ** Analyzing mount point /oracle (lvol /dev/vg_oracle/lv_oracle)
 ** Analyzing mount point /oracle/stage (lvol /dev/vg_oracle/lv_oracle_stage)
 ** Analyzing mount point /oracle/client (lvol /dev/vg_oracle/lv_oracle_client)
 ** Analyzing mount point /usr/openv (lvol /dev/vg_openv/lv_usr_openv)
 ** Analyzing mount point /usr/openv/netbackup/logs (lvol /dev/vg_openv/lv_usropenvnetbackup_logs)
 ** Analyzing mount point /usr/openv/logs (lvol /dev/vg_openv/lv_usropenv_logs)
 ** Analyzing mount point /usr/openv/patches (lvol /dev/vg_openv/lv_usropenv_patches)
 ** Removed temporary directory /tmp/san016223
Save the SANCONF=/tmp/SAN_layout_of_itshrr01.conf file at a safe place.
Done.
----

Nice, the SAN configuration file (+/tmp/SAN_layout_of_itshrr01.conf+) has been created successfully.
However, the script +save_san_layout.sh+ does understand some options. To view the usage, add the _-h_ option with the command:

----
#-> ./save_san_layout.sh -h
Usage: save_san_layout.sh [-f SAN_layout_configuration_file] [-k] [-h]

-f file: The SAN_layout_configuration_file to store in SAN layout in
-k:      Keep the temporary directory after we are finished executing save_san_layout.sh
-h:      Show usage [this page]
----

The _-f_ option gives you the opportunity to specify another location (and name) of the SAN Configuration file.The _-k_ option will not remove the temporary directory created by the script, which can be useful for debugging or in a production move to keep the data gathered by the script of the current (old?) SAN situation.

== The SAN Configuration layout file

The SAN Configuration layout file (+/tmp/SAN_layout_of_itshrr01.conf+) [replace the hostname itshrr01 by *$(hostname)*] looks like (don't be afraid of the amount of data you will see):

----
#-> cat /tmp/SAN_layout_of_itshrr01.conf
# SAN layout configuration file of system itshrr01
# created on 2012-Aug-14
#
# Syntax:
# san=[single|multiple] [xp|eva|...]
san=single xp
# Syntax:
# dev=/dev/rdisk/disk1;CU-ldev;type;sizeMB;SerialNr;RaidLevel;RaidGrp;VolMgr;sizeKB;bytes-per-sector;blocks-per-disk,santype
dev=/dev/rdisk/disk24;47:cf;OPEN-V;51200;00065760;TPVOL;---;---;52429440;512;104858880;xp
dev=/dev/rdisk/disk35;47:d0;OPEN-V;51200;00065760;TPVOL;---;---;52429440;512;104858880;xp
dev=/dev/rdisk/disk7;47:d1;OPEN-V;20480;00065760;TPVOL;---;---;20972160;512;41944320;xp
dev=/dev/rdisk/disk6;47:d2;OPEN-V;20480;00065760;TPVOL;---;---;20972160;512;41944320;xp
dev=/dev/rdisk/disk9;47:d3;OPEN-V;256000;00065760;TPVOL;---;---;262144320;512;524288640;xp
dev=/dev/rdisk/disk12;47:d4;OPEN-V;256000;00065760;TPVOL;---;---;262144320;512;524288640;xp
dev=/dev/rdisk/disk15;47:d5;OPEN-V;256000;00065760;TPVOL;---;---;262144320;512;524288640;xp
dev=/dev/rdisk/disk34;47:d6;OPEN-V;256000;00065760;TPVOL;---;---;262144320;512;524288640;xp
dev=/dev/rdisk/disk31;47:d7;OPEN-V;256000;00065760;TPVOL;---;---;262144320;512;524288640;xp
dev=/dev/rdisk/disk42;47:d8;OPEN-V;256000;00065760;TPVOL;---;---;262144320;512;524288640;xp
dev=/dev/rdisk/disk11;47:d9;OPEN-V;256000;00065760;TPVOL;---;---;262144320;512;524288640;xp
dev=/dev/rdisk/disk22;47:da;OPEN-V;256000;00065760;TPVOL;---;---;262144320;512;524288640;xp
dev=/dev/rdisk/disk16;47:db;OPEN-V;8192;00065760;TPVOL;---;---;8389440;512;16778880;xp
dev=/dev/rdisk/disk13;47:dc;OPEN-V;8192;00065760;TPVOL;---;---;8389440;512;16778880;xp
dev=/dev/rdisk/disk46;47:dd;OPEN-V;51200;00065760;TPVOL;---;---;52429440;512;104858880;xp
dev=/dev/rdisk/disk20;47:de;OPEN-V;51200;00065760;TPVOL;---;---;52429440;512;104858880;xp
dev=/dev/rdisk/disk44;47:df;OPEN-V;6144;00065760;TPVOL;---;---;6291840;512;12583680;xp
dev=/dev/rdisk/disk53;47:e0;OPEN-V;6144;00065760;TPVOL;---;---;6291840;512;12583680;xp
dev=/dev/rdisk/disk19;47:e1;OPEN-V;22528;00065760;TPVOL;---;---;23068800;512;46137600;xp
dev=/dev/rdisk/disk30;47:e2;OPEN-V;22528;00065760;TPVOL;---;---;23068800;512;46137600;xp
dev=/dev/rdisk/disk68;47:e3;OPEN-V;28672;00065760;TPVOL;---;---;29360640;512;58721280;xp
dev=/dev/rdisk/disk41;47:e4;OPEN-V;28672;00065760;TPVOL;---;---;29360640;512;58721280;xp
dev=/dev/rdisk/disk21;47:e5;OPEN-V;40960;00065760;TPVOL;---;---;41943360;512;83886720;xp
dev=/dev/rdisk/disk39;47:e6;OPEN-V;40960;00065760;TPVOL;---;---;41943360;512;83886720;xp
dev=/dev/rdisk/disk63;47:e7;OPEN-V;1024;00065760;TPVOL;---;---;1049280;512;2098560;xp
dev=/dev/rdisk/disk60;47:e8;OPEN-V;46080;00065760;TPVOL;---;LVM;47185920;512;94371840;xp
dev=/dev/rdisk/disk23;47:e9;OPEN-V;46080;00065760;TPVOL;---;LVM;47185920;512;94371840;xp
dev=/dev/rdisk/disk17;47:ea;OPEN-V;20480;00065760;TPVOL;---;LVM;20972160;512;41944320;xp
dev=/dev/rdisk/disk38;47:eb;OPEN-V;20480;00065760;TPVOL;---;LVM;20972160;512;41944320;xp
dev=/dev/rdisk/disk18;47:ec;OPEN-V;51200;00065760;TPVOL;---;LVM;52429440;512;104858880;xp
dev=/dev/rdisk/disk25;47:ed;OPEN-V;51200;00065760;TPVOL;---;LVM;52429440;512;104858880;xp
dev=/dev/rdisk/disk36;47:ee;OPEN-V;8192;00065760;TPVOL;---;LVM;8389440;512;16778880;xp
dev=/dev/rdisk/disk54;47:ef;OPEN-V;8192;00065760;TPVOL;---;LVM;8389440;512;16778880;xp
dev=/dev/rdisk/disk55;47:f0;OPEN-V;192512;00065760;TPVOL;---;LVM;197133120;512;394266240;xp
dev=/dev/rdisk/disk32;47:f1;OPEN-V;192512;00065760;TPVOL;---;LVM;197133120;512;394266240;xp
dev=/dev/rdisk/disk8;47:f2;OPEN-V;192512;00065760;TPVOL;---;LVM;197133120;512;394266240;xp
dev=/dev/rdisk/disk48;47:f3;OPEN-V;192512;00065760;TPVOL;---;LVM;197133120;512;394266240;xp
dev=/dev/rdisk/disk33;47:f4;OPEN-V;192512;00065760;TPVOL;---;LVM;197133120;512;394266240;xp
dev=/dev/rdisk/disk28;47:f5;OPEN-V;192512;00065760;TPVOL;---;LVM;197133120;512;394266240;xp
dev=/dev/rdisk/disk45;47:f6;OPEN-V;192512;00065760;TPVOL;---;LVM;197133120;512;394266240;xp
dev=/dev/rdisk/disk69;47:f7;OPEN-V;192512;00065760;TPVOL;---;LVM;197133120;512;394266240;xp
dev=/dev/rdisk/disk56;47:f8;OPEN-V;192512;00065760;TPVOL;---;LVM;197133120;512;394266240;xp
dev=/dev/rdisk/disk51;47:f9;OPEN-V;192512;00065760;TPVOL;---;LVM;197133120;512;394266240;xp
dev=/dev/rdisk/disk10;47:fa;OPEN-V;192512;00065760;TPVOL;---;LVM;197133120;512;394266240;xp
dev=/dev/rdisk/disk74;47:fb;OPEN-V;192512;00065760;TPVOL;---;LVM;197133120;512;394266240;xp
dev=/dev/rdisk/disk47;47:fc;OPEN-V;192512;00065760;TPVOL;---;LVM;197133120;512;394266240;xp
dev=/dev/rdisk/disk62;47:fd;OPEN-V;192512;00065760;TPVOL;---;LVM;197133120;512;394266240;xp
dev=/dev/rdisk/disk59;47:fe;OPEN-V;192512;00065760;TPVOL;---;LVM;197133120;512;394266240;xp
dev=/dev/rdisk/disk67;47:ff;OPEN-V;192512;00065760;TPVOL;---;LVM;197133120;512;394266240;xp
dev=/dev/rdisk/disk73;48:00;OPEN-V;6144;00065760;TPVOL;---;LVM;6291840;512;12583680;xp
dev=/dev/rdisk/disk43;48:01;OPEN-V;6144;00065760;TPVOL;---;LVM;6291840;512;12583680;xp
dev=/dev/rdisk/disk14;48:02;OPEN-V;4096;00065760;TPVOL;---;LVM;4195200;512;8390400;xp
dev=/dev/rdisk/disk66;48:03;OPEN-V;4096;00065760;TPVOL;---;LVM;4195200;512;8390400;xp
dev=/dev/rdisk/disk29;48:04;OPEN-V;51200;00065760;TPVOL;---;LVM;52429440;512;104858880;xp
dev=/dev/rdisk/disk58;48:05;OPEN-V;51200;00065760;TPVOL;---;LVM;52429440;512;104858880;xp
dev=/dev/rdisk/disk49;48:06;OPEN-V;51200;00065760;TPVOL;---;LVM;52429440;512;104858880;xp
dev=/dev/rdisk/disk50;48:07;OPEN-V;51200;00065760;TPVOL;---;LVM;52429440;512;104858880;xp
dev=/dev/rdisk/disk61;48:08;OPEN-V;5120;00065760;TPVOL;---;LVM;5243520;512;10487040;xp
dev=/dev/rdisk/disk26;48:09;OPEN-V;5120;00065760;TPVOL;---;LVM;5243520;512;10487040;xp
dev=/dev/rdisk/disk40;48:0a;OPEN-V;6144;00065760;TPVOL;---;LVM;6291840;512;12583680;xp
dev=/dev/rdisk/disk64;48:0b;OPEN-V;6144;00065760;TPVOL;---;LVM;6291840;512;12583680;xp
dev=/dev/rdisk/disk27;48:0c;OPEN-V;10240;00065760;TPVOL;---;LVM;10486080;512;20972160;xp
dev=/dev/rdisk/disk65;48:0d;OPEN-V;10240;00065760;TPVOL;---;LVM;10486080;512;20972160;xp
dev=/dev/rdisk/disk52;48:0e;OPEN-V;22528;00065760;TPVOL;---;LVM;23068800;512;46137600;xp
dev=/dev/rdisk/disk72;48:0f;OPEN-V;22528;00065760;TPVOL;---;LVM;23068800;512;46137600;xp
dev=/dev/rdisk/disk70;48:10;OPEN-V;28672;00065760;TPVOL;---;LVM;29360640;512;58721280;xp
dev=/dev/rdisk/disk57;48:11;OPEN-V;28672;00065760;TPVOL;---;LVM;29360640;512;58721280;xp
dev=/dev/rdisk/disk37;48:12;OPEN-V;40960;00065760;TPVOL;---;LVM;41943360;512;83886720;xp
dev=/dev/rdisk/disk71;48:13;OPEN-V;40960;00065760;TPVOL;---;LVM;41943360;512;83886720;xp
# Syntax:
# pv=/dev/disk/disk10;vg_name;io_timeout;autoswitch;load_bal_policy;queue_depth
pv=/dev/disk/disk60;/dev/vg_RJ1;default;On;least_cmd_load;16
pv=/dev/disk/disk23;/dev/vg_RJ1;default;On;least_cmd_load;16
pv=/dev/disk/disk17;/dev/vg_RJ1;default;On;least_cmd_load;16
pv=/dev/disk/disk38;/dev/vg_RJ1;default;On;least_cmd_load;16
pv=/dev/disk/disk18;/dev/vg_RJ1;default;On;least_cmd_load;16
pv=/dev/disk/disk25;/dev/vg_RJ1;default;On;least_cmd_load;16
pv=/dev/disk/disk36;/dev/vg_RJ1;default;On;least_cmd_load;16
pv=/dev/disk/disk54;/dev/vg_RJ1;default;On;least_cmd_load;16
pv=/dev/disk/disk55;/dev/vg_RJ1;default;On;least_cmd_load;16
pv=/dev/disk/disk32;/dev/vg_RJ1;default;On;least_cmd_load;16
pv=/dev/disk/disk8;/dev/vg_RJ1;default;On;least_cmd_load;16
pv=/dev/disk/disk48;/dev/vg_RJ1;default;On;least_cmd_load;16
pv=/dev/disk/disk33;/dev/vg_RJ1;default;On;least_cmd_load;16
pv=/dev/disk/disk28;/dev/vg_RJ1;default;On;least_cmd_load;16
pv=/dev/disk/disk45;/dev/vg_RJ1;default;On;least_cmd_load;16
pv=/dev/disk/disk69;/dev/vg_RJ1;default;On;least_cmd_load;16
pv=/dev/disk/disk56;/dev/vg_RJ1;default;On;least_cmd_load;16
pv=/dev/disk/disk51;/dev/vg_RJ1;default;On;least_cmd_load;16
pv=/dev/disk/disk10;/dev/vg_RJ1;default;On;least_cmd_load;16
pv=/dev/disk/disk74;/dev/vg_RJ1;default;On;least_cmd_load;16
pv=/dev/disk/disk47;/dev/vg_RJ1;default;On;least_cmd_load;16
pv=/dev/disk/disk62;/dev/vg_RJ1;default;On;least_cmd_load;16
pv=/dev/disk/disk59;/dev/vg_RJ1;default;On;least_cmd_load;16
pv=/dev/disk/disk67;/dev/vg_RJ1;default;On;least_cmd_load;16
pv=/dev/disk/disk73;/dev/vg_ZR1;default;On;least_cmd_load;16
pv=/dev/disk/disk43;/dev/vg_ZR1;default;On;least_cmd_load;16
pv=/dev/disk/disk14;/dev/vg_RJ7;default;On;least_cmd_load;16
pv=/dev/disk/disk66;/dev/vg_RJ7;default;On;least_cmd_load;16
pv=/dev/disk/disk29;/dev/vg_RJ7;default;On;least_cmd_load;16
pv=/dev/disk/disk58;/dev/vg_RJ7;default;On;least_cmd_load;16
pv=/dev/disk/disk49;/dev/vg_RJ7;default;On;least_cmd_load;16
pv=/dev/disk/disk50;/dev/vg_RJ7;default;On;least_cmd_load;16
pv=/dev/disk/disk61;/dev/vg_RJ7;default;On;least_cmd_load;16
pv=/dev/disk/disk26;/dev/vg_RJ7;default;On;least_cmd_load;16
pv=/dev/disk/disk40;/dev/vg_RJ7;default;On;least_cmd_load;16
pv=/dev/disk/disk64;/dev/vg_RJ7;default;On;least_cmd_load;16
pv=/dev/disk/disk27;/dev/vg_RJ7;default;On;least_cmd_load;16
pv=/dev/disk/disk65;/dev/vg_RJ7;default;On;least_cmd_load;16
pv=/dev/disk/disk52;/dev/vg_sap;default;On;least_cmd_load;16
pv=/dev/disk/disk72;/dev/vg_sap;default;On;least_cmd_load;16
pv=/dev/disk/disk70;/dev/vg_oracle;default;On;least_cmd_load;16
pv=/dev/disk/disk57;/dev/vg_oracle;default;On;least_cmd_load;16
pv=/dev/disk/disk37;/dev/vg_openv;default;On;least_cmd_load;16
pv=/dev/disk/disk71;/dev/vg_openv;default;On;least_cmd_load;16
# Syntax:
# vg=/dev/vg_name;VGmajornr;VGminornr;max_lv;pe_size;max_pv;max_pe;PVG:[name];/dev/disk/disk1;PVG:[name];/dev/disk/disk2
vg=/dev/vg_RJ1;64;0x010000;255;32;255;8000;PVG:PVG001;/dev/disk/disk8;PVG:PVG001;/dev/disk/disk10;PVG:PVG001;/dev/disk/disk28;PVG:PVG001;/dev/disk/disk32;PVG:PVG002;/dev/disk/disk33;PVG:PVG002;/dev/disk/disk45;PVG:PVG002;/dev/disk/disk47;PVG:PVG002;/dev/disk/disk48;PVG:PVG003;/dev/disk/disk51;PVG:PVG003;/dev/disk/disk55;PVG:PVG003;/dev/disk/disk56;PVG:PVG003;/dev/disk/disk59;PVG:PVG004;/dev/disk/disk62;PVG:PVG004;/dev/disk/disk67;PVG:PVG004;/dev/disk/disk69;PVG:PVG004;/dev/disk/disk74;PVG:;/dev/disk/disk36;PVG:;/dev/disk/disk54;PVG:;/dev/disk/disk18;PVG:;/dev/disk/disk25;PVG:;/dev/disk/disk23;PVG:;/dev/disk/disk17;PVG:;/dev/disk/disk38;PVG:;/dev/disk/disk60
vg=/dev/vg_ZR1;64;0x020000;255;32;255;8000;PVG:;/dev/disk/disk43;PVG:;/dev/disk/disk73
vg=/dev/vg_RJ7;64;0x030000;255;32;255;8000;PVG:PVG001;/dev/disk/disk29;PVG:PVG001;/dev/disk/disk49;PVG:PVG001;/dev/disk/disk50;PVG:PVG001;/dev/disk/disk58;PVG:;/dev/disk/disk14;PVG:;/dev/disk/disk66;PVG:;/dev/disk/disk26;PVG:;/dev/disk/disk27;PVG:;/dev/disk/disk40;PVG:;/dev/disk/disk61;PVG:;/dev/disk/disk64;PVG:;/dev/disk/disk65
vg=/dev/vg_sap;64;0x040000;255;32;255;8000;PVG:;/dev/disk/disk52;PVG:;/dev/disk/disk72
vg=/dev/vg_oracle;64;0x050000;255;32;255;8000;PVG:;/dev/disk/disk57;PVG:;/dev/disk/disk70
vg=/dev/vg_openv;64;0x060000;255;32;255;8000;PVG:;/dev/disk/disk37;PVG:;/dev/disk/disk71
# Syntax:
# lv=/dev/vg_name/lvol1;mirror_cp;lv_size;le_size;stripes;stripe_size;bad_block;allocation;[pvg_name]
lv=/dev/vg_RJ1/lv_oracleRJ1_sapdata1;0;768000;24000;0;0;on;PVG-strict,distributed;PVG001
lv=/dev/vg_RJ1/lv_oracleRJ1_sapdata2;0;768000;24000;0;0;on;PVG-strict,distributed;PVG002
lv=/dev/vg_RJ1/lv_oracleRJ1_sapdata3;0;768000;24000;0;0;on;PVG-strict,distributed;PVG003
lv=/dev/vg_RJ1/lv_oracleRJ1_sapdata4;0;768000;24000;0;0;on;PVG-strict,distributed;PVG004
lv=/dev/vg_RJ1/lv_oracleRJ1_origlogB;0;4000;125;0;0;on;strict;
lv=/dev/vg_RJ1/lv_oracleRJ1_origlogA;0;4000;125;0;0;on;strict;
lv=/dev/vg_RJ1/lv_oracleRJ1_oraarch;0;101376;3168;0;0;on;strict;
lv=/dev/vg_RJ1/lv_oracleRJ1_mirrlogB;0;4000;125;0;0;on;strict;
lv=/dev/vg_RJ1/lv_oracleRJ1_mirrlogA;0;4000;125;0;0;on;strict;
lv=/dev/vg_RJ1/lv_exportsapmnt_RJ1;0;19456;608;0;0;on;strict;
lv=/dev/vg_RJ1/lv_usrsapRJ1_DVEBMGS19;0;19456;608;0;0;on;strict;
lv=/dev/vg_RJ1/lv_exportoracleRJ1_sapbackup;0;19456;608;0;0;on;strict;
lv=/dev/vg_RJ1/lv_usrsapRJ1_ASCS05;0;10016;313;0;0;on;strict;
lv=/dev/vg_RJ1/lv_oracle_RJ1;0;20000;625;0;0;on;strict;
lv=/dev/vg_RJ1/lv_oracleRJ1_112_64;0;20000;625;0;0;on;strict;
lv=/dev/vg_RJ1/lv_oracleRJ1_sapreorg;0;20000;625;0;0;on;strict;
lv=/dev/vg_ZR1/lv_sapmnt_ZR1;0;8192;256;0;0;on;strict;
lv=/dev/vg_ZR1/lv_usrsap_ZR1;0;4000;125;0;0;on;strict;
lv=/dev/vg_RJ7/lv_oracleRJ7_sapdata1;0;101376;3168;0;0;on;PVG-strict,distributed;PVG001
lv=/dev/vg_RJ7/lv_oracleRJ7_sapdata2;0;101376;3168;0;0;on;PVG-strict,distributed;PVG001
lv=/dev/vg_RJ7/lv_oracleRJ7_origlogA;0;2048;64;0;0;on;strict;
lv=/dev/vg_RJ7/lv_oracleRJ7_origlogB;0;2016;63;0;0;on;strict;
lv=/dev/vg_RJ7/lv_oracleRJ7_mirrlogA;0;2016;63;0;0;on;strict;
lv=/dev/vg_RJ7/lv_oracleRJ7_mirrlogB;0;2016;63;0;0;on;strict;
lv=/dev/vg_RJ7/lv_oracleRJ7_102_64;0;10016;313;0;0;on;strict;
lv=/dev/vg_RJ7/lv_oracleRJ7_oraarch;0;10016;313;0;0;on;strict;
lv=/dev/vg_RJ7/lv_oracleRJ7_sapbackup;0;10016;313;0;0;on;strict;
lv=/dev/vg_RJ7/lv_oracleRJ7_saparch;0;10016;313;0;0;on;strict;
lv=/dev/vg_RJ7/lv_oracleRJ7_RJ7;0;2048;64;0;0;on;strict;
lv=/dev/vg_sap/lv_usr_sap;0;10016;313;0;0;on;strict;
lv=/dev/vg_sap/lv_usrsap_SMD;0;2048;64;0;0;on;strict;
lv=/dev/vg_sap/lv_usrsapRJ1_ERS05;0;10016;313;0;0;on;strict;
lv=/dev/vg_sap/lv_usrsapRJ6_ERS25;0;10016;313;0;0;on;strict;
lv=/dev/vg_sap/lv_usrsapSMD_J97;0;4000;125;0;0;on;strict;
lv=/dev/vg_sap/lv_usrsapSMD_J98;0;4000;125;0;0;on;strict;
lv=/dev/vg_sap/lv_sapmnt;0;4000;125;0;0;on;strict;
lv=/dev/vg_oracle/lv_oracle;0;20000;625;0;0;on;strict;
lv=/dev/vg_oracle/lv_oracle_stage;0;30016;938;0;0;on;strict;
lv=/dev/vg_oracle/lv_oracle_client;0;5024;157;0;0;on;strict;
lv=/dev/vg_openv/lv_usr_openv;0;20000;625;0;0;on;strict;
lv=/dev/vg_openv/lv_usropenvnetbackup_logs;0;20000;625;0;0;on;strict;
lv=/dev/vg_openv/lv_usropenv_logs;0;20000;625;0;0;on;strict;
lv=/dev/vg_openv/lv_usropenv_patches;0;20000;625;0;0;on;strict;
# Syntax:
# fs=mount_point;lvname;fstype;mount_options;bsize;owner;group;perm_mode;mounted_by
fs=/oracle/RJ1/sapdata1;/dev/vg_RJ1/lv_oracleRJ1_sapdata1;vxfs;largefiles,delaylog,nodatainlog;8192;root;root;755;fstab
fs=/oracle/RJ1/sapdata2;/dev/vg_RJ1/lv_oracleRJ1_sapdata2;vxfs;largefiles,delaylog,nodatainlog;8192;root;root;755;fstab
fs=/oracle/RJ1/sapdata3;/dev/vg_RJ1/lv_oracleRJ1_sapdata3;vxfs;largefiles,delaylog,nodatainlog;8192;root;root;755;fstab
fs=/oracle/RJ1/sapdata4;/dev/vg_RJ1/lv_oracleRJ1_sapdata4;vxfs;largefiles,delaylog,nodatainlog;8192;root;root;755;fstab
fs=/oracle/RJ1/origlogB;/dev/vg_RJ1/lv_oracleRJ1_origlogB;vxfs;largefiles,mincache=direct,delaylog,nodatainlog,convosync=direct;8192;root;root;755;fstab
fs=/oracle/RJ1/origlogA;/dev/vg_RJ1/lv_oracleRJ1_origlogA;vxfs;largefiles,mincache=direct,delaylog,nodatainlog,convosync=direct;8192;root;root;755;fstab
fs=/oracle/RJ1/oraarch;/dev/vg_RJ1/lv_oracleRJ1_oraarch;vxfs;largefiles,delaylog,nodatainlog;8192;root;root;755;fstab
fs=/oracle/RJ1/mirrlogB;/dev/vg_RJ1/lv_oracleRJ1_mirrlogB;vxfs;largefiles,mincache=direct,delaylog,nodatainlog,convosync=direct;8192;root;root;755;fstab
fs=/oracle/RJ1/mirrlogA;/dev/vg_RJ1/lv_oracleRJ1_mirrlogA;vxfs;largefiles,mincache=direct,delaylog,nodatainlog,convosync=direct;8192;root;root;755;fstab
fs=/export/sapmnt/RJ1;/dev/vg_RJ1/lv_exportsapmnt_RJ1;vxfs;nolargefiles;8192;root;sys;755;fstab
fs=/usr/sap/RJ1/DVEBMGS19;/dev/vg_RJ1/lv_usrsapRJ1_DVEBMGS19;vxfs;largefiles,delaylog,nodatainlog;8192;root;root;755;fstab
fs=/export/oracle/RJ1/sapbackup;/dev/vg_RJ1/lv_exportoracleRJ1_sapbackup;vxfs;nolargefiles;8192;root;sys;755;fstab
fs=/usr/sap/RJ1/ASCS05;/dev/vg_RJ1/lv_usrsapRJ1_ASCS05;vxfs;largefiles,delaylog,nodatainlog;8192;root;root;755;fstab
fs=/oracle/RJ1;/dev/vg_RJ1/lv_oracle_RJ1;vxfs;largefiles,delaylog,nodatainlog;8192;root;root;755;fstab
fs=/oracle/RJ1/112_64;/dev/vg_RJ1/lv_oracleRJ1_112_64;vxfs;largefiles,delaylog,nodatainlog;8192;root;root;755;fstab
fs=/oracle/RJ1/sapreorg;/dev/vg_RJ1/lv_oracleRJ1_sapreorg;vxfs;largefiles,delaylog,nodatainlog;8192;root;root;755;fstab
fs=/sapmnt/ZR1;/dev/vg_ZR1/lv_sapmnt_ZR1;vxfs;largefiles,delaylog,nodatainlog;8192;root;root;755;fstab
fs=/usr/sap/ZR1;/dev/vg_ZR1/lv_usrsap_ZR1;vxfs;largefiles,delaylog,nodatainlog;8192;root;root;755;fstab
fs=/oracle/RJ7/sapdata1;/dev/vg_RJ7/lv_oracleRJ7_sapdata1;vxfs;largefiles,delaylog,nodatainlog;8192;root;root;755;fstab
fs=/oracle/RJ7/sapdata2;/dev/vg_RJ7/lv_oracleRJ7_sapdata2;vxfs;largefiles,delaylog,nodatainlog;8192;root;root;755;fstab
fs=/oracle/RJ7/origlogA;/dev/vg_RJ7/lv_oracleRJ7_origlogA;vxfs;largefiles,mincache=direct,delaylog,nodatainlog,convosync=direct;8192;root;root;755;fstab
fs=/oracle/RJ7/origlogB;/dev/vg_RJ7/lv_oracleRJ7_origlogB;vxfs;largefiles,mincache=direct,delaylog,nodatainlog,convosync=direct;8192;root;root;755;fstab
fs=/oracle/RJ7/mirrlogA;/dev/vg_RJ7/lv_oracleRJ7_mirrlogA;vxfs;largefiles,mincache=direct,delaylog,nodatainlog,convosync=direct;8192;root;root;755;fstab
fs=/oracle/RJ7/mirrlogB;/dev/vg_RJ7/lv_oracleRJ7_mirrlogB;vxfs;largefiles,mincache=direct,delaylog,nodatainlog,convosync=direct;8192;root;root;755;fstab
fs=/oracle/RJ7/102_64;/dev/vg_RJ7/lv_oracleRJ7_102_64;vxfs;largefiles,delaylog,nodatainlog;8192;root;root;755;fstab
fs=/oracle/RJ7/oraarch;/dev/vg_RJ7/lv_oracleRJ7_oraarch;vxfs;largefiles,delaylog,nodatainlog;8192;root;root;755;fstab
fs=/oracle/RJ7/sapbackup;/dev/vg_RJ7/lv_oracleRJ7_sapbackup;vxfs;largefiles,delaylog,nodatainlog;8192;root;root;755;fstab
fs=/oracle/RJ7/saparch;/dev/vg_RJ7/lv_oracleRJ7_saparch;vxfs;largefiles,delaylog,nodatainlog;8192;root;root;755;fstab
fs=/oracle/RJ7;/dev/vg_RJ7/lv_oracleRJ7_RJ7;vxfs;largefiles,delaylog,nodatainlog;8192;root;root;755;fstab
fs=/usr/sap;/dev/vg_sap/lv_usr_sap;vxfs;largefiles,delaylog,nodatainlog;8192;root;root;755;fstab
fs=/usr/sap/SMD;/dev/vg_sap/lv_usrsap_SMD;vxfs;largefiles,delaylog,nodatainlog;8192;root;root;755;fstab
fs=/usr/sap/RJ1/ERS05;/dev/vg_sap/lv_usrsapRJ1_ERS05;vxfs;largefiles,delaylog,nodatainlog;8192;root;root;755;fstab
fs=/usr/sap/RJ6/ERS25;/dev/vg_sap/lv_usrsapRJ6_ERS25;vxfs;largefiles,delaylog,nodatainlog;8192;root;root;755;fstab
fs=/usr/sap/SMD/J97;/dev/vg_sap/lv_usrsapSMD_J97;vxfs;largefiles,delaylog,nodatainlog;8192;root;root;755;fstab
fs=/usr/sap/SMD/J98;/dev/vg_sap/lv_usrsapSMD_J98;vxfs;largefiles,delaylog,nodatainlog;8192;root;root;755;fstab
fs=/sapmnt;/dev/vg_sap/lv_sapmnt;vxfs;largefiles,delaylog,nodatainlog;8192;root;root;755;fstab
fs=/oracle;/dev/vg_oracle/lv_oracle;vxfs;largefiles,delaylog;8192;root;root;755;fstab
fs=/oracle/stage;/dev/vg_oracle/lv_oracle_stage;vxfs;largefiles,delaylog,nodatainlog;8192;root;root;755;fstab
fs=/oracle/client;/dev/vg_oracle/lv_oracle_client;vxfs;largefiles,delaylog,nodatainlog;8192;root;root;755;fstab
fs=/usr/openv;/dev/vg_openv/lv_usr_openv;vxfs;largefiles,delaylog,nodatainlog;8192;root;root;755;fstab
fs=/usr/openv/netbackup/logs;/dev/vg_openv/lv_usropenvnetbackup_logs;vxfs;largefiles,mincache=direct,delaylog,nodatainlog,convosync=direct;8192;root;root;755;fstab
fs=/usr/openv/logs;/dev/vg_openv/lv_usropenv_logs;vxfs;largefiles,mincache=direct,delaylog,nodatainlog,convosync=direct;8192;root;root;755;fstab
fs=/usr/openv/patches;/dev/vg_openv/lv_usropenv_patches;vxfs;largefiles,delaylog,nodatainlog;8192;root;root;755;fstab
----

We can break it down into the following sections:

----
#-> grep "^#" /tmp/SAN_layout_of_itshrr01.conf
# SAN layout configuration file of system itshrr01
# created on 2012-Aug-14
#
# Syntax:
# san=[single|multiple] [xp|eva|...]
# Syntax:
# dev=/dev/rdisk/disk1;CU-ldev;type;sizeMB;SerialNr;RaidLevel;RaidGrp;VolMgr;sizeKB;bytes-per-sector;blocks-per-disk,santype
# Syntax:
# pv=/dev/disk/disk10;vg_name;io_timeout;autoswitch;load_bal_policy;queue_depth
# Syntax:
# vg=/dev/vg_name;VGmajornr;VGminornr;max_lv;pe_size;max_pv;max_pe;PVG:[name];/dev/disk/disk1;PVG:[name];/dev/disk/disk2
# Syntax:
# lv=/dev/vg_name/lvol1;mirror_cp;lv_size;le_size;stripes;stripe_size;bad_block;allocation;[pvg_name]
# Syntax:
# fs=mount_point;lvname;fstype;mount_options;bsize;owner;group;perm_mode;mounted_by
----

The *san=* keyword describes if there is one or more SAN involved (_single_ or _multiple_) and which types of SAN storage is connected (_xp_, _eva_, _emc_, and so on). For the moment only _xp_ is supported.

The *dev=* keyword describes the raw physical devices as explored by the +xpinfo+ tool (for _xp_ storage of course). The size in Kb is gathered via the +diskinfo+ tool and this field is used to find equal sized disks afterwards.

The *pv=* keyword describes the physical volumes in use by one or more volume groups. Please note that also the autoswitch value, load balancy policy and queue depth are saved as a reference (at recreation time we will adapt each disk with the same values).

The *vg=* keyword describes all characteristics of a volume group with all possible options, including the physical volume group (PVG) names defined to certain disks.

The *lv=* keyword describes all information of a logical volume group, also including PVGs if any. 

The *fs=* keyword describes everything that is important of a certain file system. The mount options are a very important part of this. Furthermore, the last word is _fstab_ meaning mounted by a fstab entry or _sg_ mounted by a Serviceguard package.

The SAN Configuration layout file (+/tmp/SAN_layout_of_itshrr01.conf+) must be kept at a safe place as this will be used as input to recreate (or compare with the new SAN situation) the whole SAN layout at a later stage.

== The create SAN layout script

The create SAN layout script, +create_san_layout_script.sh+, can and should be run after connecting a new SAN storage box. However, it can be run any time, but then it will use the same SAN storage box to propose disks to use of same size. Again, an example is so much easier to catch the purpose of this script.

In short, it will try to find corresponding disks of equal size (and of the same SAN type of course) and if this is succesfully a +diskmap+ file is created. The +diskmap+ file can be edited and if you say _yes_ to that question you will be thrown into a shell. After inspecting or modifying the +diskmap+ file just type *exit* to go beack to the +create_san_layout_script.sh+ script and continue.

Secondly, if the script notices that there are still  non-vg00 volume groups active it will propose to add code to the destination script (called +make_SAN_layout_of_itshrr01.sh+) to vgexport these volume groups (if you respond _no_ to this question then the script will halt and you have to do it manually, in any case vgexport must be done before removing the old SAN to avoid big issues at reboot time with the new SAN storage).

----
#-> ./create_san_layout_script.sh
###############################################################################################
  Installation Script: create_san_layout_script.sh
              Purpose: Create the SAN creation script (make_SAN_layout_of_itshrr01.sh)
           OS Release: 11.31
                Model: ia64
    Installation Host: itshrr01
    Installation User: root
    Installation Date: 2012-08-14 @ 07:41:43
     Installation Log: /var/adm/install-logs/create_san_layout_script.scriptlog
###############################################################################################
 ** Running on HP-UX 11.31
 ** Created temporary directory /tmp/san027235
 ** Force an ioscan and search for new disks
Progress: *
Total wait time: 3 second(s)

 ** Reinstalling special files for disks only
 ** Saving ioscan output of disks as /tmp/san027235/ioscan.out
Progress: *
Total wait time: 3 second(s)

 ** Saving xpinfo output as /tmp/san027235/xpinfo.out
Progress: ***
Total wait time: 9 second(s)

 ** Building the free disks list (made from xpinfo.out file)
 ** Analyzing disk /dev/rdisk/disk24
 ** Analyzing disk /dev/rdisk/disk35
 ** Analyzing disk /dev/rdisk/disk7
 ** Analyzing disk /dev/rdisk/disk6
 ** Analyzing disk /dev/rdisk/disk9
 ** Analyzing disk /dev/rdisk/disk12
 ** Analyzing disk /dev/rdisk/disk15
 ** Analyzing disk /dev/rdisk/disk34
 ** Analyzing disk /dev/rdisk/disk31
 ** Analyzing disk /dev/rdisk/disk42
 ** Analyzing disk /dev/rdisk/disk11
 ** Analyzing disk /dev/rdisk/disk22
 ** Analyzing disk /dev/rdisk/disk16
 ** Analyzing disk /dev/rdisk/disk13
 ** Analyzing disk /dev/rdisk/disk46
 ** Analyzing disk /dev/rdisk/disk20
 ** Analyzing disk /dev/rdisk/disk44
 ** Analyzing disk /dev/rdisk/disk53
 ** Analyzing disk /dev/rdisk/disk19
 ** Analyzing disk /dev/rdisk/disk30
 ** Analyzing disk /dev/rdisk/disk68
 ** Analyzing disk /dev/rdisk/disk41
 ** Analyzing disk /dev/rdisk/disk21
 ** Analyzing disk /dev/rdisk/disk39
 ** Analyzing disk /dev/rdisk/disk63
 ** Analyzing disk /dev/rdisk/disk60
 ** Analyzing disk /dev/rdisk/disk23
 ** Analyzing disk /dev/rdisk/disk17
 ** Analyzing disk /dev/rdisk/disk38
 ** Analyzing disk /dev/rdisk/disk18
 ** Analyzing disk /dev/rdisk/disk25
 ** Analyzing disk /dev/rdisk/disk36
 ** Analyzing disk /dev/rdisk/disk54
 ** Analyzing disk /dev/rdisk/disk55
 ** Analyzing disk /dev/rdisk/disk32
 ** Analyzing disk /dev/rdisk/disk8
 ** Analyzing disk /dev/rdisk/disk48
 ** Analyzing disk /dev/rdisk/disk33
 ** Analyzing disk /dev/rdisk/disk28
 ** Analyzing disk /dev/rdisk/disk45
 ** Analyzing disk /dev/rdisk/disk69
 ** Analyzing disk /dev/rdisk/disk56
 ** Analyzing disk /dev/rdisk/disk51
 ** Analyzing disk /dev/rdisk/disk10
 ** Analyzing disk /dev/rdisk/disk74
 ** Analyzing disk /dev/rdisk/disk47
 ** Analyzing disk /dev/rdisk/disk62
 ** Analyzing disk /dev/rdisk/disk59
 ** Analyzing disk /dev/rdisk/disk67
 ** Analyzing disk /dev/rdisk/disk73
 ** Analyzing disk /dev/rdisk/disk43
 ** Analyzing disk /dev/rdisk/disk14
 ** Analyzing disk /dev/rdisk/disk66
 ** Analyzing disk /dev/rdisk/disk29
 ** Analyzing disk /dev/rdisk/disk58
 ** Analyzing disk /dev/rdisk/disk49
 ** Analyzing disk /dev/rdisk/disk50
 ** Analyzing disk /dev/rdisk/disk61
 ** Analyzing disk /dev/rdisk/disk26
 ** Analyzing disk /dev/rdisk/disk40
 ** Analyzing disk /dev/rdisk/disk64
 ** Analyzing disk /dev/rdisk/disk27
 ** Analyzing disk /dev/rdisk/disk65
 ** Analyzing disk /dev/rdisk/disk52
 ** Analyzing disk /dev/rdisk/disk72
 ** Analyzing disk /dev/rdisk/disk70
 ** Analyzing disk /dev/rdisk/disk57
 ** Analyzing disk /dev/rdisk/disk37
 ** Analyzing disk /dev/rdisk/disk71
 ** Creating disk mapping file /tmp/san027235/diskmap
 ** Successfully created the disk mapping file /tmp/san027235/diskmap
Do you want to edit /tmp/san027235/diskmap Y/n ? n
 *** WARN: There are still non-vg00 Volume Groups active:
/dev/vg_RJ1
/dev/vg_ZR1
/dev/vg_RJ7
/dev/vg_sap
/dev/vg_oracle
/dev/vg_openv
Shall we add vgexport command(s) to make_SAN_layout_of_itshrr01.sh y/N ? y
 ** ######## /dev/vg_RJ1 #########
 ** Adding vgcreate line (vgcreate -l 255 -s 32 -p 255 -e 8000 -g PVG001 /dev/vg_RJ1 /dev/disk/disk67)
 ** Adding vgextend line (vgextend -g PVG001 /dev/vg_RJ1 /dev/disk/disk55)
 ** Adding vgextend line (vgextend -g PVG001 /dev/vg_RJ1 /dev/disk/disk32)
 ** Adding vgextend line (vgextend -g PVG001 /dev/vg_RJ1 /dev/disk/disk8)
 ** Adding vgextend line (vgextend -g PVG002 /dev/vg_RJ1 /dev/disk/disk48)
 ** Adding vgextend line (vgextend -g PVG002 /dev/vg_RJ1 /dev/disk/disk33)
 ** Adding vgextend line (vgextend -g PVG002 /dev/vg_RJ1 /dev/disk/disk28)
 ** Adding vgextend line (vgextend -g PVG002 /dev/vg_RJ1 /dev/disk/disk45)
 ** Adding vgextend line (vgextend -g PVG003 /dev/vg_RJ1 /dev/disk/disk69)
 ** Adding vgextend line (vgextend -g PVG003 /dev/vg_RJ1 /dev/disk/disk56)
 ** Adding vgextend line (vgextend -g PVG003 /dev/vg_RJ1 /dev/disk/disk51)
 ** Adding vgextend line (vgextend -g PVG003 /dev/vg_RJ1 /dev/disk/disk10)
 ** Adding vgextend line (vgextend -g PVG004 /dev/vg_RJ1 /dev/disk/disk74)
 ** Adding vgextend line (vgextend -g PVG004 /dev/vg_RJ1 /dev/disk/disk47)
 ** Adding vgextend line (vgextend -g PVG004 /dev/vg_RJ1 /dev/disk/disk62)
 ** Adding vgextend line (vgextend -g PVG004 /dev/vg_RJ1 /dev/disk/disk59)
 ** Adding vgextend line (vgextend  /dev/vg_RJ1 /dev/disk/disk36)
 ** Adding vgextend line (vgextend  /dev/vg_RJ1 /dev/disk/disk54)
 ** Adding vgextend line (vgextend  /dev/vg_RJ1 /dev/disk/disk24)
 ** Adding vgextend line (vgextend  /dev/vg_RJ1 /dev/disk/disk20)
 ** Adding vgextend line (vgextend  /dev/vg_RJ1 /dev/disk/disk60)
 ** Adding vgextend line (vgextend  /dev/vg_RJ1 /dev/disk/disk7)
 ** Adding vgextend line (vgextend  /dev/vg_RJ1 /dev/disk/disk6)
 ** Adding vgextend line (vgextend  /dev/vg_RJ1 /dev/disk/disk23)
 ** ######## /dev/vg_ZR1 #########
 ** Adding vgcreate line (vgcreate -l 255 -s 32 -p 255 -e 8000  /dev/vg_ZR1 /dev/disk/disk53)
 ** Adding vgextend line (vgextend  /dev/vg_ZR1 /dev/disk/disk64)
 ** ######## /dev/vg_RJ7 #########
 ** Adding vgcreate line (vgcreate -l 255 -s 32 -p 255 -e 8000 -g PVG001 /dev/vg_RJ7 /dev/disk/disk18)
 ** Adding vgextend line (vgextend -g PVG001 /dev/vg_RJ7 /dev/disk/disk58)
 ** Adding vgextend line (vgextend -g PVG001 /dev/vg_RJ7 /dev/disk/disk49)
 ** Adding vgextend line (vgextend -g PVG001 /dev/vg_RJ7 /dev/disk/disk50)
 ** Adding vgextend line (vgextend  /dev/vg_RJ7 /dev/disk/disk14)
 ** Adding vgextend line (vgextend  /dev/vg_RJ7 /dev/disk/disk66)
 ** Adding vgextend line (vgextend  /dev/vg_RJ7 /dev/disk/disk61)
 ** Adding vgextend line (vgextend  /dev/vg_RJ7 /dev/disk/disk27)
 ** Adding vgextend line (vgextend  /dev/vg_RJ7 /dev/disk/disk44)
 ** Adding vgextend line (vgextend  /dev/vg_RJ7 /dev/disk/disk26)
 ** Adding vgextend line (vgextend  /dev/vg_RJ7 /dev/disk/disk40)
 ** Adding vgextend line (vgextend  /dev/vg_RJ7 /dev/disk/disk65)
 ** ######## /dev/vg_sap #########
 ** Adding vgcreate line (vgcreate -l 255 -s 32 -p 255 -e 8000  /dev/vg_sap /dev/disk/disk52)
 ** Adding vgextend line (vgextend  /dev/vg_sap /dev/disk/disk72)
 ** ######## /dev/vg_oracle #########
 ** Adding vgcreate line (vgcreate -l 255 -s 32 -p 255 -e 8000  /dev/vg_oracle /dev/disk/disk41)
 ** Adding vgextend line (vgextend  /dev/vg_oracle /dev/disk/disk57)
 ** ######## /dev/vg_openv #########
 ** Adding vgcreate line (vgcreate -l 255 -s 32 -p 255 -e 8000  /dev/vg_openv /dev/disk/disk39)
 ** Adding vgextend line (vgextend  /dev/vg_openv /dev/disk/disk71)
 ** Adding lvcreate line (lvcreate  -D y -s g -n lv_oracleRJ1_sapdata1 /dev/vg_RJ1)
 ** Adding lvextend line (lvextend -l 24000 /dev/vg_RJ1/lv_oracleRJ1_sapdata1 PVG001)
 ** Adding lvcreate line (lvcreate  -D y -s g -n lv_oracleRJ1_sapdata2 /dev/vg_RJ1)
 ** Adding lvextend line (lvextend -l 24000 /dev/vg_RJ1/lv_oracleRJ1_sapdata2 PVG002)
 ** Adding lvcreate line (lvcreate  -D y -s g -n lv_oracleRJ1_sapdata3 /dev/vg_RJ1)
 ** Adding lvextend line (lvextend -l 24000 /dev/vg_RJ1/lv_oracleRJ1_sapdata3 PVG003)
 ** Adding lvcreate line (lvcreate  -D y -s g -n lv_oracleRJ1_sapdata4 /dev/vg_RJ1)
 ** Adding lvextend line (lvextend -l 24000 /dev/vg_RJ1/lv_oracleRJ1_sapdata4 PVG004)
 ** Adding lvcreate line (lvcreate  -n lv_oracleRJ1_origlogB /dev/vg_RJ1)
 ** Adding lvextend line (lvextend -l 125 /dev/vg_RJ1/lv_oracleRJ1_origlogB )
 ** Adding lvcreate line (lvcreate  -n lv_oracleRJ1_origlogA /dev/vg_RJ1)
 ** Adding lvextend line (lvextend -l 125 /dev/vg_RJ1/lv_oracleRJ1_origlogA )
 ** Adding lvcreate line (lvcreate  -n lv_oracleRJ1_oraarch /dev/vg_RJ1)
 ** Adding lvextend line (lvextend -l 3168 /dev/vg_RJ1/lv_oracleRJ1_oraarch )
 ** Adding lvcreate line (lvcreate  -n lv_oracleRJ1_mirrlogB /dev/vg_RJ1)
 ** Adding lvextend line (lvextend -l 125 /dev/vg_RJ1/lv_oracleRJ1_mirrlogB )
 ** Adding lvcreate line (lvcreate  -n lv_oracleRJ1_mirrlogA /dev/vg_RJ1)
 ** Adding lvextend line (lvextend -l 125 /dev/vg_RJ1/lv_oracleRJ1_mirrlogA )
 ** Adding lvcreate line (lvcreate  -n lv_exportsapmnt_RJ1 /dev/vg_RJ1)
 ** Adding lvextend line (lvextend -l 608 /dev/vg_RJ1/lv_exportsapmnt_RJ1 )
 ** Adding lvcreate line (lvcreate  -n lv_usrsapRJ1_DVEBMGS19 /dev/vg_RJ1)
 ** Adding lvextend line (lvextend -l 608 /dev/vg_RJ1/lv_usrsapRJ1_DVEBMGS19 )
 ** Adding lvcreate line (lvcreate  -n lv_exportoracleRJ1_sapbackup /dev/vg_RJ1)
 ** Adding lvextend line (lvextend -l 608 /dev/vg_RJ1/lv_exportoracleRJ1_sapbackup )
 ** Adding lvcreate line (lvcreate  -n lv_usrsapRJ1_ASCS05 /dev/vg_RJ1)
 ** Adding lvextend line (lvextend -l 313 /dev/vg_RJ1/lv_usrsapRJ1_ASCS05 )
 ** Adding lvcreate line (lvcreate  -n lv_oracle_RJ1 /dev/vg_RJ1)
 ** Adding lvextend line (lvextend -l 625 /dev/vg_RJ1/lv_oracle_RJ1 )
 ** Adding lvcreate line (lvcreate  -n lv_oracleRJ1_112_64 /dev/vg_RJ1)
 ** Adding lvextend line (lvextend -l 625 /dev/vg_RJ1/lv_oracleRJ1_112_64 )
 ** Adding lvcreate line (lvcreate  -n lv_oracleRJ1_sapreorg /dev/vg_RJ1)
 ** Adding lvextend line (lvextend -l 625 /dev/vg_RJ1/lv_oracleRJ1_sapreorg )
 ** Adding lvcreate line (lvcreate  -n lv_sapmnt_ZR1 /dev/vg_ZR1)
 ** Adding lvextend line (lvextend -l 256 /dev/vg_ZR1/lv_sapmnt_ZR1 )
 ** Adding lvcreate line (lvcreate  -n lv_usrsap_ZR1 /dev/vg_ZR1)
 ** Adding lvextend line (lvextend -l 125 /dev/vg_ZR1/lv_usrsap_ZR1 )
 ** Adding lvcreate line (lvcreate  -D y -s g -n lv_oracleRJ7_sapdata1 /dev/vg_RJ7)
 ** Adding lvextend line (lvextend -l 3168 /dev/vg_RJ7/lv_oracleRJ7_sapdata1 PVG001)
 ** Adding lvcreate line (lvcreate  -D y -s g -n lv_oracleRJ7_sapdata2 /dev/vg_RJ7)
 ** Adding lvextend line (lvextend -l 3168 /dev/vg_RJ7/lv_oracleRJ7_sapdata2 PVG001)
 ** Adding lvcreate line (lvcreate  -n lv_oracleRJ7_origlogA /dev/vg_RJ7)
 ** Adding lvextend line (lvextend -l 64 /dev/vg_RJ7/lv_oracleRJ7_origlogA )
 ** Adding lvcreate line (lvcreate  -n lv_oracleRJ7_origlogB /dev/vg_RJ7)
 ** Adding lvextend line (lvextend -l 63 /dev/vg_RJ7/lv_oracleRJ7_origlogB )
 ** Adding lvcreate line (lvcreate  -n lv_oracleRJ7_mirrlogA /dev/vg_RJ7)
 ** Adding lvextend line (lvextend -l 63 /dev/vg_RJ7/lv_oracleRJ7_mirrlogA )
 ** Adding lvcreate line (lvcreate  -n lv_oracleRJ7_mirrlogB /dev/vg_RJ7)
 ** Adding lvextend line (lvextend -l 63 /dev/vg_RJ7/lv_oracleRJ7_mirrlogB )
 ** Adding lvcreate line (lvcreate  -n lv_oracleRJ7_102_64 /dev/vg_RJ7)
 ** Adding lvextend line (lvextend -l 313 /dev/vg_RJ7/lv_oracleRJ7_102_64 )
 ** Adding lvcreate line (lvcreate  -n lv_oracleRJ7_oraarch /dev/vg_RJ7)
 ** Adding lvextend line (lvextend -l 313 /dev/vg_RJ7/lv_oracleRJ7_oraarch )
 ** Adding lvcreate line (lvcreate  -n lv_oracleRJ7_sapbackup /dev/vg_RJ7)
 ** Adding lvextend line (lvextend -l 313 /dev/vg_RJ7/lv_oracleRJ7_sapbackup )
 ** Adding lvcreate line (lvcreate  -n lv_oracleRJ7_saparch /dev/vg_RJ7)
 ** Adding lvextend line (lvextend -l 313 /dev/vg_RJ7/lv_oracleRJ7_saparch )
 ** Adding lvcreate line (lvcreate  -n lv_oracleRJ7_RJ7 /dev/vg_RJ7)
 ** Adding lvextend line (lvextend -l 64 /dev/vg_RJ7/lv_oracleRJ7_RJ7 )
 ** Adding lvcreate line (lvcreate  -n lv_usr_sap /dev/vg_sap)
 ** Adding lvextend line (lvextend -l 313 /dev/vg_sap/lv_usr_sap )
 ** Adding lvcreate line (lvcreate  -n lv_usrsap_SMD /dev/vg_sap)
 ** Adding lvextend line (lvextend -l 64 /dev/vg_sap/lv_usrsap_SMD )
 ** Adding lvcreate line (lvcreate  -n lv_usrsapRJ1_ERS05 /dev/vg_sap)
 ** Adding lvextend line (lvextend -l 313 /dev/vg_sap/lv_usrsapRJ1_ERS05 )
 ** Adding lvcreate line (lvcreate  -n lv_usrsapRJ6_ERS25 /dev/vg_sap)
 ** Adding lvextend line (lvextend -l 313 /dev/vg_sap/lv_usrsapRJ6_ERS25 )
 ** Adding lvcreate line (lvcreate  -n lv_usrsapSMD_J97 /dev/vg_sap)
 ** Adding lvextend line (lvextend -l 125 /dev/vg_sap/lv_usrsapSMD_J97 )
 ** Adding lvcreate line (lvcreate  -n lv_usrsapSMD_J98 /dev/vg_sap)
 ** Adding lvextend line (lvextend -l 125 /dev/vg_sap/lv_usrsapSMD_J98 )
 ** Adding lvcreate line (lvcreate  -n lv_sapmnt /dev/vg_sap)
 ** Adding lvextend line (lvextend -l 125 /dev/vg_sap/lv_sapmnt )
 ** Adding lvcreate line (lvcreate  -n lv_oracle /dev/vg_oracle)
 ** Adding lvextend line (lvextend -l 625 /dev/vg_oracle/lv_oracle )
 ** Adding lvcreate line (lvcreate  -n lv_oracle_stage /dev/vg_oracle)
 ** Adding lvextend line (lvextend -l 938 /dev/vg_oracle/lv_oracle_stage )
 ** Adding lvcreate line (lvcreate  -n lv_oracle_client /dev/vg_oracle)
 ** Adding lvextend line (lvextend -l 157 /dev/vg_oracle/lv_oracle_client )
 ** Adding lvcreate line (lvcreate  -n lv_usr_openv /dev/vg_openv)
 ** Adding lvextend line (lvextend -l 625 /dev/vg_openv/lv_usr_openv )
 ** Adding lvcreate line (lvcreate  -n lv_usropenvnetbackup_logs /dev/vg_openv)
 ** Adding lvextend line (lvextend -l 625 /dev/vg_openv/lv_usropenvnetbackup_logs )
 ** Adding lvcreate line (lvcreate  -n lv_usropenv_logs /dev/vg_openv)
 ** Adding lvextend line (lvextend -l 625 /dev/vg_openv/lv_usropenv_logs )
 ** Adding lvcreate line (lvcreate  -n lv_usropenv_patches /dev/vg_openv)
 ** Adding lvextend line (lvextend -l 625 /dev/vg_openv/lv_usropenv_patches )
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_oracleRJ1_sapdata1)
 ** Adding chmod line (chmod 755 /oracle/RJ1/sapdata1)
 ** Adding chown line (chown root /oracle/RJ1/sapdata1)
 ** Adding chgrp line (chgrp root /oracle/RJ1/sapdata1)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_oracleRJ1_sapdata2)
 ** Adding chmod line (chmod 755 /oracle/RJ1/sapdata2)
 ** Adding chown line (chown root /oracle/RJ1/sapdata2)
 ** Adding chgrp line (chgrp root /oracle/RJ1/sapdata2)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_oracleRJ1_sapdata3)
 ** Adding chmod line (chmod 755 /oracle/RJ1/sapdata3)
 ** Adding chown line (chown root /oracle/RJ1/sapdata3)
 ** Adding chgrp line (chgrp root /oracle/RJ1/sapdata3)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_oracleRJ1_sapdata4)
 ** Adding chmod line (chmod 755 /oracle/RJ1/sapdata4)
 ** Adding chown line (chown root /oracle/RJ1/sapdata4)
 ** Adding chgrp line (chgrp root /oracle/RJ1/sapdata4)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_oracleRJ1_origlogB)
 ** Adding chmod line (chmod 755 /oracle/RJ1/origlogB)
 ** Adding chown line (chown root /oracle/RJ1/origlogB)
 ** Adding chgrp line (chgrp root /oracle/RJ1/origlogB)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_oracleRJ1_origlogA)
 ** Adding chmod line (chmod 755 /oracle/RJ1/origlogA)
 ** Adding chown line (chown root /oracle/RJ1/origlogA)
 ** Adding chgrp line (chgrp root /oracle/RJ1/origlogA)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_oracleRJ1_oraarch)
 ** Adding chmod line (chmod 755 /oracle/RJ1/oraarch)
 ** Adding chown line (chown root /oracle/RJ1/oraarch)
 ** Adding chgrp line (chgrp root /oracle/RJ1/oraarch)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_oracleRJ1_mirrlogB)
 ** Adding chmod line (chmod 755 /oracle/RJ1/mirrlogB)
 ** Adding chown line (chown root /oracle/RJ1/mirrlogB)
 ** Adding chgrp line (chgrp root /oracle/RJ1/mirrlogB)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_oracleRJ1_mirrlogA)
 ** Adding chmod line (chmod 755 /oracle/RJ1/mirrlogA)
 ** Adding chown line (chown root /oracle/RJ1/mirrlogA)
 ** Adding chgrp line (chgrp root /oracle/RJ1/mirrlogA)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_exportsapmnt_RJ1)
 ** Adding chmod line (chmod 755 /export/sapmnt/RJ1)
 ** Adding chown line (chown root /export/sapmnt/RJ1)
 ** Adding chgrp line (chgrp sys /export/sapmnt/RJ1)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_usrsapRJ1_DVEBMGS19)
 ** Adding chmod line (chmod 755 /usr/sap/RJ1/DVEBMGS19)
 ** Adding chown line (chown root /usr/sap/RJ1/DVEBMGS19)
 ** Adding chgrp line (chgrp root /usr/sap/RJ1/DVEBMGS19)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_exportoracleRJ1_sapbackup)
 ** Adding chmod line (chmod 755 /export/oracle/RJ1/sapbackup)
 ** Adding chown line (chown root /export/oracle/RJ1/sapbackup)
 ** Adding chgrp line (chgrp sys /export/oracle/RJ1/sapbackup)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_usrsapRJ1_ASCS05)
 ** Adding chmod line (chmod 755 /usr/sap/RJ1/ASCS05)
 ** Adding chown line (chown root /usr/sap/RJ1/ASCS05)
 ** Adding chgrp line (chgrp root /usr/sap/RJ1/ASCS05)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_oracle_RJ1)
 ** Adding chmod line (chmod 755 /oracle/RJ1)
 ** Adding chown line (chown root /oracle/RJ1)
 ** Adding chgrp line (chgrp root /oracle/RJ1)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_oracleRJ1_112_64)
 ** Adding chmod line (chmod 755 /oracle/RJ1/112_64)
 ** Adding chown line (chown root /oracle/RJ1/112_64)
 ** Adding chgrp line (chgrp root /oracle/RJ1/112_64)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_oracleRJ1_sapreorg)
 ** Adding chmod line (chmod 755 /oracle/RJ1/sapreorg)
 ** Adding chown line (chown root /oracle/RJ1/sapreorg)
 ** Adding chgrp line (chgrp root /oracle/RJ1/sapreorg)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_ZR1/rlv_sapmnt_ZR1)
 ** Adding chmod line (chmod 755 /sapmnt/ZR1)
 ** Adding chown line (chown root /sapmnt/ZR1)
 ** Adding chgrp line (chgrp root /sapmnt/ZR1)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_ZR1/rlv_usrsap_ZR1)
 ** Adding chmod line (chmod 755 /usr/sap/ZR1)
 ** Adding chown line (chown root /usr/sap/ZR1)
 ** Adding chgrp line (chgrp root /usr/sap/ZR1)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ7/rlv_oracleRJ7_sapdata1)
 ** Adding chmod line (chmod 755 /oracle/RJ7/sapdata1)
 ** Adding chown line (chown root /oracle/RJ7/sapdata1)
 ** Adding chgrp line (chgrp root /oracle/RJ7/sapdata1)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ7/rlv_oracleRJ7_sapdata2)
 ** Adding chmod line (chmod 755 /oracle/RJ7/sapdata2)
 ** Adding chown line (chown root /oracle/RJ7/sapdata2)
 ** Adding chgrp line (chgrp root /oracle/RJ7/sapdata2)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ7/rlv_oracleRJ7_origlogA)
 ** Adding chmod line (chmod 755 /oracle/RJ7/origlogA)
 ** Adding chown line (chown root /oracle/RJ7/origlogA)
 ** Adding chgrp line (chgrp root /oracle/RJ7/origlogA)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ7/rlv_oracleRJ7_origlogB)
 ** Adding chmod line (chmod 755 /oracle/RJ7/origlogB)
 ** Adding chown line (chown root /oracle/RJ7/origlogB)
 ** Adding chgrp line (chgrp root /oracle/RJ7/origlogB)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ7/rlv_oracleRJ7_mirrlogA)
 ** Adding chmod line (chmod 755 /oracle/RJ7/mirrlogA)
 ** Adding chown line (chown root /oracle/RJ7/mirrlogA)
 ** Adding chgrp line (chgrp root /oracle/RJ7/mirrlogA)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ7/rlv_oracleRJ7_mirrlogB)
 ** Adding chmod line (chmod 755 /oracle/RJ7/mirrlogB)
 ** Adding chown line (chown root /oracle/RJ7/mirrlogB)
 ** Adding chgrp line (chgrp root /oracle/RJ7/mirrlogB)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ7/rlv_oracleRJ7_102_64)
 ** Adding chmod line (chmod 755 /oracle/RJ7/102_64)
 ** Adding chown line (chown root /oracle/RJ7/102_64)
 ** Adding chgrp line (chgrp root /oracle/RJ7/102_64)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ7/rlv_oracleRJ7_oraarch)
 ** Adding chmod line (chmod 755 /oracle/RJ7/oraarch)
 ** Adding chown line (chown root /oracle/RJ7/oraarch)
 ** Adding chgrp line (chgrp root /oracle/RJ7/oraarch)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ7/rlv_oracleRJ7_sapbackup)
 ** Adding chmod line (chmod 755 /oracle/RJ7/sapbackup)
 ** Adding chown line (chown root /oracle/RJ7/sapbackup)
 ** Adding chgrp line (chgrp root /oracle/RJ7/sapbackup)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ7/rlv_oracleRJ7_saparch)
 ** Adding chmod line (chmod 755 /oracle/RJ7/saparch)
 ** Adding chown line (chown root /oracle/RJ7/saparch)
 ** Adding chgrp line (chgrp root /oracle/RJ7/saparch)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ7/rlv_oracleRJ7_RJ7)
 ** Adding chmod line (chmod 755 /oracle/RJ7)
 ** Adding chown line (chown root /oracle/RJ7)
 ** Adding chgrp line (chgrp root /oracle/RJ7)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_sap/rlv_usr_sap)
 ** Adding chmod line (chmod 755 /usr/sap)
 ** Adding chown line (chown root /usr/sap)
 ** Adding chgrp line (chgrp root /usr/sap)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_sap/rlv_usrsap_SMD)
 ** Adding chmod line (chmod 755 /usr/sap/SMD)
 ** Adding chown line (chown root /usr/sap/SMD)
 ** Adding chgrp line (chgrp root /usr/sap/SMD)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_sap/rlv_usrsapRJ1_ERS05)
 ** Adding chmod line (chmod 755 /usr/sap/RJ1/ERS05)
 ** Adding chown line (chown root /usr/sap/RJ1/ERS05)
 ** Adding chgrp line (chgrp root /usr/sap/RJ1/ERS05)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_sap/rlv_usrsapRJ6_ERS25)
 ** Adding chmod line (chmod 755 /usr/sap/RJ6/ERS25)
 ** Adding chown line (chown root /usr/sap/RJ6/ERS25)
 ** Adding chgrp line (chgrp root /usr/sap/RJ6/ERS25)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_sap/rlv_usrsapSMD_J97)
 ** Adding chmod line (chmod 755 /usr/sap/SMD/J97)
 ** Adding chown line (chown root /usr/sap/SMD/J97)
 ** Adding chgrp line (chgrp root /usr/sap/SMD/J97)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_sap/rlv_usrsapSMD_J98)
 ** Adding chmod line (chmod 755 /usr/sap/SMD/J98)
 ** Adding chown line (chown root /usr/sap/SMD/J98)
 ** Adding chgrp line (chgrp root /usr/sap/SMD/J98)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_sap/rlv_sapmnt)
 ** Adding chmod line (chmod 755 /sapmnt)
 ** Adding chown line (chown root /sapmnt)
 ** Adding chgrp line (chgrp root /sapmnt)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_oracle/rlv_oracle)
 ** Adding chmod line (chmod 755 /oracle)
 ** Adding chown line (chown root /oracle)
 ** Adding chgrp line (chgrp root /oracle)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_oracle/rlv_oracle_stage)
 ** Adding chmod line (chmod 755 /oracle/stage)
 ** Adding chown line (chown root /oracle/stage)
 ** Adding chgrp line (chgrp root /oracle/stage)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_oracle/rlv_oracle_client)
 ** Adding chmod line (chmod 755 /oracle/client)
 ** Adding chown line (chown root /oracle/client)
 ** Adding chgrp line (chgrp root /oracle/client)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_openv/rlv_usr_openv)
 ** Adding chmod line (chmod 755 /usr/openv)
 ** Adding chown line (chown root /usr/openv)
 ** Adding chgrp line (chgrp root /usr/openv)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_openv/rlv_usropenvnetbackup_logs)
 ** Adding chmod line (chmod 755 /usr/openv/netbackup/logs)
 ** Adding chown line (chown root /usr/openv/netbackup/logs)
 ** Adding chgrp line (chgrp root /usr/openv/netbackup/logs)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_openv/rlv_usropenv_logs)
 ** Adding chmod line (chmod 755 /usr/openv/logs)
 ** Adding chown line (chown root /usr/openv/logs)
 ** Adding chgrp line (chgrp root /usr/openv/logs)
 ** Adding mkfs line (mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_openv/rlv_usropenv_patches)
 ** Adding chmod line (chmod 755 /usr/openv/patches)
 ** Adding chown line (chown root /usr/openv/patches)
 ** Adding chgrp line (chgrp root /usr/openv/patches)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk60 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk60)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk23 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk23)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk17 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk17)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk38 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk38)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk18 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk18)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk25 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk25)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk36 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk36)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk54 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk54)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk55 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk55)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk32 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk32)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk8 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk8)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk48 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk48)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk33 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk33)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk28 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk28)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk45 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk45)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk69 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk69)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk56 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk56)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk51 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk51)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk10 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk10)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk74 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk74)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk47 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk47)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk62 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk62)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk59 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk59)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk67 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk67)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk73 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk73)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk43 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk43)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk14 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk14)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk66 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk66)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk29 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk29)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk58 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk58)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk49 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk49)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk50 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk50)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk61 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk61)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk26 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk26)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk40 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk40)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk64 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk64)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk27 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk27)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk65 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk65)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk52 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk52)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk72 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk72)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk70 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk70)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk57 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk57)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk37 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk37)
 ** Adding scsimgr line (scsimgr save_attr -D /dev/rdisk/disk71 -a load_bal_policy=least_cmd_load)
 ** Addinf scsictl line (scsictl -m queue_depth=16 /dev/rdisk/disk71)
 ** Removed temporary directory /tmp/san027235

    Inspect script /home/gdhaese1/projects/SANmigration/make_SAN_layout_of_itshrr01.sh before executing it!

    Done.
----


The +create_san_layout_script.sh+ script is in fact a simple script generator which creates a new script called +make_SAN_layout_of_itshrr01.sh+. of course, the hostname part is different on each host. And, you can also use the _h_, _k_ and _f_ options as with the first script.

== The script which actually recreates the SAN layout

All the effort we've done so far is to have this new script (+make_SAN_layout_of_itshrr01.sh+) made by +create_san_layout_script.sh+
Be aware, we ran +create_san_layout_script.sh+ before we hooked up the new SAN, therefore, we see also lots of lines on +umount+ and +vgexport+ existing Volume Groups. Therefore, be extremely caution to execute the +make_SAN_layout_of_itshrr01.sh+ on the existing SAN box. The +vgexport+ command will delete all existing volume groups (and data)!!

*So, you have been warned.*

The new script +make_SAN_layout_of_itshrr01.sh+, which you created by +create_san_layout_script.sh+ looks like:

----
#-> cat /home/gdhaese1/projects/SANmigration/make_SAN_layout_of_itshrr01.sh
#!/bin/ksh
# Script make_SAN_layout_of_itshrr01.sh was created by create_san_layout_script.sh
# on 2012-Aug-14
#
##############
# Parameters #
##############

typeset -x PRGNAME=${0##*/}
typeset -x PRGDIR=${0%/*}
[[ $PRGDIR = /* ]] || PRGDIR=$(pwd)

typeset -x PATH=/usr/local/CPR/bin:/sbin:/usr/sbin:/usr/bin:/usr/xpg4/bin:/usr/local/CPR/bin:/sbin:/usr/sbin:/usr/bin:/usr/xpg4/bin:/usr/sbin:/usr/bin:/usr/ccs/bin:/usr/contrib/bin:/usr/contrib/Q4/bin:/opt/perl/bin:/opt/gvsd/bin:/opt/ipf/bin:/opt/nettladm/bin:/opt/fcms/bin:/opt/wbem/bin:/opt/wbem/sbin:/opt/sas/bin:/opt/graphics/common/bin:/opt/atok/bin:/usr/bin/X11:/usr/contrib/bin/X11:/opt/sec_mgmt/bastille/bin:/opt/caliper/bin:/opt/drd/bin:/opt/dsau/bin:/opt/dsau/sbin:/opt/resmon/bin:/opt/firefox:/opt/gnome/bin:/opt/perf/bin:/opt/ignite/bin:/opt/propplus/bin:/usr/contrib/kwdb/bin:/opt/perl_32/bin:/opt/perl_64/bin:/opt/prm/bin:/opt/sfm/bin:/opt/swm/bin:/opt/sec_mgmt/spc/bin:/opt/ssh/bin:/opt/swa/bin:/opt/hpsmh/bin:/opt/sentinel/bin:/opt/langtools/bin:/opt/wlm/bin:/opt/gwlm/bin:/usr/local/bin:/sbin:/home/root:/opt/ncsbin/utils:/opt/ncsbin/acctutil:/usr/share/centrifydc/bin:/usr/ucb:.:/usr/ucb:.
typeset -r platform=$(uname -s)
typeset -r model=$(uname -m)                            # Model
typeset -r HOSTNAME=$(uname -n)                         # hostname
typeset os=$(uname -r); os=${os#B.}
typeset -r dlog=/var/adm/install-logs
typeset instlog=$dlog/${PRGNAME%???}.scriptlog
typeset -x SANCONF="/tmp/SAN_layout_of_$(hostname).conf"
typeset XPINFO="xpinfo"
typeset -x KEEPTMPDIR=0

#############
# FUNCTIONS #
#############

# Read the shell functions
if [ ! -d $PRGDIR/shlib ]; then
echo "ERROR: Cannot find $PRGDIR/shlib directory - where are my functions?"
exit 1
fi
for func in $(ls $PRGDIR/shlib)
do
. $PRGDIR/shlib/$func
done

################
### M A I N  ###
################

while [ $# -gt 0 ]; do
case "$1" in
-f)     SANCONF=$2
_is_var_empty "$SANCONF"
shift 2
;;
-k)     KEEPTMPDIR=1
shift 1
;;
*)      _show_help_${PRGNAME%%_*}
;;
esac
done

{       # brace needed as we log everything in "instlog"
_banner "Write the SAN creation script ($(basename $0))"
_whoami
_check_sanconf || _show_help_${PRGNAME%%_*}
_osrevision
_create_temp_dir

_note "Exec: umount /dev/vg_RJ1/lv_oracleRJ1_sapdata1"
umount /dev/vg_RJ1/lv_oracleRJ1_sapdata1
_check_rc $? "umount /dev/vg_RJ1/lv_oracleRJ1_sapdata1 failed. Do you want to continue"

_note "Exec: umount /dev/vg_RJ1/lv_oracleRJ1_sapdata2"
umount /dev/vg_RJ1/lv_oracleRJ1_sapdata2
_check_rc $? "umount /dev/vg_RJ1/lv_oracleRJ1_sapdata2 failed. Do you want to continue"

_note "Exec: umount /dev/vg_RJ1/lv_oracleRJ1_sapdata3"
umount /dev/vg_RJ1/lv_oracleRJ1_sapdata3
_check_rc $? "umount /dev/vg_RJ1/lv_oracleRJ1_sapdata3 failed. Do you want to continue"

_note "Exec: umount /dev/vg_RJ1/lv_oracleRJ1_sapdata4"
umount /dev/vg_RJ1/lv_oracleRJ1_sapdata4
_check_rc $? "umount /dev/vg_RJ1/lv_oracleRJ1_sapdata4 failed. Do you want to continue"

_note "Exec: umount /dev/vg_RJ1/lv_oracleRJ1_origlogB"
umount /dev/vg_RJ1/lv_oracleRJ1_origlogB
_check_rc $? "umount /dev/vg_RJ1/lv_oracleRJ1_origlogB failed. Do you want to continue"

_note "Exec: umount /dev/vg_RJ1/lv_oracleRJ1_origlogA"
umount /dev/vg_RJ1/lv_oracleRJ1_origlogA
_check_rc $? "umount /dev/vg_RJ1/lv_oracleRJ1_origlogA failed. Do you want to continue"

_note "Exec: umount /dev/vg_RJ1/lv_oracleRJ1_oraarch"
umount /dev/vg_RJ1/lv_oracleRJ1_oraarch
_check_rc $? "umount /dev/vg_RJ1/lv_oracleRJ1_oraarch failed. Do you want to continue"

_note "Exec: umount /dev/vg_RJ1/lv_oracleRJ1_mirrlogB"
umount /dev/vg_RJ1/lv_oracleRJ1_mirrlogB
_check_rc $? "umount /dev/vg_RJ1/lv_oracleRJ1_mirrlogB failed. Do you want to continue"

_note "Exec: umount /dev/vg_RJ1/lv_oracleRJ1_mirrlogA"
umount /dev/vg_RJ1/lv_oracleRJ1_mirrlogA
_check_rc $? "umount /dev/vg_RJ1/lv_oracleRJ1_mirrlogA failed. Do you want to continue"

_note "Exec: exportfs -uv /export/sapmnt/RJ1"
exportfs -uv /export/sapmnt/RJ1
_check_rc $? "exportfs -uv /export/sapmnt/RJ1 failed. Do you want to continue"

_note "Exec: umount /dev/vg_RJ1/lv_usrsapRJ1_DVEBMGS19"
umount /dev/vg_RJ1/lv_usrsapRJ1_DVEBMGS19
_check_rc $? "umount /dev/vg_RJ1/lv_usrsapRJ1_DVEBMGS19 failed. Do you want to continue"

_note "Exec: exportfs -uv /export/oracle/RJ1/sapbackup"
exportfs -uv /export/oracle/RJ1/sapbackup
_check_rc $? "exportfs -uv /export/oracle/RJ1/sapbackup failed. Do you want to continue"

_note "Exec: umount /dev/vg_RJ1/lv_usrsapRJ1_ASCS05"
umount /dev/vg_RJ1/lv_usrsapRJ1_ASCS05
_check_rc $? "umount /dev/vg_RJ1/lv_usrsapRJ1_ASCS05 failed. Do you want to continue"

_note "Exec: umount /dev/vg_RJ1/lv_oracle_RJ1"
umount /dev/vg_RJ1/lv_oracle_RJ1
_check_rc $? "umount /dev/vg_RJ1/lv_oracle_RJ1 failed. Do you want to continue"

_note "Exec: umount /dev/vg_RJ1/lv_oracleRJ1_112_64"
umount /dev/vg_RJ1/lv_oracleRJ1_112_64
_check_rc $? "umount /dev/vg_RJ1/lv_oracleRJ1_112_64 failed. Do you want to continue"

_note "Exec: umount /dev/vg_RJ1/lv_oracleRJ1_sapreorg"
umount /dev/vg_RJ1/lv_oracleRJ1_sapreorg
_check_rc $? "umount /dev/vg_RJ1/lv_oracleRJ1_sapreorg failed. Do you want to continue"

_note "Exec: vgchange -a n /dev/vg_RJ1"
vgchange -a n /dev/vg_RJ1
_check_rc $? "vgchange -a n /dev/vg_RJ1 failed. Do you want to continue"

_note "vgexport -m $TMPDIR/vg_RJ1.mapfile -f $TMPDIR/vg_RJ1.outfile  /dev/vg_RJ1"
vgexport -m $TMPDIR/vg_RJ1.mapfile -f $TMPDIR/vg_RJ1.outfile  /dev/vg_RJ1
_check_rc $? "vgexport of /dev/vg_RJ1 failed. Do you want to continue"

_note "Exec: umount /dev/vg_ZR1/lv_sapmnt_ZR1"
umount /dev/vg_ZR1/lv_sapmnt_ZR1
_check_rc $? "umount /dev/vg_ZR1/lv_sapmnt_ZR1 failed. Do you want to continue"

_note "Exec: umount /dev/vg_ZR1/lv_usrsap_ZR1"
umount /dev/vg_ZR1/lv_usrsap_ZR1
_check_rc $? "umount /dev/vg_ZR1/lv_usrsap_ZR1 failed. Do you want to continue"

_note "Exec: vgchange -a n /dev/vg_ZR1"
vgchange -a n /dev/vg_ZR1
_check_rc $? "vgchange -a n /dev/vg_ZR1 failed. Do you want to continue"

_note "vgexport -m $TMPDIR/vg_ZR1.mapfile -f $TMPDIR/vg_ZR1.outfile  /dev/vg_ZR1"
vgexport -m $TMPDIR/vg_ZR1.mapfile -f $TMPDIR/vg_ZR1.outfile  /dev/vg_ZR1
_check_rc $? "vgexport of /dev/vg_ZR1 failed. Do you want to continue"

_note "Exec: umount /dev/vg_RJ7/lv_oracleRJ7_sapdata1"
umount /dev/vg_RJ7/lv_oracleRJ7_sapdata1
_check_rc $? "umount /dev/vg_RJ7/lv_oracleRJ7_sapdata1 failed. Do you want to continue"

_note "Exec: umount /dev/vg_RJ7/lv_oracleRJ7_sapdata2"
umount /dev/vg_RJ7/lv_oracleRJ7_sapdata2
_check_rc $? "umount /dev/vg_RJ7/lv_oracleRJ7_sapdata2 failed. Do you want to continue"

_note "Exec: umount /dev/vg_RJ7/lv_oracleRJ7_origlogA"
umount /dev/vg_RJ7/lv_oracleRJ7_origlogA
_check_rc $? "umount /dev/vg_RJ7/lv_oracleRJ7_origlogA failed. Do you want to continue"

_note "Exec: umount /dev/vg_RJ7/lv_oracleRJ7_origlogB"
umount /dev/vg_RJ7/lv_oracleRJ7_origlogB
_check_rc $? "umount /dev/vg_RJ7/lv_oracleRJ7_origlogB failed. Do you want to continue"

_note "Exec: umount /dev/vg_RJ7/lv_oracleRJ7_mirrlogA"
umount /dev/vg_RJ7/lv_oracleRJ7_mirrlogA
_check_rc $? "umount /dev/vg_RJ7/lv_oracleRJ7_mirrlogA failed. Do you want to continue"

_note "Exec: umount /dev/vg_RJ7/lv_oracleRJ7_mirrlogB"
umount /dev/vg_RJ7/lv_oracleRJ7_mirrlogB
_check_rc $? "umount /dev/vg_RJ7/lv_oracleRJ7_mirrlogB failed. Do you want to continue"

_note "Exec: umount /dev/vg_RJ7/lv_oracleRJ7_102_64"
umount /dev/vg_RJ7/lv_oracleRJ7_102_64
_check_rc $? "umount /dev/vg_RJ7/lv_oracleRJ7_102_64 failed. Do you want to continue"

_note "Exec: umount /dev/vg_RJ7/lv_oracleRJ7_oraarch"
umount /dev/vg_RJ7/lv_oracleRJ7_oraarch
_check_rc $? "umount /dev/vg_RJ7/lv_oracleRJ7_oraarch failed. Do you want to continue"

_note "Exec: umount /dev/vg_RJ7/lv_oracleRJ7_sapbackup"
umount /dev/vg_RJ7/lv_oracleRJ7_sapbackup
_check_rc $? "umount /dev/vg_RJ7/lv_oracleRJ7_sapbackup failed. Do you want to continue"

_note "Exec: umount /dev/vg_RJ7/lv_oracleRJ7_saparch"
umount /dev/vg_RJ7/lv_oracleRJ7_saparch
_check_rc $? "umount /dev/vg_RJ7/lv_oracleRJ7_saparch failed. Do you want to continue"

_note "Exec: umount /dev/vg_RJ7/lv_oracleRJ7_RJ7"
umount /dev/vg_RJ7/lv_oracleRJ7_RJ7
_check_rc $? "umount /dev/vg_RJ7/lv_oracleRJ7_RJ7 failed. Do you want to continue"

_note "Exec: vgchange -a n /dev/vg_RJ7"
vgchange -a n /dev/vg_RJ7
_check_rc $? "vgchange -a n /dev/vg_RJ7 failed. Do you want to continue"

_note "vgexport -m $TMPDIR/vg_RJ7.mapfile -f $TMPDIR/vg_RJ7.outfile  /dev/vg_RJ7"
vgexport -m $TMPDIR/vg_RJ7.mapfile -f $TMPDIR/vg_RJ7.outfile  /dev/vg_RJ7
_check_rc $? "vgexport of /dev/vg_RJ7 failed. Do you want to continue"

_note "Exec: umount /dev/vg_sap/lv_usr_sap"
umount /dev/vg_sap/lv_usr_sap
_check_rc $? "umount /dev/vg_sap/lv_usr_sap failed. Do you want to continue"

_note "Exec: umount /dev/vg_sap/lv_usrsap_SMD"
umount /dev/vg_sap/lv_usrsap_SMD
_check_rc $? "umount /dev/vg_sap/lv_usrsap_SMD failed. Do you want to continue"

_note "Exec: umount /dev/vg_sap/lv_usrsapRJ1_ERS05"
umount /dev/vg_sap/lv_usrsapRJ1_ERS05
_check_rc $? "umount /dev/vg_sap/lv_usrsapRJ1_ERS05 failed. Do you want to continue"

_note "Exec: umount /dev/vg_sap/lv_usrsapRJ6_ERS25"
umount /dev/vg_sap/lv_usrsapRJ6_ERS25
_check_rc $? "umount /dev/vg_sap/lv_usrsapRJ6_ERS25 failed. Do you want to continue"

_note "Exec: umount /dev/vg_sap/lv_usrsapSMD_J97"
umount /dev/vg_sap/lv_usrsapSMD_J97
_check_rc $? "umount /dev/vg_sap/lv_usrsapSMD_J97 failed. Do you want to continue"

_note "Exec: umount /dev/vg_sap/lv_usrsapSMD_J98"
umount /dev/vg_sap/lv_usrsapSMD_J98
_check_rc $? "umount /dev/vg_sap/lv_usrsapSMD_J98 failed. Do you want to continue"

_note "Exec: umount /dev/vg_sap/lv_sapmnt"
umount /dev/vg_sap/lv_sapmnt
_check_rc $? "umount /dev/vg_sap/lv_sapmnt failed. Do you want to continue"

_note "Exec: vgchange -a n /dev/vg_sap"
vgchange -a n /dev/vg_sap
_check_rc $? "vgchange -a n /dev/vg_sap failed. Do you want to continue"

_note "vgexport -m $TMPDIR/vg_sap.mapfile -f $TMPDIR/vg_sap.outfile  /dev/vg_sap"
vgexport -m $TMPDIR/vg_sap.mapfile -f $TMPDIR/vg_sap.outfile  /dev/vg_sap
_check_rc $? "vgexport of /dev/vg_sap failed. Do you want to continue"

_note "Exec: umount /dev/vg_oracle/lv_oracle"
umount /dev/vg_oracle/lv_oracle
_check_rc $? "umount /dev/vg_oracle/lv_oracle failed. Do you want to continue"

_note "Exec: umount /dev/vg_oracle/lv_oracle_stage"
umount /dev/vg_oracle/lv_oracle_stage
_check_rc $? "umount /dev/vg_oracle/lv_oracle_stage failed. Do you want to continue"

_note "Exec: umount /dev/vg_oracle/lv_oracle_client"
umount /dev/vg_oracle/lv_oracle_client
_check_rc $? "umount /dev/vg_oracle/lv_oracle_client failed. Do you want to continue"

_note "Exec: vgchange -a n /dev/vg_oracle"
vgchange -a n /dev/vg_oracle
_check_rc $? "vgchange -a n /dev/vg_oracle failed. Do you want to continue"

_note "vgexport -m $TMPDIR/vg_oracle.mapfile -f $TMPDIR/vg_oracle.outfile  /dev/vg_oracle"
vgexport -m $TMPDIR/vg_oracle.mapfile -f $TMPDIR/vg_oracle.outfile  /dev/vg_oracle
_check_rc $? "vgexport of /dev/vg_oracle failed. Do you want to continue"

_note "Exec: umount /dev/vg_openv/lv_usr_openv"
umount /dev/vg_openv/lv_usr_openv
_check_rc $? "umount /dev/vg_openv/lv_usr_openv failed. Do you want to continue"

_note "Exec: umount /dev/vg_openv/lv_usropenvnetbackup_logs"
umount /dev/vg_openv/lv_usropenvnetbackup_logs
_check_rc $? "umount /dev/vg_openv/lv_usropenvnetbackup_logs failed. Do you want to continue"

_note "Exec: umount /dev/vg_openv/lv_usropenv_logs"
umount /dev/vg_openv/lv_usropenv_logs
_check_rc $? "umount /dev/vg_openv/lv_usropenv_logs failed. Do you want to continue"

_note "Exec: umount /dev/vg_openv/lv_usropenv_patches"
umount /dev/vg_openv/lv_usropenv_patches
_check_rc $? "umount /dev/vg_openv/lv_usropenv_patches failed. Do you want to continue"

_note "Exec: vgchange -a n /dev/vg_openv"
vgchange -a n /dev/vg_openv
_check_rc $? "vgchange -a n /dev/vg_openv failed. Do you want to continue"

_note "vgexport -m $TMPDIR/vg_openv.mapfile -f $TMPDIR/vg_openv.outfile  /dev/vg_openv"
vgexport -m $TMPDIR/vg_openv.mapfile -f $TMPDIR/vg_openv.outfile  /dev/vg_openv
_check_rc $? "vgexport of /dev/vg_openv failed. Do you want to continue"

_convert_lvmtab_to_ascii

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk46 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk46"
_note "Exec: pvcreate -f /dev/rdisk/disk46"
pvcreate -f /dev/rdisk/disk46
_check_rc $? "pvcreate -f /dev/rdisk/disk46 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk25 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk25"
_note "Exec: pvcreate -f /dev/rdisk/disk25"
pvcreate -f /dev/rdisk/disk25
_check_rc $? "pvcreate -f /dev/rdisk/disk25 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk38 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk38"
_note "Exec: pvcreate -f /dev/rdisk/disk38"
pvcreate -f /dev/rdisk/disk38
_check_rc $? "pvcreate -f /dev/rdisk/disk38 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk17 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk17"
_note "Exec: pvcreate -f /dev/rdisk/disk17"
pvcreate -f /dev/rdisk/disk17
_check_rc $? "pvcreate -f /dev/rdisk/disk17 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk22 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk22"
_note "Exec: pvcreate -f /dev/rdisk/disk22"
pvcreate -f /dev/rdisk/disk22
_check_rc $? "pvcreate -f /dev/rdisk/disk22 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk12 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk12"
_note "Exec: pvcreate -f /dev/rdisk/disk12"
pvcreate -f /dev/rdisk/disk12
_check_rc $? "pvcreate -f /dev/rdisk/disk12 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk15 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk15"
_note "Exec: pvcreate -f /dev/rdisk/disk15"
pvcreate -f /dev/rdisk/disk15
_check_rc $? "pvcreate -f /dev/rdisk/disk15 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk42 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk42"
_note "Exec: pvcreate -f /dev/rdisk/disk42"
pvcreate -f /dev/rdisk/disk42
_check_rc $? "pvcreate -f /dev/rdisk/disk42 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk31 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk31"
_note "Exec: pvcreate -f /dev/rdisk/disk31"
pvcreate -f /dev/rdisk/disk31
_check_rc $? "pvcreate -f /dev/rdisk/disk31 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk11 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk11"
_note "Exec: pvcreate -f /dev/rdisk/disk11"
pvcreate -f /dev/rdisk/disk11
_check_rc $? "pvcreate -f /dev/rdisk/disk11 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk9 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk9"
_note "Exec: pvcreate -f /dev/rdisk/disk9"
pvcreate -f /dev/rdisk/disk9
_check_rc $? "pvcreate -f /dev/rdisk/disk9 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk34 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk34"
_note "Exec: pvcreate -f /dev/rdisk/disk34"
pvcreate -f /dev/rdisk/disk34
_check_rc $? "pvcreate -f /dev/rdisk/disk34 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk13 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk13"
_note "Exec: pvcreate -f /dev/rdisk/disk13"
pvcreate -f /dev/rdisk/disk13
_check_rc $? "pvcreate -f /dev/rdisk/disk13 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk16 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk16"
_note "Exec: pvcreate -f /dev/rdisk/disk16"
pvcreate -f /dev/rdisk/disk16
_check_rc $? "pvcreate -f /dev/rdisk/disk16 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk29 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk29"
_note "Exec: pvcreate -f /dev/rdisk/disk29"
pvcreate -f /dev/rdisk/disk29
_check_rc $? "pvcreate -f /dev/rdisk/disk29 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk35 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk35"
_note "Exec: pvcreate -f /dev/rdisk/disk35"
pvcreate -f /dev/rdisk/disk35
_check_rc $? "pvcreate -f /dev/rdisk/disk35 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk73 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk73"
_note "Exec: pvcreate -f /dev/rdisk/disk73"
pvcreate -f /dev/rdisk/disk73
_check_rc $? "pvcreate -f /dev/rdisk/disk73 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk43 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk43"
_note "Exec: pvcreate -f /dev/rdisk/disk43"
pvcreate -f /dev/rdisk/disk43
_check_rc $? "pvcreate -f /dev/rdisk/disk43 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk19 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk19"
_note "Exec: pvcreate -f /dev/rdisk/disk19"
pvcreate -f /dev/rdisk/disk19
_check_rc $? "pvcreate -f /dev/rdisk/disk19 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk30 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk30"
_note "Exec: pvcreate -f /dev/rdisk/disk30"
pvcreate -f /dev/rdisk/disk30
_check_rc $? "pvcreate -f /dev/rdisk/disk30 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk70 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk70"
_note "Exec: pvcreate -f /dev/rdisk/disk70"
pvcreate -f /dev/rdisk/disk70
_check_rc $? "pvcreate -f /dev/rdisk/disk70 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk68 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk68"
_note "Exec: pvcreate -f /dev/rdisk/disk68"
pvcreate -f /dev/rdisk/disk68
_check_rc $? "pvcreate -f /dev/rdisk/disk68 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk21 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk21"
_note "Exec: pvcreate -f /dev/rdisk/disk21"
pvcreate -f /dev/rdisk/disk21
_check_rc $? "pvcreate -f /dev/rdisk/disk21 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk37 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk37"
_note "Exec: pvcreate -f /dev/rdisk/disk37"
pvcreate -f /dev/rdisk/disk37
_check_rc $? "pvcreate -f /dev/rdisk/disk37 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk63 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk63"
_note "Exec: pvcreate -f /dev/rdisk/disk63"
pvcreate -f /dev/rdisk/disk63
_check_rc $? "pvcreate -f /dev/rdisk/disk63 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk23 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk23"
_note "Exec: pvcreate -f /dev/rdisk/disk23"
pvcreate -f /dev/rdisk/disk23
_check_rc $? "pvcreate -f /dev/rdisk/disk23 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk60 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk60"
_note "Exec: pvcreate -f /dev/rdisk/disk60"
pvcreate -f /dev/rdisk/disk60
_check_rc $? "pvcreate -f /dev/rdisk/disk60 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk7 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk7"
_note "Exec: pvcreate -f /dev/rdisk/disk7"
pvcreate -f /dev/rdisk/disk7
_check_rc $? "pvcreate -f /dev/rdisk/disk7 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk6 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk6"
_note "Exec: pvcreate -f /dev/rdisk/disk6"
pvcreate -f /dev/rdisk/disk6
_check_rc $? "pvcreate -f /dev/rdisk/disk6 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk24 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk24"
_note "Exec: pvcreate -f /dev/rdisk/disk24"
pvcreate -f /dev/rdisk/disk24
_check_rc $? "pvcreate -f /dev/rdisk/disk24 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk20 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk20"
_note "Exec: pvcreate -f /dev/rdisk/disk20"
pvcreate -f /dev/rdisk/disk20
_check_rc $? "pvcreate -f /dev/rdisk/disk20 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk36 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk36"
_note "Exec: pvcreate -f /dev/rdisk/disk36"
pvcreate -f /dev/rdisk/disk36
_check_rc $? "pvcreate -f /dev/rdisk/disk36 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk54 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk54"
_note "Exec: pvcreate -f /dev/rdisk/disk54"
pvcreate -f /dev/rdisk/disk54
_check_rc $? "pvcreate -f /dev/rdisk/disk54 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk56 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk56"
_note "Exec: pvcreate -f /dev/rdisk/disk56"
pvcreate -f /dev/rdisk/disk56
_check_rc $? "pvcreate -f /dev/rdisk/disk56 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk8 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk8"
_note "Exec: pvcreate -f /dev/rdisk/disk8"
pvcreate -f /dev/rdisk/disk8
_check_rc $? "pvcreate -f /dev/rdisk/disk8 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk67 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk67"
_note "Exec: pvcreate -f /dev/rdisk/disk67"
pvcreate -f /dev/rdisk/disk67
_check_rc $? "pvcreate -f /dev/rdisk/disk67 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk45 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk45"
_note "Exec: pvcreate -f /dev/rdisk/disk45"
pvcreate -f /dev/rdisk/disk45
_check_rc $? "pvcreate -f /dev/rdisk/disk45 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk48 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk48"
_note "Exec: pvcreate -f /dev/rdisk/disk48"
pvcreate -f /dev/rdisk/disk48
_check_rc $? "pvcreate -f /dev/rdisk/disk48 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk32 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk32"
_note "Exec: pvcreate -f /dev/rdisk/disk32"
pvcreate -f /dev/rdisk/disk32
_check_rc $? "pvcreate -f /dev/rdisk/disk32 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk33 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk33"
_note "Exec: pvcreate -f /dev/rdisk/disk33"
pvcreate -f /dev/rdisk/disk33
_check_rc $? "pvcreate -f /dev/rdisk/disk33 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk62 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk62"
_note "Exec: pvcreate -f /dev/rdisk/disk62"
pvcreate -f /dev/rdisk/disk62
_check_rc $? "pvcreate -f /dev/rdisk/disk62 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk51 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk51"
_note "Exec: pvcreate -f /dev/rdisk/disk51"
pvcreate -f /dev/rdisk/disk51
_check_rc $? "pvcreate -f /dev/rdisk/disk51 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk69 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk69"
_note "Exec: pvcreate -f /dev/rdisk/disk69"
pvcreate -f /dev/rdisk/disk69
_check_rc $? "pvcreate -f /dev/rdisk/disk69 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk55 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk55"
_note "Exec: pvcreate -f /dev/rdisk/disk55"
pvcreate -f /dev/rdisk/disk55
_check_rc $? "pvcreate -f /dev/rdisk/disk55 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk59 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk59"
_note "Exec: pvcreate -f /dev/rdisk/disk59"
pvcreate -f /dev/rdisk/disk59
_check_rc $? "pvcreate -f /dev/rdisk/disk59 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk28 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk28"
_note "Exec: pvcreate -f /dev/rdisk/disk28"
pvcreate -f /dev/rdisk/disk28
_check_rc $? "pvcreate -f /dev/rdisk/disk28 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk74 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk74"
_note "Exec: pvcreate -f /dev/rdisk/disk74"
pvcreate -f /dev/rdisk/disk74
_check_rc $? "pvcreate -f /dev/rdisk/disk74 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk10 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk10"
_note "Exec: pvcreate -f /dev/rdisk/disk10"
pvcreate -f /dev/rdisk/disk10
_check_rc $? "pvcreate -f /dev/rdisk/disk10 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk47 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk47"
_note "Exec: pvcreate -f /dev/rdisk/disk47"
pvcreate -f /dev/rdisk/disk47
_check_rc $? "pvcreate -f /dev/rdisk/disk47 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk64 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk64"
_note "Exec: pvcreate -f /dev/rdisk/disk64"
pvcreate -f /dev/rdisk/disk64
_check_rc $? "pvcreate -f /dev/rdisk/disk64 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk53 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk53"
_note "Exec: pvcreate -f /dev/rdisk/disk53"
pvcreate -f /dev/rdisk/disk53
_check_rc $? "pvcreate -f /dev/rdisk/disk53 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk14 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk14"
_note "Exec: pvcreate -f /dev/rdisk/disk14"
pvcreate -f /dev/rdisk/disk14
_check_rc $? "pvcreate -f /dev/rdisk/disk14 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk66 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk66"
_note "Exec: pvcreate -f /dev/rdisk/disk66"
pvcreate -f /dev/rdisk/disk66
_check_rc $? "pvcreate -f /dev/rdisk/disk66 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk18 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk18"
_note "Exec: pvcreate -f /dev/rdisk/disk18"
pvcreate -f /dev/rdisk/disk18
_check_rc $? "pvcreate -f /dev/rdisk/disk18 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk50 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk50"
_note "Exec: pvcreate -f /dev/rdisk/disk50"
pvcreate -f /dev/rdisk/disk50
_check_rc $? "pvcreate -f /dev/rdisk/disk50 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk58 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk58"
_note "Exec: pvcreate -f /dev/rdisk/disk58"
pvcreate -f /dev/rdisk/disk58
_check_rc $? "pvcreate -f /dev/rdisk/disk58 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk49 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk49"
_note "Exec: pvcreate -f /dev/rdisk/disk49"
pvcreate -f /dev/rdisk/disk49
_check_rc $? "pvcreate -f /dev/rdisk/disk49 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk26 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk26"
_note "Exec: pvcreate -f /dev/rdisk/disk26"
pvcreate -f /dev/rdisk/disk26
_check_rc $? "pvcreate -f /dev/rdisk/disk26 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk61 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk61"
_note "Exec: pvcreate -f /dev/rdisk/disk61"
pvcreate -f /dev/rdisk/disk61
_check_rc $? "pvcreate -f /dev/rdisk/disk61 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk44 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk44"
_note "Exec: pvcreate -f /dev/rdisk/disk44"
pvcreate -f /dev/rdisk/disk44
_check_rc $? "pvcreate -f /dev/rdisk/disk44 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk40 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk40"
_note "Exec: pvcreate -f /dev/rdisk/disk40"
pvcreate -f /dev/rdisk/disk40
_check_rc $? "pvcreate -f /dev/rdisk/disk40 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk27 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk27"
_note "Exec: pvcreate -f /dev/rdisk/disk27"
pvcreate -f /dev/rdisk/disk27
_check_rc $? "pvcreate -f /dev/rdisk/disk27 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk65 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk65"
_note "Exec: pvcreate -f /dev/rdisk/disk65"
pvcreate -f /dev/rdisk/disk65
_check_rc $? "pvcreate -f /dev/rdisk/disk65 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk52 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk52"
_note "Exec: pvcreate -f /dev/rdisk/disk52"
pvcreate -f /dev/rdisk/disk52
_check_rc $? "pvcreate -f /dev/rdisk/disk52 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk72 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk72"
_note "Exec: pvcreate -f /dev/rdisk/disk72"
pvcreate -f /dev/rdisk/disk72
_check_rc $? "pvcreate -f /dev/rdisk/disk72 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk57 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk57"
_note "Exec: pvcreate -f /dev/rdisk/disk57"
pvcreate -f /dev/rdisk/disk57
_check_rc $? "pvcreate -f /dev/rdisk/disk57 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk41 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk41"
_note "Exec: pvcreate -f /dev/rdisk/disk41"
pvcreate -f /dev/rdisk/disk41
_check_rc $? "pvcreate -f /dev/rdisk/disk41 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk39 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk39"
_note "Exec: pvcreate -f /dev/rdisk/disk39"
pvcreate -f /dev/rdisk/disk39
_check_rc $? "pvcreate -f /dev/rdisk/disk39 failed. Do you want to continue"

# safety check on disk - still in use or not
_disk_in_use /dev/rdisk/disk71 || _check_rc $? "Do you really want to pvcreate disk /dev/rdisk/disk71"
_note "Exec: pvcreate -f /dev/rdisk/disk71"
pvcreate -f /dev/rdisk/disk71
_check_rc $? "pvcreate -f /dev/rdisk/disk71 failed. Do you want to continue"

####### /dev/vg_RJ1 ######
# check dir
if [[ -d /dev/vg_RJ1 ]]; then
_note "Directory /dev/vg_RJ1 already exist"
else
_note "Exec: mkdir -p -m 755 /dev/vg_RJ1"
mkdir -p -m 755 /dev/vg_RJ1
_check_rc $? "mkdir failed of /dev/vg_RJ1. Do you want to continue"
fi
chown root:sys /dev/vg_RJ1

# check the group file
if [[ -f /dev/vg_RJ1/group ]]; then
# read the nrs of existing group file
VGmajornr=$(ls -l /dev/vg_RJ1/group | awk '{print $5}')
VGminornr=$(ls -l /dev/vg_RJ1/group | awk '{print $6}')
[[ "$VGmajornr" != "64" ]] && _error "The requested major number (64) does not match found $VGmajornr"
[[ "$VGminornr" != "0x010000" ]] && _error "The requested minor nr (0x010000) does not match found $VGminornr"
_note "The /dev/vg_RJ1/group already existed with major nr ($VGmajornr) and minor nr ($VGminornr)"
else
_note "Exec: mknod /dev/vg_RJ1/group c 64 0x010000"
mknod /dev/vg_RJ1/group c 64 0x010000
_check_rc $? "mknod /dev/vg_RJ1/group failed. Do you want to continue"
_note "Created /dev/vg_RJ1/group with major nr (64) and minor nr (0x010000)"
fi

# check if minornr is unique
[[ $(ls -l /dev/*/group | grep "0x010000" | wc -l) -ne 1 ]] && _error "Sorry, the VG minor nr (0x010000) is not unique"

_note "vgcreate -l 255 -s 32 -p 255 -e 8000 -g PVG001 /dev/vg_RJ1 /dev/disk/disk67"
vgcreate -l 255 -s 32 -p 255 -e 8000 -g PVG001 /dev/vg_RJ1 /dev/disk/disk67
_check_rc $? "vgcreate of /dev/vg_RJ1 failed. Do you want to continue"

_note "Exec: vgextend -g PVG001 /dev/vg_RJ1 /dev/disk/disk55"
vgextend -g PVG001 /dev/vg_RJ1 /dev/disk/disk55
_check_rc $? "vgextend -g PVG001 /dev/vg_RJ1 /dev/disk/disk55 failed. Do you want to continue"

_note "Exec: vgextend -g PVG001 /dev/vg_RJ1 /dev/disk/disk32"
vgextend -g PVG001 /dev/vg_RJ1 /dev/disk/disk32
_check_rc $? "vgextend -g PVG001 /dev/vg_RJ1 /dev/disk/disk32 failed. Do you want to continue"

_note "Exec: vgextend -g PVG001 /dev/vg_RJ1 /dev/disk/disk8"
vgextend -g PVG001 /dev/vg_RJ1 /dev/disk/disk8
_check_rc $? "vgextend -g PVG001 /dev/vg_RJ1 /dev/disk/disk8 failed. Do you want to continue"

_note "Exec: vgextend -g PVG002 /dev/vg_RJ1 /dev/disk/disk48"
vgextend -g PVG002 /dev/vg_RJ1 /dev/disk/disk48
_check_rc $? "vgextend -g PVG002 /dev/vg_RJ1 /dev/disk/disk48 failed. Do you want to continue"

_note "Exec: vgextend -g PVG002 /dev/vg_RJ1 /dev/disk/disk33"
vgextend -g PVG002 /dev/vg_RJ1 /dev/disk/disk33
_check_rc $? "vgextend -g PVG002 /dev/vg_RJ1 /dev/disk/disk33 failed. Do you want to continue"

_note "Exec: vgextend -g PVG002 /dev/vg_RJ1 /dev/disk/disk28"
vgextend -g PVG002 /dev/vg_RJ1 /dev/disk/disk28
_check_rc $? "vgextend -g PVG002 /dev/vg_RJ1 /dev/disk/disk28 failed. Do you want to continue"

_note "Exec: vgextend -g PVG002 /dev/vg_RJ1 /dev/disk/disk45"
vgextend -g PVG002 /dev/vg_RJ1 /dev/disk/disk45
_check_rc $? "vgextend -g PVG002 /dev/vg_RJ1 /dev/disk/disk45 failed. Do you want to continue"

_note "Exec: vgextend -g PVG003 /dev/vg_RJ1 /dev/disk/disk69"
vgextend -g PVG003 /dev/vg_RJ1 /dev/disk/disk69
_check_rc $? "vgextend -g PVG003 /dev/vg_RJ1 /dev/disk/disk69 failed. Do you want to continue"

_note "Exec: vgextend -g PVG003 /dev/vg_RJ1 /dev/disk/disk56"
vgextend -g PVG003 /dev/vg_RJ1 /dev/disk/disk56
_check_rc $? "vgextend -g PVG003 /dev/vg_RJ1 /dev/disk/disk56 failed. Do you want to continue"

_note "Exec: vgextend -g PVG003 /dev/vg_RJ1 /dev/disk/disk51"
vgextend -g PVG003 /dev/vg_RJ1 /dev/disk/disk51
_check_rc $? "vgextend -g PVG003 /dev/vg_RJ1 /dev/disk/disk51 failed. Do you want to continue"

_note "Exec: vgextend -g PVG003 /dev/vg_RJ1 /dev/disk/disk10"
vgextend -g PVG003 /dev/vg_RJ1 /dev/disk/disk10
_check_rc $? "vgextend -g PVG003 /dev/vg_RJ1 /dev/disk/disk10 failed. Do you want to continue"

_note "Exec: vgextend -g PVG004 /dev/vg_RJ1 /dev/disk/disk74"
vgextend -g PVG004 /dev/vg_RJ1 /dev/disk/disk74
_check_rc $? "vgextend -g PVG004 /dev/vg_RJ1 /dev/disk/disk74 failed. Do you want to continue"

_note "Exec: vgextend -g PVG004 /dev/vg_RJ1 /dev/disk/disk47"
vgextend -g PVG004 /dev/vg_RJ1 /dev/disk/disk47
_check_rc $? "vgextend -g PVG004 /dev/vg_RJ1 /dev/disk/disk47 failed. Do you want to continue"

_note "Exec: vgextend -g PVG004 /dev/vg_RJ1 /dev/disk/disk62"
vgextend -g PVG004 /dev/vg_RJ1 /dev/disk/disk62
_check_rc $? "vgextend -g PVG004 /dev/vg_RJ1 /dev/disk/disk62 failed. Do you want to continue"

_note "Exec: vgextend -g PVG004 /dev/vg_RJ1 /dev/disk/disk59"
vgextend -g PVG004 /dev/vg_RJ1 /dev/disk/disk59
_check_rc $? "vgextend -g PVG004 /dev/vg_RJ1 /dev/disk/disk59 failed. Do you want to continue"

_note "Exec: vgextend  /dev/vg_RJ1 /dev/disk/disk36"
vgextend  /dev/vg_RJ1 /dev/disk/disk36
_check_rc $? "vgextend  /dev/vg_RJ1 /dev/disk/disk36 failed. Do you want to continue"

_note "Exec: vgextend  /dev/vg_RJ1 /dev/disk/disk54"
vgextend  /dev/vg_RJ1 /dev/disk/disk54
_check_rc $? "vgextend  /dev/vg_RJ1 /dev/disk/disk54 failed. Do you want to continue"

_note "Exec: vgextend  /dev/vg_RJ1 /dev/disk/disk24"
vgextend  /dev/vg_RJ1 /dev/disk/disk24
_check_rc $? "vgextend  /dev/vg_RJ1 /dev/disk/disk24 failed. Do you want to continue"

_note "Exec: vgextend  /dev/vg_RJ1 /dev/disk/disk20"
vgextend  /dev/vg_RJ1 /dev/disk/disk20
_check_rc $? "vgextend  /dev/vg_RJ1 /dev/disk/disk20 failed. Do you want to continue"

_note "Exec: vgextend  /dev/vg_RJ1 /dev/disk/disk60"
vgextend  /dev/vg_RJ1 /dev/disk/disk60
_check_rc $? "vgextend  /dev/vg_RJ1 /dev/disk/disk60 failed. Do you want to continue"

_note "Exec: vgextend  /dev/vg_RJ1 /dev/disk/disk7"
vgextend  /dev/vg_RJ1 /dev/disk/disk7
_check_rc $? "vgextend  /dev/vg_RJ1 /dev/disk/disk7 failed. Do you want to continue"

_note "Exec: vgextend  /dev/vg_RJ1 /dev/disk/disk6"
vgextend  /dev/vg_RJ1 /dev/disk/disk6
_check_rc $? "vgextend  /dev/vg_RJ1 /dev/disk/disk6 failed. Do you want to continue"

_note "Exec: vgextend  /dev/vg_RJ1 /dev/disk/disk23"
vgextend  /dev/vg_RJ1 /dev/disk/disk23
_check_rc $? "vgextend  /dev/vg_RJ1 /dev/disk/disk23 failed. Do you want to continue"

####### /dev/vg_ZR1 ######
# check dir
if [[ -d /dev/vg_ZR1 ]]; then
_note "Directory /dev/vg_ZR1 already exist"
else
_note "Exec: mkdir -p -m 755 /dev/vg_ZR1"
mkdir -p -m 755 /dev/vg_ZR1
_check_rc $? "mkdir failed of /dev/vg_ZR1. Do you want to continue"
fi
chown root:sys /dev/vg_ZR1

# check the group file
if [[ -f /dev/vg_ZR1/group ]]; then
# read the nrs of existing group file
VGmajornr=$(ls -l /dev/vg_ZR1/group | awk '{print $5}')
VGminornr=$(ls -l /dev/vg_ZR1/group | awk '{print $6}')
[[ "$VGmajornr" != "64" ]] && _error "The requested major number (64) does not match found $VGmajornr"
[[ "$VGminornr" != "0x020000" ]] && _error "The requested minor nr (0x020000) does not match found $VGminornr"
_note "The /dev/vg_ZR1/group already existed with major nr ($VGmajornr) and minor nr ($VGminornr)"
else
_note "Exec: mknod /dev/vg_ZR1/group c 64 0x020000"
mknod /dev/vg_ZR1/group c 64 0x020000
_check_rc $? "mknod /dev/vg_ZR1/group failed. Do you want to continue"
_note "Created /dev/vg_ZR1/group with major nr (64) and minor nr (0x020000)"
fi

# check if minornr is unique
[[ $(ls -l /dev/*/group | grep "0x020000" | wc -l) -ne 1 ]] && _error "Sorry, the VG minor nr (0x020000) is not unique"

_note "vgcreate -l 255 -s 32 -p 255 -e 8000  /dev/vg_ZR1 /dev/disk/disk53"
vgcreate -l 255 -s 32 -p 255 -e 8000  /dev/vg_ZR1 /dev/disk/disk53
_check_rc $? "vgcreate of /dev/vg_ZR1 failed. Do you want to continue"

_note "Exec: vgextend  /dev/vg_ZR1 /dev/disk/disk64"
vgextend  /dev/vg_ZR1 /dev/disk/disk64
_check_rc $? "vgextend  /dev/vg_ZR1 /dev/disk/disk64 failed. Do you want to continue"

####### /dev/vg_RJ7 ######
# check dir
if [[ -d /dev/vg_RJ7 ]]; then
_note "Directory /dev/vg_RJ7 already exist"
else
_note "Exec: mkdir -p -m 755 /dev/vg_RJ7"
mkdir -p -m 755 /dev/vg_RJ7
_check_rc $? "mkdir failed of /dev/vg_RJ7. Do you want to continue"
fi
chown root:sys /dev/vg_RJ7

# check the group file
if [[ -f /dev/vg_RJ7/group ]]; then
# read the nrs of existing group file
VGmajornr=$(ls -l /dev/vg_RJ7/group | awk '{print $5}')
VGminornr=$(ls -l /dev/vg_RJ7/group | awk '{print $6}')
[[ "$VGmajornr" != "64" ]] && _error "The requested major number (64) does not match found $VGmajornr"
[[ "$VGminornr" != "0x030000" ]] && _error "The requested minor nr (0x030000) does not match found $VGminornr"
_note "The /dev/vg_RJ7/group already existed with major nr ($VGmajornr) and minor nr ($VGminornr)"
else
_note "Exec: mknod /dev/vg_RJ7/group c 64 0x030000"
mknod /dev/vg_RJ7/group c 64 0x030000
_check_rc $? "mknod /dev/vg_RJ7/group failed. Do you want to continue"
_note "Created /dev/vg_RJ7/group with major nr (64) and minor nr (0x030000)"
fi

# check if minornr is unique
[[ $(ls -l /dev/*/group | grep "0x030000" | wc -l) -ne 1 ]] && _error "Sorry, the VG minor nr (0x030000) is not unique"

_note "vgcreate -l 255 -s 32 -p 255 -e 8000 -g PVG001 /dev/vg_RJ7 /dev/disk/disk18"
vgcreate -l 255 -s 32 -p 255 -e 8000 -g PVG001 /dev/vg_RJ7 /dev/disk/disk18
_check_rc $? "vgcreate of /dev/vg_RJ7 failed. Do you want to continue"

_note "Exec: vgextend -g PVG001 /dev/vg_RJ7 /dev/disk/disk58"
vgextend -g PVG001 /dev/vg_RJ7 /dev/disk/disk58
_check_rc $? "vgextend -g PVG001 /dev/vg_RJ7 /dev/disk/disk58 failed. Do you want to continue"

_note "Exec: vgextend -g PVG001 /dev/vg_RJ7 /dev/disk/disk49"
vgextend -g PVG001 /dev/vg_RJ7 /dev/disk/disk49
_check_rc $? "vgextend -g PVG001 /dev/vg_RJ7 /dev/disk/disk49 failed. Do you want to continue"

_note "Exec: vgextend -g PVG001 /dev/vg_RJ7 /dev/disk/disk50"
vgextend -g PVG001 /dev/vg_RJ7 /dev/disk/disk50
_check_rc $? "vgextend -g PVG001 /dev/vg_RJ7 /dev/disk/disk50 failed. Do you want to continue"

_note "Exec: vgextend  /dev/vg_RJ7 /dev/disk/disk14"
vgextend  /dev/vg_RJ7 /dev/disk/disk14
_check_rc $? "vgextend  /dev/vg_RJ7 /dev/disk/disk14 failed. Do you want to continue"

_note "Exec: vgextend  /dev/vg_RJ7 /dev/disk/disk66"
vgextend  /dev/vg_RJ7 /dev/disk/disk66
_check_rc $? "vgextend  /dev/vg_RJ7 /dev/disk/disk66 failed. Do you want to continue"

_note "Exec: vgextend  /dev/vg_RJ7 /dev/disk/disk61"
vgextend  /dev/vg_RJ7 /dev/disk/disk61
_check_rc $? "vgextend  /dev/vg_RJ7 /dev/disk/disk61 failed. Do you want to continue"

_note "Exec: vgextend  /dev/vg_RJ7 /dev/disk/disk27"
vgextend  /dev/vg_RJ7 /dev/disk/disk27
_check_rc $? "vgextend  /dev/vg_RJ7 /dev/disk/disk27 failed. Do you want to continue"

_note "Exec: vgextend  /dev/vg_RJ7 /dev/disk/disk44"
vgextend  /dev/vg_RJ7 /dev/disk/disk44
_check_rc $? "vgextend  /dev/vg_RJ7 /dev/disk/disk44 failed. Do you want to continue"

_note "Exec: vgextend  /dev/vg_RJ7 /dev/disk/disk26"
vgextend  /dev/vg_RJ7 /dev/disk/disk26
_check_rc $? "vgextend  /dev/vg_RJ7 /dev/disk/disk26 failed. Do you want to continue"

_note "Exec: vgextend  /dev/vg_RJ7 /dev/disk/disk40"
vgextend  /dev/vg_RJ7 /dev/disk/disk40
_check_rc $? "vgextend  /dev/vg_RJ7 /dev/disk/disk40 failed. Do you want to continue"

_note "Exec: vgextend  /dev/vg_RJ7 /dev/disk/disk65"
vgextend  /dev/vg_RJ7 /dev/disk/disk65
_check_rc $? "vgextend  /dev/vg_RJ7 /dev/disk/disk65 failed. Do you want to continue"

####### /dev/vg_sap ######
# check dir
if [[ -d /dev/vg_sap ]]; then
_note "Directory /dev/vg_sap already exist"
else
_note "Exec: mkdir -p -m 755 /dev/vg_sap"
mkdir -p -m 755 /dev/vg_sap
_check_rc $? "mkdir failed of /dev/vg_sap. Do you want to continue"
fi
chown root:sys /dev/vg_sap

# check the group file
if [[ -f /dev/vg_sap/group ]]; then
# read the nrs of existing group file
VGmajornr=$(ls -l /dev/vg_sap/group | awk '{print $5}')
VGminornr=$(ls -l /dev/vg_sap/group | awk '{print $6}')
[[ "$VGmajornr" != "64" ]] && _error "The requested major number (64) does not match found $VGmajornr"
[[ "$VGminornr" != "0x040000" ]] && _error "The requested minor nr (0x040000) does not match found $VGminornr"
_note "The /dev/vg_sap/group already existed with major nr ($VGmajornr) and minor nr ($VGminornr)"
else
_note "Exec: mknod /dev/vg_sap/group c 64 0x040000"
mknod /dev/vg_sap/group c 64 0x040000
_check_rc $? "mknod /dev/vg_sap/group failed. Do you want to continue"
_note "Created /dev/vg_sap/group with major nr (64) and minor nr (0x040000)"
fi

# check if minornr is unique
[[ $(ls -l /dev/*/group | grep "0x040000" | wc -l) -ne 1 ]] && _error "Sorry, the VG minor nr (0x040000) is not unique"

_note "vgcreate -l 255 -s 32 -p 255 -e 8000  /dev/vg_sap /dev/disk/disk52"
vgcreate -l 255 -s 32 -p 255 -e 8000  /dev/vg_sap /dev/disk/disk52
_check_rc $? "vgcreate of /dev/vg_sap failed. Do you want to continue"

_note "Exec: vgextend  /dev/vg_sap /dev/disk/disk72"
vgextend  /dev/vg_sap /dev/disk/disk72
_check_rc $? "vgextend  /dev/vg_sap /dev/disk/disk72 failed. Do you want to continue"

####### /dev/vg_oracle ######
# check dir
if [[ -d /dev/vg_oracle ]]; then
_note "Directory /dev/vg_oracle already exist"
else
_note "Exec: mkdir -p -m 755 /dev/vg_oracle"
mkdir -p -m 755 /dev/vg_oracle
_check_rc $? "mkdir failed of /dev/vg_oracle. Do you want to continue"
fi
chown root:sys /dev/vg_oracle

# check the group file
if [[ -f /dev/vg_oracle/group ]]; then
# read the nrs of existing group file
VGmajornr=$(ls -l /dev/vg_oracle/group | awk '{print $5}')
VGminornr=$(ls -l /dev/vg_oracle/group | awk '{print $6}')
[[ "$VGmajornr" != "64" ]] && _error "The requested major number (64) does not match found $VGmajornr"
[[ "$VGminornr" != "0x050000" ]] && _error "The requested minor nr (0x050000) does not match found $VGminornr"
_note "The /dev/vg_oracle/group already existed with major nr ($VGmajornr) and minor nr ($VGminornr)"
else
_note "Exec: mknod /dev/vg_oracle/group c 64 0x050000"
mknod /dev/vg_oracle/group c 64 0x050000
_check_rc $? "mknod /dev/vg_oracle/group failed. Do you want to continue"
_note "Created /dev/vg_oracle/group with major nr (64) and minor nr (0x050000)"
fi

# check if minornr is unique
[[ $(ls -l /dev/*/group | grep "0x050000" | wc -l) -ne 1 ]] && _error "Sorry, the VG minor nr (0x050000) is not unique"

_note "vgcreate -l 255 -s 32 -p 255 -e 8000  /dev/vg_oracle /dev/disk/disk41"
vgcreate -l 255 -s 32 -p 255 -e 8000  /dev/vg_oracle /dev/disk/disk41
_check_rc $? "vgcreate of /dev/vg_oracle failed. Do you want to continue"

_note "Exec: vgextend  /dev/vg_oracle /dev/disk/disk57"
vgextend  /dev/vg_oracle /dev/disk/disk57
_check_rc $? "vgextend  /dev/vg_oracle /dev/disk/disk57 failed. Do you want to continue"

####### /dev/vg_openv ######
# check dir
if [[ -d /dev/vg_openv ]]; then
_note "Directory /dev/vg_openv already exist"
else
_note "Exec: mkdir -p -m 755 /dev/vg_openv"
mkdir -p -m 755 /dev/vg_openv
_check_rc $? "mkdir failed of /dev/vg_openv. Do you want to continue"
fi
chown root:sys /dev/vg_openv

# check the group file
if [[ -f /dev/vg_openv/group ]]; then
# read the nrs of existing group file
VGmajornr=$(ls -l /dev/vg_openv/group | awk '{print $5}')
VGminornr=$(ls -l /dev/vg_openv/group | awk '{print $6}')
[[ "$VGmajornr" != "64" ]] && _error "The requested major number (64) does not match found $VGmajornr"
[[ "$VGminornr" != "0x060000" ]] && _error "The requested minor nr (0x060000) does not match found $VGminornr"
_note "The /dev/vg_openv/group already existed with major nr ($VGmajornr) and minor nr ($VGminornr)"
else
_note "Exec: mknod /dev/vg_openv/group c 64 0x060000"
mknod /dev/vg_openv/group c 64 0x060000
_check_rc $? "mknod /dev/vg_openv/group failed. Do you want to continue"
_note "Created /dev/vg_openv/group with major nr (64) and minor nr (0x060000)"
fi

# check if minornr is unique
[[ $(ls -l /dev/*/group | grep "0x060000" | wc -l) -ne 1 ]] && _error "Sorry, the VG minor nr (0x060000) is not unique"

_note "vgcreate -l 255 -s 32 -p 255 -e 8000  /dev/vg_openv /dev/disk/disk39"
vgcreate -l 255 -s 32 -p 255 -e 8000  /dev/vg_openv /dev/disk/disk39
_check_rc $? "vgcreate of /dev/vg_openv failed. Do you want to continue"

_note "Exec: vgextend  /dev/vg_openv /dev/disk/disk71"
vgextend  /dev/vg_openv /dev/disk/disk71
_check_rc $? "vgextend  /dev/vg_openv /dev/disk/disk71 failed. Do you want to continue"

_note "Exec: lvcreate  -D y -s g -n lv_oracleRJ1_sapdata1 /dev/vg_RJ1"
lvcreate  -D y -s g -n lv_oracleRJ1_sapdata1 /dev/vg_RJ1
_check_rc $? "lvcreate failed of /dev/vg_RJ1/lv_oracleRJ1_sapdata1. Do you want to continue"

_note "Exec: lvextend -l 24000 /dev/vg_RJ1/lv_oracleRJ1_sapdata1 PVG001"
lvextend -l 24000 /dev/vg_RJ1/lv_oracleRJ1_sapdata1 PVG001
_check_rc $? "lvextend failed of /dev/vg_RJ1/lv_oracleRJ1_sapdata1. Do you want to continue"

_note "Exec: lvcreate  -D y -s g -n lv_oracleRJ1_sapdata2 /dev/vg_RJ1"
lvcreate  -D y -s g -n lv_oracleRJ1_sapdata2 /dev/vg_RJ1
_check_rc $? "lvcreate failed of /dev/vg_RJ1/lv_oracleRJ1_sapdata2. Do you want to continue"

_note "Exec: lvextend -l 24000 /dev/vg_RJ1/lv_oracleRJ1_sapdata2 PVG002"
lvextend -l 24000 /dev/vg_RJ1/lv_oracleRJ1_sapdata2 PVG002
_check_rc $? "lvextend failed of /dev/vg_RJ1/lv_oracleRJ1_sapdata2. Do you want to continue"

_note "Exec: lvcreate  -D y -s g -n lv_oracleRJ1_sapdata3 /dev/vg_RJ1"
lvcreate  -D y -s g -n lv_oracleRJ1_sapdata3 /dev/vg_RJ1
_check_rc $? "lvcreate failed of /dev/vg_RJ1/lv_oracleRJ1_sapdata3. Do you want to continue"

_note "Exec: lvextend -l 24000 /dev/vg_RJ1/lv_oracleRJ1_sapdata3 PVG003"
lvextend -l 24000 /dev/vg_RJ1/lv_oracleRJ1_sapdata3 PVG003
_check_rc $? "lvextend failed of /dev/vg_RJ1/lv_oracleRJ1_sapdata3. Do you want to continue"

_note "Exec: lvcreate  -D y -s g -n lv_oracleRJ1_sapdata4 /dev/vg_RJ1"
lvcreate  -D y -s g -n lv_oracleRJ1_sapdata4 /dev/vg_RJ1
_check_rc $? "lvcreate failed of /dev/vg_RJ1/lv_oracleRJ1_sapdata4. Do you want to continue"

_note "Exec: lvextend -l 24000 /dev/vg_RJ1/lv_oracleRJ1_sapdata4 PVG004"
lvextend -l 24000 /dev/vg_RJ1/lv_oracleRJ1_sapdata4 PVG004
_check_rc $? "lvextend failed of /dev/vg_RJ1/lv_oracleRJ1_sapdata4. Do you want to continue"

_note "Exec: lvcreate  -n lv_oracleRJ1_origlogB /dev/vg_RJ1"
lvcreate  -n lv_oracleRJ1_origlogB /dev/vg_RJ1
_check_rc $? "lvcreate failed of /dev/vg_RJ1/lv_oracleRJ1_origlogB. Do you want to continue"

_note "Exec: lvextend -l 125 /dev/vg_RJ1/lv_oracleRJ1_origlogB "
lvextend -l 125 /dev/vg_RJ1/lv_oracleRJ1_origlogB
_check_rc $? "lvextend failed of /dev/vg_RJ1/lv_oracleRJ1_origlogB. Do you want to continue"

_note "Exec: lvcreate  -n lv_oracleRJ1_origlogA /dev/vg_RJ1"
lvcreate  -n lv_oracleRJ1_origlogA /dev/vg_RJ1
_check_rc $? "lvcreate failed of /dev/vg_RJ1/lv_oracleRJ1_origlogA. Do you want to continue"

_note "Exec: lvextend -l 125 /dev/vg_RJ1/lv_oracleRJ1_origlogA "
lvextend -l 125 /dev/vg_RJ1/lv_oracleRJ1_origlogA
_check_rc $? "lvextend failed of /dev/vg_RJ1/lv_oracleRJ1_origlogA. Do you want to continue"

_note "Exec: lvcreate  -n lv_oracleRJ1_oraarch /dev/vg_RJ1"
lvcreate  -n lv_oracleRJ1_oraarch /dev/vg_RJ1
_check_rc $? "lvcreate failed of /dev/vg_RJ1/lv_oracleRJ1_oraarch. Do you want to continue"

_note "Exec: lvextend -l 3168 /dev/vg_RJ1/lv_oracleRJ1_oraarch "
lvextend -l 3168 /dev/vg_RJ1/lv_oracleRJ1_oraarch
_check_rc $? "lvextend failed of /dev/vg_RJ1/lv_oracleRJ1_oraarch. Do you want to continue"

_note "Exec: lvcreate  -n lv_oracleRJ1_mirrlogB /dev/vg_RJ1"
lvcreate  -n lv_oracleRJ1_mirrlogB /dev/vg_RJ1
_check_rc $? "lvcreate failed of /dev/vg_RJ1/lv_oracleRJ1_mirrlogB. Do you want to continue"

_note "Exec: lvextend -l 125 /dev/vg_RJ1/lv_oracleRJ1_mirrlogB "
lvextend -l 125 /dev/vg_RJ1/lv_oracleRJ1_mirrlogB
_check_rc $? "lvextend failed of /dev/vg_RJ1/lv_oracleRJ1_mirrlogB. Do you want to continue"

_note "Exec: lvcreate  -n lv_oracleRJ1_mirrlogA /dev/vg_RJ1"
lvcreate  -n lv_oracleRJ1_mirrlogA /dev/vg_RJ1
_check_rc $? "lvcreate failed of /dev/vg_RJ1/lv_oracleRJ1_mirrlogA. Do you want to continue"

_note "Exec: lvextend -l 125 /dev/vg_RJ1/lv_oracleRJ1_mirrlogA "
lvextend -l 125 /dev/vg_RJ1/lv_oracleRJ1_mirrlogA
_check_rc $? "lvextend failed of /dev/vg_RJ1/lv_oracleRJ1_mirrlogA. Do you want to continue"

_note "Exec: lvcreate  -n lv_exportsapmnt_RJ1 /dev/vg_RJ1"
lvcreate  -n lv_exportsapmnt_RJ1 /dev/vg_RJ1
_check_rc $? "lvcreate failed of /dev/vg_RJ1/lv_exportsapmnt_RJ1. Do you want to continue"

_note "Exec: lvextend -l 608 /dev/vg_RJ1/lv_exportsapmnt_RJ1 "
lvextend -l 608 /dev/vg_RJ1/lv_exportsapmnt_RJ1
_check_rc $? "lvextend failed of /dev/vg_RJ1/lv_exportsapmnt_RJ1. Do you want to continue"

_note "Exec: lvcreate  -n lv_usrsapRJ1_DVEBMGS19 /dev/vg_RJ1"
lvcreate  -n lv_usrsapRJ1_DVEBMGS19 /dev/vg_RJ1
_check_rc $? "lvcreate failed of /dev/vg_RJ1/lv_usrsapRJ1_DVEBMGS19. Do you want to continue"

_note "Exec: lvextend -l 608 /dev/vg_RJ1/lv_usrsapRJ1_DVEBMGS19 "
lvextend -l 608 /dev/vg_RJ1/lv_usrsapRJ1_DVEBMGS19
_check_rc $? "lvextend failed of /dev/vg_RJ1/lv_usrsapRJ1_DVEBMGS19. Do you want to continue"

_note "Exec: lvcreate  -n lv_exportoracleRJ1_sapbackup /dev/vg_RJ1"
lvcreate  -n lv_exportoracleRJ1_sapbackup /dev/vg_RJ1
_check_rc $? "lvcreate failed of /dev/vg_RJ1/lv_exportoracleRJ1_sapbackup. Do you want to continue"

_note "Exec: lvextend -l 608 /dev/vg_RJ1/lv_exportoracleRJ1_sapbackup "
lvextend -l 608 /dev/vg_RJ1/lv_exportoracleRJ1_sapbackup
_check_rc $? "lvextend failed of /dev/vg_RJ1/lv_exportoracleRJ1_sapbackup. Do you want to continue"

_note "Exec: lvcreate  -n lv_usrsapRJ1_ASCS05 /dev/vg_RJ1"
lvcreate  -n lv_usrsapRJ1_ASCS05 /dev/vg_RJ1
_check_rc $? "lvcreate failed of /dev/vg_RJ1/lv_usrsapRJ1_ASCS05. Do you want to continue"

_note "Exec: lvextend -l 313 /dev/vg_RJ1/lv_usrsapRJ1_ASCS05 "
lvextend -l 313 /dev/vg_RJ1/lv_usrsapRJ1_ASCS05
_check_rc $? "lvextend failed of /dev/vg_RJ1/lv_usrsapRJ1_ASCS05. Do you want to continue"

_note "Exec: lvcreate  -n lv_oracle_RJ1 /dev/vg_RJ1"
lvcreate  -n lv_oracle_RJ1 /dev/vg_RJ1
_check_rc $? "lvcreate failed of /dev/vg_RJ1/lv_oracle_RJ1. Do you want to continue"

_note "Exec: lvextend -l 625 /dev/vg_RJ1/lv_oracle_RJ1 "
lvextend -l 625 /dev/vg_RJ1/lv_oracle_RJ1
_check_rc $? "lvextend failed of /dev/vg_RJ1/lv_oracle_RJ1. Do you want to continue"

_note "Exec: lvcreate  -n lv_oracleRJ1_112_64 /dev/vg_RJ1"
lvcreate  -n lv_oracleRJ1_112_64 /dev/vg_RJ1
_check_rc $? "lvcreate failed of /dev/vg_RJ1/lv_oracleRJ1_112_64. Do you want to continue"

_note "Exec: lvextend -l 625 /dev/vg_RJ1/lv_oracleRJ1_112_64 "
lvextend -l 625 /dev/vg_RJ1/lv_oracleRJ1_112_64
_check_rc $? "lvextend failed of /dev/vg_RJ1/lv_oracleRJ1_112_64. Do you want to continue"

_note "Exec: lvcreate  -n lv_oracleRJ1_sapreorg /dev/vg_RJ1"
lvcreate  -n lv_oracleRJ1_sapreorg /dev/vg_RJ1
_check_rc $? "lvcreate failed of /dev/vg_RJ1/lv_oracleRJ1_sapreorg. Do you want to continue"

_note "Exec: lvextend -l 625 /dev/vg_RJ1/lv_oracleRJ1_sapreorg "
lvextend -l 625 /dev/vg_RJ1/lv_oracleRJ1_sapreorg
_check_rc $? "lvextend failed of /dev/vg_RJ1/lv_oracleRJ1_sapreorg. Do you want to continue"

_note "Exec: lvcreate  -n lv_sapmnt_ZR1 /dev/vg_ZR1"
lvcreate  -n lv_sapmnt_ZR1 /dev/vg_ZR1
_check_rc $? "lvcreate failed of /dev/vg_ZR1/lv_sapmnt_ZR1. Do you want to continue"

_note "Exec: lvextend -l 256 /dev/vg_ZR1/lv_sapmnt_ZR1 "
lvextend -l 256 /dev/vg_ZR1/lv_sapmnt_ZR1
_check_rc $? "lvextend failed of /dev/vg_ZR1/lv_sapmnt_ZR1. Do you want to continue"

_note "Exec: lvcreate  -n lv_usrsap_ZR1 /dev/vg_ZR1"
lvcreate  -n lv_usrsap_ZR1 /dev/vg_ZR1
_check_rc $? "lvcreate failed of /dev/vg_ZR1/lv_usrsap_ZR1. Do you want to continue"

_note "Exec: lvextend -l 125 /dev/vg_ZR1/lv_usrsap_ZR1 "
lvextend -l 125 /dev/vg_ZR1/lv_usrsap_ZR1
_check_rc $? "lvextend failed of /dev/vg_ZR1/lv_usrsap_ZR1. Do you want to continue"

_note "Exec: lvcreate  -D y -s g -n lv_oracleRJ7_sapdata1 /dev/vg_RJ7"
lvcreate  -D y -s g -n lv_oracleRJ7_sapdata1 /dev/vg_RJ7
_check_rc $? "lvcreate failed of /dev/vg_RJ7/lv_oracleRJ7_sapdata1. Do you want to continue"

_note "Exec: lvextend -l 3168 /dev/vg_RJ7/lv_oracleRJ7_sapdata1 PVG001"
lvextend -l 3168 /dev/vg_RJ7/lv_oracleRJ7_sapdata1 PVG001
_check_rc $? "lvextend failed of /dev/vg_RJ7/lv_oracleRJ7_sapdata1. Do you want to continue"

_note "Exec: lvcreate  -D y -s g -n lv_oracleRJ7_sapdata2 /dev/vg_RJ7"
lvcreate  -D y -s g -n lv_oracleRJ7_sapdata2 /dev/vg_RJ7
_check_rc $? "lvcreate failed of /dev/vg_RJ7/lv_oracleRJ7_sapdata2. Do you want to continue"

_note "Exec: lvextend -l 3168 /dev/vg_RJ7/lv_oracleRJ7_sapdata2 PVG001"
lvextend -l 3168 /dev/vg_RJ7/lv_oracleRJ7_sapdata2 PVG001
_check_rc $? "lvextend failed of /dev/vg_RJ7/lv_oracleRJ7_sapdata2. Do you want to continue"

_note "Exec: lvcreate  -n lv_oracleRJ7_origlogA /dev/vg_RJ7"
lvcreate  -n lv_oracleRJ7_origlogA /dev/vg_RJ7
_check_rc $? "lvcreate failed of /dev/vg_RJ7/lv_oracleRJ7_origlogA. Do you want to continue"

_note "Exec: lvextend -l 64 /dev/vg_RJ7/lv_oracleRJ7_origlogA "
lvextend -l 64 /dev/vg_RJ7/lv_oracleRJ7_origlogA
_check_rc $? "lvextend failed of /dev/vg_RJ7/lv_oracleRJ7_origlogA. Do you want to continue"

_note "Exec: lvcreate  -n lv_oracleRJ7_origlogB /dev/vg_RJ7"
lvcreate  -n lv_oracleRJ7_origlogB /dev/vg_RJ7
_check_rc $? "lvcreate failed of /dev/vg_RJ7/lv_oracleRJ7_origlogB. Do you want to continue"

_note "Exec: lvextend -l 63 /dev/vg_RJ7/lv_oracleRJ7_origlogB "
lvextend -l 63 /dev/vg_RJ7/lv_oracleRJ7_origlogB
_check_rc $? "lvextend failed of /dev/vg_RJ7/lv_oracleRJ7_origlogB. Do you want to continue"

_note "Exec: lvcreate  -n lv_oracleRJ7_mirrlogA /dev/vg_RJ7"
lvcreate  -n lv_oracleRJ7_mirrlogA /dev/vg_RJ7
_check_rc $? "lvcreate failed of /dev/vg_RJ7/lv_oracleRJ7_mirrlogA. Do you want to continue"

_note "Exec: lvextend -l 63 /dev/vg_RJ7/lv_oracleRJ7_mirrlogA "
lvextend -l 63 /dev/vg_RJ7/lv_oracleRJ7_mirrlogA
_check_rc $? "lvextend failed of /dev/vg_RJ7/lv_oracleRJ7_mirrlogA. Do you want to continue"

_note "Exec: lvcreate  -n lv_oracleRJ7_mirrlogB /dev/vg_RJ7"
lvcreate  -n lv_oracleRJ7_mirrlogB /dev/vg_RJ7
_check_rc $? "lvcreate failed of /dev/vg_RJ7/lv_oracleRJ7_mirrlogB. Do you want to continue"

_note "Exec: lvextend -l 63 /dev/vg_RJ7/lv_oracleRJ7_mirrlogB "
lvextend -l 63 /dev/vg_RJ7/lv_oracleRJ7_mirrlogB
_check_rc $? "lvextend failed of /dev/vg_RJ7/lv_oracleRJ7_mirrlogB. Do you want to continue"

_note "Exec: lvcreate  -n lv_oracleRJ7_102_64 /dev/vg_RJ7"
lvcreate  -n lv_oracleRJ7_102_64 /dev/vg_RJ7
_check_rc $? "lvcreate failed of /dev/vg_RJ7/lv_oracleRJ7_102_64. Do you want to continue"

_note "Exec: lvextend -l 313 /dev/vg_RJ7/lv_oracleRJ7_102_64 "
lvextend -l 313 /dev/vg_RJ7/lv_oracleRJ7_102_64
_check_rc $? "lvextend failed of /dev/vg_RJ7/lv_oracleRJ7_102_64. Do you want to continue"

_note "Exec: lvcreate  -n lv_oracleRJ7_oraarch /dev/vg_RJ7"
lvcreate  -n lv_oracleRJ7_oraarch /dev/vg_RJ7
_check_rc $? "lvcreate failed of /dev/vg_RJ7/lv_oracleRJ7_oraarch. Do you want to continue"

_note "Exec: lvextend -l 313 /dev/vg_RJ7/lv_oracleRJ7_oraarch "
lvextend -l 313 /dev/vg_RJ7/lv_oracleRJ7_oraarch
_check_rc $? "lvextend failed of /dev/vg_RJ7/lv_oracleRJ7_oraarch. Do you want to continue"

_note "Exec: lvcreate  -n lv_oracleRJ7_sapbackup /dev/vg_RJ7"
lvcreate  -n lv_oracleRJ7_sapbackup /dev/vg_RJ7
_check_rc $? "lvcreate failed of /dev/vg_RJ7/lv_oracleRJ7_sapbackup. Do you want to continue"

_note "Exec: lvextend -l 313 /dev/vg_RJ7/lv_oracleRJ7_sapbackup "
lvextend -l 313 /dev/vg_RJ7/lv_oracleRJ7_sapbackup
_check_rc $? "lvextend failed of /dev/vg_RJ7/lv_oracleRJ7_sapbackup. Do you want to continue"

_note "Exec: lvcreate  -n lv_oracleRJ7_saparch /dev/vg_RJ7"
lvcreate  -n lv_oracleRJ7_saparch /dev/vg_RJ7
_check_rc $? "lvcreate failed of /dev/vg_RJ7/lv_oracleRJ7_saparch. Do you want to continue"

_note "Exec: lvextend -l 313 /dev/vg_RJ7/lv_oracleRJ7_saparch "
lvextend -l 313 /dev/vg_RJ7/lv_oracleRJ7_saparch
_check_rc $? "lvextend failed of /dev/vg_RJ7/lv_oracleRJ7_saparch. Do you want to continue"

_note "Exec: lvcreate  -n lv_oracleRJ7_RJ7 /dev/vg_RJ7"
lvcreate  -n lv_oracleRJ7_RJ7 /dev/vg_RJ7
_check_rc $? "lvcreate failed of /dev/vg_RJ7/lv_oracleRJ7_RJ7. Do you want to continue"

_note "Exec: lvextend -l 64 /dev/vg_RJ7/lv_oracleRJ7_RJ7 "
lvextend -l 64 /dev/vg_RJ7/lv_oracleRJ7_RJ7
_check_rc $? "lvextend failed of /dev/vg_RJ7/lv_oracleRJ7_RJ7. Do you want to continue"

_note "Exec: lvcreate  -n lv_usr_sap /dev/vg_sap"
lvcreate  -n lv_usr_sap /dev/vg_sap
_check_rc $? "lvcreate failed of /dev/vg_sap/lv_usr_sap. Do you want to continue"

_note "Exec: lvextend -l 313 /dev/vg_sap/lv_usr_sap "
lvextend -l 313 /dev/vg_sap/lv_usr_sap
_check_rc $? "lvextend failed of /dev/vg_sap/lv_usr_sap. Do you want to continue"

_note "Exec: lvcreate  -n lv_usrsap_SMD /dev/vg_sap"
lvcreate  -n lv_usrsap_SMD /dev/vg_sap
_check_rc $? "lvcreate failed of /dev/vg_sap/lv_usrsap_SMD. Do you want to continue"

_note "Exec: lvextend -l 64 /dev/vg_sap/lv_usrsap_SMD "
lvextend -l 64 /dev/vg_sap/lv_usrsap_SMD
_check_rc $? "lvextend failed of /dev/vg_sap/lv_usrsap_SMD. Do you want to continue"

_note "Exec: lvcreate  -n lv_usrsapRJ1_ERS05 /dev/vg_sap"
lvcreate  -n lv_usrsapRJ1_ERS05 /dev/vg_sap
_check_rc $? "lvcreate failed of /dev/vg_sap/lv_usrsapRJ1_ERS05. Do you want to continue"

_note "Exec: lvextend -l 313 /dev/vg_sap/lv_usrsapRJ1_ERS05 "
lvextend -l 313 /dev/vg_sap/lv_usrsapRJ1_ERS05
_check_rc $? "lvextend failed of /dev/vg_sap/lv_usrsapRJ1_ERS05. Do you want to continue"

_note "Exec: lvcreate  -n lv_usrsapRJ6_ERS25 /dev/vg_sap"
lvcreate  -n lv_usrsapRJ6_ERS25 /dev/vg_sap
_check_rc $? "lvcreate failed of /dev/vg_sap/lv_usrsapRJ6_ERS25. Do you want to continue"

_note "Exec: lvextend -l 313 /dev/vg_sap/lv_usrsapRJ6_ERS25 "
lvextend -l 313 /dev/vg_sap/lv_usrsapRJ6_ERS25
_check_rc $? "lvextend failed of /dev/vg_sap/lv_usrsapRJ6_ERS25. Do you want to continue"

_note "Exec: lvcreate  -n lv_usrsapSMD_J97 /dev/vg_sap"
lvcreate  -n lv_usrsapSMD_J97 /dev/vg_sap
_check_rc $? "lvcreate failed of /dev/vg_sap/lv_usrsapSMD_J97. Do you want to continue"

_note "Exec: lvextend -l 125 /dev/vg_sap/lv_usrsapSMD_J97 "
lvextend -l 125 /dev/vg_sap/lv_usrsapSMD_J97
_check_rc $? "lvextend failed of /dev/vg_sap/lv_usrsapSMD_J97. Do you want to continue"

_note "Exec: lvcreate  -n lv_usrsapSMD_J98 /dev/vg_sap"
lvcreate  -n lv_usrsapSMD_J98 /dev/vg_sap
_check_rc $? "lvcreate failed of /dev/vg_sap/lv_usrsapSMD_J98. Do you want to continue"

_note "Exec: lvextend -l 125 /dev/vg_sap/lv_usrsapSMD_J98 "
lvextend -l 125 /dev/vg_sap/lv_usrsapSMD_J98
_check_rc $? "lvextend failed of /dev/vg_sap/lv_usrsapSMD_J98. Do you want to continue"

_note "Exec: lvcreate  -n lv_sapmnt /dev/vg_sap"
lvcreate  -n lv_sapmnt /dev/vg_sap
_check_rc $? "lvcreate failed of /dev/vg_sap/lv_sapmnt. Do you want to continue"

_note "Exec: lvextend -l 125 /dev/vg_sap/lv_sapmnt "
lvextend -l 125 /dev/vg_sap/lv_sapmnt
_check_rc $? "lvextend failed of /dev/vg_sap/lv_sapmnt. Do you want to continue"

_note "Exec: lvcreate  -n lv_oracle /dev/vg_oracle"
lvcreate  -n lv_oracle /dev/vg_oracle
_check_rc $? "lvcreate failed of /dev/vg_oracle/lv_oracle. Do you want to continue"

_note "Exec: lvextend -l 625 /dev/vg_oracle/lv_oracle "
lvextend -l 625 /dev/vg_oracle/lv_oracle
_check_rc $? "lvextend failed of /dev/vg_oracle/lv_oracle. Do you want to continue"

_note "Exec: lvcreate  -n lv_oracle_stage /dev/vg_oracle"
lvcreate  -n lv_oracle_stage /dev/vg_oracle
_check_rc $? "lvcreate failed of /dev/vg_oracle/lv_oracle_stage. Do you want to continue"

_note "Exec: lvextend -l 938 /dev/vg_oracle/lv_oracle_stage "
lvextend -l 938 /dev/vg_oracle/lv_oracle_stage
_check_rc $? "lvextend failed of /dev/vg_oracle/lv_oracle_stage. Do you want to continue"

_note "Exec: lvcreate  -n lv_oracle_client /dev/vg_oracle"
lvcreate  -n lv_oracle_client /dev/vg_oracle
_check_rc $? "lvcreate failed of /dev/vg_oracle/lv_oracle_client. Do you want to continue"

_note "Exec: lvextend -l 157 /dev/vg_oracle/lv_oracle_client "
lvextend -l 157 /dev/vg_oracle/lv_oracle_client
_check_rc $? "lvextend failed of /dev/vg_oracle/lv_oracle_client. Do you want to continue"

_note "Exec: lvcreate  -n lv_usr_openv /dev/vg_openv"
lvcreate  -n lv_usr_openv /dev/vg_openv
_check_rc $? "lvcreate failed of /dev/vg_openv/lv_usr_openv. Do you want to continue"

_note "Exec: lvextend -l 625 /dev/vg_openv/lv_usr_openv "
lvextend -l 625 /dev/vg_openv/lv_usr_openv
_check_rc $? "lvextend failed of /dev/vg_openv/lv_usr_openv. Do you want to continue"

_note "Exec: lvcreate  -n lv_usropenvnetbackup_logs /dev/vg_openv"
lvcreate  -n lv_usropenvnetbackup_logs /dev/vg_openv
_check_rc $? "lvcreate failed of /dev/vg_openv/lv_usropenvnetbackup_logs. Do you want to continue"

_note "Exec: lvextend -l 625 /dev/vg_openv/lv_usropenvnetbackup_logs "
lvextend -l 625 /dev/vg_openv/lv_usropenvnetbackup_logs
_check_rc $? "lvextend failed of /dev/vg_openv/lv_usropenvnetbackup_logs. Do you want to continue"

_note "Exec: lvcreate  -n lv_usropenv_logs /dev/vg_openv"
lvcreate  -n lv_usropenv_logs /dev/vg_openv
_check_rc $? "lvcreate failed of /dev/vg_openv/lv_usropenv_logs. Do you want to continue"

_note "Exec: lvextend -l 625 /dev/vg_openv/lv_usropenv_logs "
lvextend -l 625 /dev/vg_openv/lv_usropenv_logs
_check_rc $? "lvextend failed of /dev/vg_openv/lv_usropenv_logs. Do you want to continue"

_note "Exec: lvcreate  -n lv_usropenv_patches /dev/vg_openv"
lvcreate  -n lv_usropenv_patches /dev/vg_openv
_check_rc $? "lvcreate failed of /dev/vg_openv/lv_usropenv_patches. Do you want to continue"

_note "Exec: lvextend -l 625 /dev/vg_openv/lv_usropenv_patches "
lvextend -l 625 /dev/vg_openv/lv_usropenv_patches
_check_rc $? "lvextend failed of /dev/vg_openv/lv_usropenv_patches. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_oracleRJ1_sapdata1"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_oracleRJ1_sapdata1
_check_rc $? "mkfs failed of /dev/vg_RJ1/rlv_oracleRJ1_sapdata1. Do you want to continue"

####### /oracle/RJ1/sapdata1 ######
# check dir
if [[ -d /oracle/RJ1/sapdata1 ]]; then
_note "Directory /oracle/RJ1/sapdata1 already exist"
else
_note "Exec: mkdir -p -m 755 /oracle/RJ1/sapdata1"
mkdir -p -m 755 /oracle/RJ1/sapdata1
_check_rc $? "mkdir failed of /oracle/RJ1/sapdata1. Do you want to continue"
fi
chown root:sys /oracle/RJ1/sapdata1

_note "Exec: chmod 755 /oracle/RJ1/sapdata1"
chmod 755 /oracle/RJ1/sapdata1
_check_rc $? "chmod failed of /oracle/RJ1/sapdata1. Do you want to continue"

_note "Exec: chown root /oracle/RJ1/sapdata1"
chown root /oracle/RJ1/sapdata1
_check_rc $? "chown failed of /oracle/RJ1/sapdata1. Do you want to continue"

_note "Exec: chgrp root /oracle/RJ1/sapdata1"
chgrp root /oracle/RJ1/sapdata1
_check_rc $? "chgrp failed of /oracle/RJ1/sapdata1. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_oracleRJ1_sapdata2"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_oracleRJ1_sapdata2
_check_rc $? "mkfs failed of /dev/vg_RJ1/rlv_oracleRJ1_sapdata2. Do you want to continue"

####### /oracle/RJ1/sapdata2 ######
# check dir
if [[ -d /oracle/RJ1/sapdata2 ]]; then
_note "Directory /oracle/RJ1/sapdata2 already exist"
else
_note "Exec: mkdir -p -m 755 /oracle/RJ1/sapdata2"
mkdir -p -m 755 /oracle/RJ1/sapdata2
_check_rc $? "mkdir failed of /oracle/RJ1/sapdata2. Do you want to continue"
fi
chown root:sys /oracle/RJ1/sapdata2

_note "Exec: chmod 755 /oracle/RJ1/sapdata2"
chmod 755 /oracle/RJ1/sapdata2
_check_rc $? "chmod failed of /oracle/RJ1/sapdata2. Do you want to continue"

_note "Exec: chown root /oracle/RJ1/sapdata2"
chown root /oracle/RJ1/sapdata2
_check_rc $? "chown failed of /oracle/RJ1/sapdata2. Do you want to continue"

_note "Exec: chgrp root /oracle/RJ1/sapdata2"
chgrp root /oracle/RJ1/sapdata2
_check_rc $? "chgrp failed of /oracle/RJ1/sapdata2. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_oracleRJ1_sapdata3"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_oracleRJ1_sapdata3
_check_rc $? "mkfs failed of /dev/vg_RJ1/rlv_oracleRJ1_sapdata3. Do you want to continue"

####### /oracle/RJ1/sapdata3 ######
# check dir
if [[ -d /oracle/RJ1/sapdata3 ]]; then
_note "Directory /oracle/RJ1/sapdata3 already exist"
else
_note "Exec: mkdir -p -m 755 /oracle/RJ1/sapdata3"
mkdir -p -m 755 /oracle/RJ1/sapdata3
_check_rc $? "mkdir failed of /oracle/RJ1/sapdata3. Do you want to continue"
fi
chown root:sys /oracle/RJ1/sapdata3

_note "Exec: chmod 755 /oracle/RJ1/sapdata3"
chmod 755 /oracle/RJ1/sapdata3
_check_rc $? "chmod failed of /oracle/RJ1/sapdata3. Do you want to continue"

_note "Exec: chown root /oracle/RJ1/sapdata3"
chown root /oracle/RJ1/sapdata3
_check_rc $? "chown failed of /oracle/RJ1/sapdata3. Do you want to continue"

_note "Exec: chgrp root /oracle/RJ1/sapdata3"
chgrp root /oracle/RJ1/sapdata3
_check_rc $? "chgrp failed of /oracle/RJ1/sapdata3. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_oracleRJ1_sapdata4"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_oracleRJ1_sapdata4
_check_rc $? "mkfs failed of /dev/vg_RJ1/rlv_oracleRJ1_sapdata4. Do you want to continue"

####### /oracle/RJ1/sapdata4 ######
# check dir
if [[ -d /oracle/RJ1/sapdata4 ]]; then
_note "Directory /oracle/RJ1/sapdata4 already exist"
else
_note "Exec: mkdir -p -m 755 /oracle/RJ1/sapdata4"
mkdir -p -m 755 /oracle/RJ1/sapdata4
_check_rc $? "mkdir failed of /oracle/RJ1/sapdata4. Do you want to continue"
fi
chown root:sys /oracle/RJ1/sapdata4

_note "Exec: chmod 755 /oracle/RJ1/sapdata4"
chmod 755 /oracle/RJ1/sapdata4
_check_rc $? "chmod failed of /oracle/RJ1/sapdata4. Do you want to continue"

_note "Exec: chown root /oracle/RJ1/sapdata4"
chown root /oracle/RJ1/sapdata4
_check_rc $? "chown failed of /oracle/RJ1/sapdata4. Do you want to continue"

_note "Exec: chgrp root /oracle/RJ1/sapdata4"
chgrp root /oracle/RJ1/sapdata4
_check_rc $? "chgrp failed of /oracle/RJ1/sapdata4. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_oracleRJ1_origlogB"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_oracleRJ1_origlogB
_check_rc $? "mkfs failed of /dev/vg_RJ1/rlv_oracleRJ1_origlogB. Do you want to continue"

####### /oracle/RJ1/origlogB ######
# check dir
if [[ -d /oracle/RJ1/origlogB ]]; then
_note "Directory /oracle/RJ1/origlogB already exist"
else
_note "Exec: mkdir -p -m 755 /oracle/RJ1/origlogB"
mkdir -p -m 755 /oracle/RJ1/origlogB
_check_rc $? "mkdir failed of /oracle/RJ1/origlogB. Do you want to continue"
fi
chown root:sys /oracle/RJ1/origlogB

_note "Exec: chmod 755 /oracle/RJ1/origlogB"
chmod 755 /oracle/RJ1/origlogB
_check_rc $? "chmod failed of /oracle/RJ1/origlogB. Do you want to continue"

_note "Exec: chown root /oracle/RJ1/origlogB"
chown root /oracle/RJ1/origlogB
_check_rc $? "chown failed of /oracle/RJ1/origlogB. Do you want to continue"

_note "Exec: chgrp root /oracle/RJ1/origlogB"
chgrp root /oracle/RJ1/origlogB
_check_rc $? "chgrp failed of /oracle/RJ1/origlogB. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_oracleRJ1_origlogA"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_oracleRJ1_origlogA
_check_rc $? "mkfs failed of /dev/vg_RJ1/rlv_oracleRJ1_origlogA. Do you want to continue"

####### /oracle/RJ1/origlogA ######
# check dir
if [[ -d /oracle/RJ1/origlogA ]]; then
_note "Directory /oracle/RJ1/origlogA already exist"
else
_note "Exec: mkdir -p -m 755 /oracle/RJ1/origlogA"
mkdir -p -m 755 /oracle/RJ1/origlogA
_check_rc $? "mkdir failed of /oracle/RJ1/origlogA. Do you want to continue"
fi
chown root:sys /oracle/RJ1/origlogA

_note "Exec: chmod 755 /oracle/RJ1/origlogA"
chmod 755 /oracle/RJ1/origlogA
_check_rc $? "chmod failed of /oracle/RJ1/origlogA. Do you want to continue"

_note "Exec: chown root /oracle/RJ1/origlogA"
chown root /oracle/RJ1/origlogA
_check_rc $? "chown failed of /oracle/RJ1/origlogA. Do you want to continue"

_note "Exec: chgrp root /oracle/RJ1/origlogA"
chgrp root /oracle/RJ1/origlogA
_check_rc $? "chgrp failed of /oracle/RJ1/origlogA. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_oracleRJ1_oraarch"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_oracleRJ1_oraarch
_check_rc $? "mkfs failed of /dev/vg_RJ1/rlv_oracleRJ1_oraarch. Do you want to continue"

####### /oracle/RJ1/oraarch ######
# check dir
if [[ -d /oracle/RJ1/oraarch ]]; then
_note "Directory /oracle/RJ1/oraarch already exist"
else
_note "Exec: mkdir -p -m 755 /oracle/RJ1/oraarch"
mkdir -p -m 755 /oracle/RJ1/oraarch
_check_rc $? "mkdir failed of /oracle/RJ1/oraarch. Do you want to continue"
fi
chown root:sys /oracle/RJ1/oraarch

_note "Exec: chmod 755 /oracle/RJ1/oraarch"
chmod 755 /oracle/RJ1/oraarch
_check_rc $? "chmod failed of /oracle/RJ1/oraarch. Do you want to continue"

_note "Exec: chown root /oracle/RJ1/oraarch"
chown root /oracle/RJ1/oraarch
_check_rc $? "chown failed of /oracle/RJ1/oraarch. Do you want to continue"

_note "Exec: chgrp root /oracle/RJ1/oraarch"
chgrp root /oracle/RJ1/oraarch
_check_rc $? "chgrp failed of /oracle/RJ1/oraarch. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_oracleRJ1_mirrlogB"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_oracleRJ1_mirrlogB
_check_rc $? "mkfs failed of /dev/vg_RJ1/rlv_oracleRJ1_mirrlogB. Do you want to continue"

####### /oracle/RJ1/mirrlogB ######
# check dir
if [[ -d /oracle/RJ1/mirrlogB ]]; then
_note "Directory /oracle/RJ1/mirrlogB already exist"
else
_note "Exec: mkdir -p -m 755 /oracle/RJ1/mirrlogB"
mkdir -p -m 755 /oracle/RJ1/mirrlogB
_check_rc $? "mkdir failed of /oracle/RJ1/mirrlogB. Do you want to continue"
fi
chown root:sys /oracle/RJ1/mirrlogB

_note "Exec: chmod 755 /oracle/RJ1/mirrlogB"
chmod 755 /oracle/RJ1/mirrlogB
_check_rc $? "chmod failed of /oracle/RJ1/mirrlogB. Do you want to continue"

_note "Exec: chown root /oracle/RJ1/mirrlogB"
chown root /oracle/RJ1/mirrlogB
_check_rc $? "chown failed of /oracle/RJ1/mirrlogB. Do you want to continue"

_note "Exec: chgrp root /oracle/RJ1/mirrlogB"
chgrp root /oracle/RJ1/mirrlogB
_check_rc $? "chgrp failed of /oracle/RJ1/mirrlogB. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_oracleRJ1_mirrlogA"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_oracleRJ1_mirrlogA
_check_rc $? "mkfs failed of /dev/vg_RJ1/rlv_oracleRJ1_mirrlogA. Do you want to continue"

####### /oracle/RJ1/mirrlogA ######
# check dir
if [[ -d /oracle/RJ1/mirrlogA ]]; then
_note "Directory /oracle/RJ1/mirrlogA already exist"
else
_note "Exec: mkdir -p -m 755 /oracle/RJ1/mirrlogA"
mkdir -p -m 755 /oracle/RJ1/mirrlogA
_check_rc $? "mkdir failed of /oracle/RJ1/mirrlogA. Do you want to continue"
fi
chown root:sys /oracle/RJ1/mirrlogA

_note "Exec: chmod 755 /oracle/RJ1/mirrlogA"
chmod 755 /oracle/RJ1/mirrlogA
_check_rc $? "chmod failed of /oracle/RJ1/mirrlogA. Do you want to continue"

_note "Exec: chown root /oracle/RJ1/mirrlogA"
chown root /oracle/RJ1/mirrlogA
_check_rc $? "chown failed of /oracle/RJ1/mirrlogA. Do you want to continue"

_note "Exec: chgrp root /oracle/RJ1/mirrlogA"
chgrp root /oracle/RJ1/mirrlogA
_check_rc $? "chgrp failed of /oracle/RJ1/mirrlogA. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_exportsapmnt_RJ1"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_exportsapmnt_RJ1
_check_rc $? "mkfs failed of /dev/vg_RJ1/rlv_exportsapmnt_RJ1. Do you want to continue"

####### /export/sapmnt/RJ1 ######
# check dir
if [[ -d /export/sapmnt/RJ1 ]]; then
_note "Directory /export/sapmnt/RJ1 already exist"
else
_note "Exec: mkdir -p -m 755 /export/sapmnt/RJ1"
mkdir -p -m 755 /export/sapmnt/RJ1
_check_rc $? "mkdir failed of /export/sapmnt/RJ1. Do you want to continue"
fi
chown root:sys /export/sapmnt/RJ1

_note "Exec: chmod 755 /export/sapmnt/RJ1"
chmod 755 /export/sapmnt/RJ1
_check_rc $? "chmod failed of /export/sapmnt/RJ1. Do you want to continue"

_note "Exec: chown root /export/sapmnt/RJ1"
chown root /export/sapmnt/RJ1
_check_rc $? "chown failed of /export/sapmnt/RJ1. Do you want to continue"

_note "Exec: chgrp sys /export/sapmnt/RJ1"
chgrp sys /export/sapmnt/RJ1
_check_rc $? "chgrp failed of /export/sapmnt/RJ1. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_usrsapRJ1_DVEBMGS19"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_usrsapRJ1_DVEBMGS19
_check_rc $? "mkfs failed of /dev/vg_RJ1/rlv_usrsapRJ1_DVEBMGS19. Do you want to continue"

####### /usr/sap/RJ1/DVEBMGS19 ######
# check dir
if [[ -d /usr/sap/RJ1/DVEBMGS19 ]]; then
_note "Directory /usr/sap/RJ1/DVEBMGS19 already exist"
else
_note "Exec: mkdir -p -m 755 /usr/sap/RJ1/DVEBMGS19"
mkdir -p -m 755 /usr/sap/RJ1/DVEBMGS19
_check_rc $? "mkdir failed of /usr/sap/RJ1/DVEBMGS19. Do you want to continue"
fi
chown root:sys /usr/sap/RJ1/DVEBMGS19

_note "Exec: chmod 755 /usr/sap/RJ1/DVEBMGS19"
chmod 755 /usr/sap/RJ1/DVEBMGS19
_check_rc $? "chmod failed of /usr/sap/RJ1/DVEBMGS19. Do you want to continue"

_note "Exec: chown root /usr/sap/RJ1/DVEBMGS19"
chown root /usr/sap/RJ1/DVEBMGS19
_check_rc $? "chown failed of /usr/sap/RJ1/DVEBMGS19. Do you want to continue"

_note "Exec: chgrp root /usr/sap/RJ1/DVEBMGS19"
chgrp root /usr/sap/RJ1/DVEBMGS19
_check_rc $? "chgrp failed of /usr/sap/RJ1/DVEBMGS19. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_exportoracleRJ1_sapbackup"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_exportoracleRJ1_sapbackup
_check_rc $? "mkfs failed of /dev/vg_RJ1/rlv_exportoracleRJ1_sapbackup. Do you want to continue"

####### /export/oracle/RJ1/sapbackup ######
# check dir
if [[ -d /export/oracle/RJ1/sapbackup ]]; then
_note "Directory /export/oracle/RJ1/sapbackup already exist"
else
_note "Exec: mkdir -p -m 755 /export/oracle/RJ1/sapbackup"
mkdir -p -m 755 /export/oracle/RJ1/sapbackup
_check_rc $? "mkdir failed of /export/oracle/RJ1/sapbackup. Do you want to continue"
fi
chown root:sys /export/oracle/RJ1/sapbackup

_note "Exec: chmod 755 /export/oracle/RJ1/sapbackup"
chmod 755 /export/oracle/RJ1/sapbackup
_check_rc $? "chmod failed of /export/oracle/RJ1/sapbackup. Do you want to continue"

_note "Exec: chown root /export/oracle/RJ1/sapbackup"
chown root /export/oracle/RJ1/sapbackup
_check_rc $? "chown failed of /export/oracle/RJ1/sapbackup. Do you want to continue"

_note "Exec: chgrp sys /export/oracle/RJ1/sapbackup"
chgrp sys /export/oracle/RJ1/sapbackup
_check_rc $? "chgrp failed of /export/oracle/RJ1/sapbackup. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_usrsapRJ1_ASCS05"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_usrsapRJ1_ASCS05
_check_rc $? "mkfs failed of /dev/vg_RJ1/rlv_usrsapRJ1_ASCS05. Do you want to continue"

####### /usr/sap/RJ1/ASCS05 ######
# check dir
if [[ -d /usr/sap/RJ1/ASCS05 ]]; then
_note "Directory /usr/sap/RJ1/ASCS05 already exist"
else
_note "Exec: mkdir -p -m 755 /usr/sap/RJ1/ASCS05"
mkdir -p -m 755 /usr/sap/RJ1/ASCS05
_check_rc $? "mkdir failed of /usr/sap/RJ1/ASCS05. Do you want to continue"
fi
chown root:sys /usr/sap/RJ1/ASCS05

_note "Exec: chmod 755 /usr/sap/RJ1/ASCS05"
chmod 755 /usr/sap/RJ1/ASCS05
_check_rc $? "chmod failed of /usr/sap/RJ1/ASCS05. Do you want to continue"

_note "Exec: chown root /usr/sap/RJ1/ASCS05"
chown root /usr/sap/RJ1/ASCS05
_check_rc $? "chown failed of /usr/sap/RJ1/ASCS05. Do you want to continue"

_note "Exec: chgrp root /usr/sap/RJ1/ASCS05"
chgrp root /usr/sap/RJ1/ASCS05
_check_rc $? "chgrp failed of /usr/sap/RJ1/ASCS05. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_oracle_RJ1"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_oracle_RJ1
_check_rc $? "mkfs failed of /dev/vg_RJ1/rlv_oracle_RJ1. Do you want to continue"

####### /oracle/RJ1 ######
# check dir
if [[ -d /oracle/RJ1 ]]; then
_note "Directory /oracle/RJ1 already exist"
else
_note "Exec: mkdir -p -m 755 /oracle/RJ1"
mkdir -p -m 755 /oracle/RJ1
_check_rc $? "mkdir failed of /oracle/RJ1. Do you want to continue"
fi
chown root:sys /oracle/RJ1

_note "Exec: chmod 755 /oracle/RJ1"
chmod 755 /oracle/RJ1
_check_rc $? "chmod failed of /oracle/RJ1. Do you want to continue"

_note "Exec: chown root /oracle/RJ1"
chown root /oracle/RJ1
_check_rc $? "chown failed of /oracle/RJ1. Do you want to continue"

_note "Exec: chgrp root /oracle/RJ1"
chgrp root /oracle/RJ1
_check_rc $? "chgrp failed of /oracle/RJ1. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_oracleRJ1_112_64"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_oracleRJ1_112_64
_check_rc $? "mkfs failed of /dev/vg_RJ1/rlv_oracleRJ1_112_64. Do you want to continue"

####### /oracle/RJ1/112_64 ######
# check dir
if [[ -d /oracle/RJ1/112_64 ]]; then
_note "Directory /oracle/RJ1/112_64 already exist"
else
_note "Exec: mkdir -p -m 755 /oracle/RJ1/112_64"
mkdir -p -m 755 /oracle/RJ1/112_64
_check_rc $? "mkdir failed of /oracle/RJ1/112_64. Do you want to continue"
fi
chown root:sys /oracle/RJ1/112_64

_note "Exec: chmod 755 /oracle/RJ1/112_64"
chmod 755 /oracle/RJ1/112_64
_check_rc $? "chmod failed of /oracle/RJ1/112_64. Do you want to continue"

_note "Exec: chown root /oracle/RJ1/112_64"
chown root /oracle/RJ1/112_64
_check_rc $? "chown failed of /oracle/RJ1/112_64. Do you want to continue"

_note "Exec: chgrp root /oracle/RJ1/112_64"
chgrp root /oracle/RJ1/112_64
_check_rc $? "chgrp failed of /oracle/RJ1/112_64. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_oracleRJ1_sapreorg"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ1/rlv_oracleRJ1_sapreorg
_check_rc $? "mkfs failed of /dev/vg_RJ1/rlv_oracleRJ1_sapreorg. Do you want to continue"

####### /oracle/RJ1/sapreorg ######
# check dir
if [[ -d /oracle/RJ1/sapreorg ]]; then
_note "Directory /oracle/RJ1/sapreorg already exist"
else
_note "Exec: mkdir -p -m 755 /oracle/RJ1/sapreorg"
mkdir -p -m 755 /oracle/RJ1/sapreorg
_check_rc $? "mkdir failed of /oracle/RJ1/sapreorg. Do you want to continue"
fi
chown root:sys /oracle/RJ1/sapreorg

_note "Exec: chmod 755 /oracle/RJ1/sapreorg"
chmod 755 /oracle/RJ1/sapreorg
_check_rc $? "chmod failed of /oracle/RJ1/sapreorg. Do you want to continue"

_note "Exec: chown root /oracle/RJ1/sapreorg"
chown root /oracle/RJ1/sapreorg
_check_rc $? "chown failed of /oracle/RJ1/sapreorg. Do you want to continue"

_note "Exec: chgrp root /oracle/RJ1/sapreorg"
chgrp root /oracle/RJ1/sapreorg
_check_rc $? "chgrp failed of /oracle/RJ1/sapreorg. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_ZR1/rlv_sapmnt_ZR1"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_ZR1/rlv_sapmnt_ZR1
_check_rc $? "mkfs failed of /dev/vg_ZR1/rlv_sapmnt_ZR1. Do you want to continue"

####### /sapmnt/ZR1 ######
# check dir
if [[ -d /sapmnt/ZR1 ]]; then
_note "Directory /sapmnt/ZR1 already exist"
else
_note "Exec: mkdir -p -m 755 /sapmnt/ZR1"
mkdir -p -m 755 /sapmnt/ZR1
_check_rc $? "mkdir failed of /sapmnt/ZR1. Do you want to continue"
fi
chown root:sys /sapmnt/ZR1

_note "Exec: chmod 755 /sapmnt/ZR1"
chmod 755 /sapmnt/ZR1
_check_rc $? "chmod failed of /sapmnt/ZR1. Do you want to continue"

_note "Exec: chown root /sapmnt/ZR1"
chown root /sapmnt/ZR1
_check_rc $? "chown failed of /sapmnt/ZR1. Do you want to continue"

_note "Exec: chgrp root /sapmnt/ZR1"
chgrp root /sapmnt/ZR1
_check_rc $? "chgrp failed of /sapmnt/ZR1. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_ZR1/rlv_usrsap_ZR1"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_ZR1/rlv_usrsap_ZR1
_check_rc $? "mkfs failed of /dev/vg_ZR1/rlv_usrsap_ZR1. Do you want to continue"

####### /usr/sap/ZR1 ######
# check dir
if [[ -d /usr/sap/ZR1 ]]; then
_note "Directory /usr/sap/ZR1 already exist"
else
_note "Exec: mkdir -p -m 755 /usr/sap/ZR1"
mkdir -p -m 755 /usr/sap/ZR1
_check_rc $? "mkdir failed of /usr/sap/ZR1. Do you want to continue"
fi
chown root:sys /usr/sap/ZR1

_note "Exec: chmod 755 /usr/sap/ZR1"
chmod 755 /usr/sap/ZR1
_check_rc $? "chmod failed of /usr/sap/ZR1. Do you want to continue"

_note "Exec: chown root /usr/sap/ZR1"
chown root /usr/sap/ZR1
_check_rc $? "chown failed of /usr/sap/ZR1. Do you want to continue"

_note "Exec: chgrp root /usr/sap/ZR1"
chgrp root /usr/sap/ZR1
_check_rc $? "chgrp failed of /usr/sap/ZR1. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ7/rlv_oracleRJ7_sapdata1"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ7/rlv_oracleRJ7_sapdata1
_check_rc $? "mkfs failed of /dev/vg_RJ7/rlv_oracleRJ7_sapdata1. Do you want to continue"

####### /oracle/RJ7/sapdata1 ######
# check dir
if [[ -d /oracle/RJ7/sapdata1 ]]; then
_note "Directory /oracle/RJ7/sapdata1 already exist"
else
_note "Exec: mkdir -p -m 755 /oracle/RJ7/sapdata1"
mkdir -p -m 755 /oracle/RJ7/sapdata1
_check_rc $? "mkdir failed of /oracle/RJ7/sapdata1. Do you want to continue"
fi
chown root:sys /oracle/RJ7/sapdata1

_note "Exec: chmod 755 /oracle/RJ7/sapdata1"
chmod 755 /oracle/RJ7/sapdata1
_check_rc $? "chmod failed of /oracle/RJ7/sapdata1. Do you want to continue"

_note "Exec: chown root /oracle/RJ7/sapdata1"
chown root /oracle/RJ7/sapdata1
_check_rc $? "chown failed of /oracle/RJ7/sapdata1. Do you want to continue"

_note "Exec: chgrp root /oracle/RJ7/sapdata1"
chgrp root /oracle/RJ7/sapdata1
_check_rc $? "chgrp failed of /oracle/RJ7/sapdata1. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ7/rlv_oracleRJ7_sapdata2"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ7/rlv_oracleRJ7_sapdata2
_check_rc $? "mkfs failed of /dev/vg_RJ7/rlv_oracleRJ7_sapdata2. Do you want to continue"

####### /oracle/RJ7/sapdata2 ######
# check dir
if [[ -d /oracle/RJ7/sapdata2 ]]; then
_note "Directory /oracle/RJ7/sapdata2 already exist"
else
_note "Exec: mkdir -p -m 755 /oracle/RJ7/sapdata2"
mkdir -p -m 755 /oracle/RJ7/sapdata2
_check_rc $? "mkdir failed of /oracle/RJ7/sapdata2. Do you want to continue"
fi
chown root:sys /oracle/RJ7/sapdata2

_note "Exec: chmod 755 /oracle/RJ7/sapdata2"
chmod 755 /oracle/RJ7/sapdata2
_check_rc $? "chmod failed of /oracle/RJ7/sapdata2. Do you want to continue"

_note "Exec: chown root /oracle/RJ7/sapdata2"
chown root /oracle/RJ7/sapdata2
_check_rc $? "chown failed of /oracle/RJ7/sapdata2. Do you want to continue"

_note "Exec: chgrp root /oracle/RJ7/sapdata2"
chgrp root /oracle/RJ7/sapdata2
_check_rc $? "chgrp failed of /oracle/RJ7/sapdata2. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ7/rlv_oracleRJ7_origlogA"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ7/rlv_oracleRJ7_origlogA
_check_rc $? "mkfs failed of /dev/vg_RJ7/rlv_oracleRJ7_origlogA. Do you want to continue"

####### /oracle/RJ7/origlogA ######
# check dir
if [[ -d /oracle/RJ7/origlogA ]]; then
_note "Directory /oracle/RJ7/origlogA already exist"
else
_note "Exec: mkdir -p -m 755 /oracle/RJ7/origlogA"
mkdir -p -m 755 /oracle/RJ7/origlogA
_check_rc $? "mkdir failed of /oracle/RJ7/origlogA. Do you want to continue"
fi
chown root:sys /oracle/RJ7/origlogA

_note "Exec: chmod 755 /oracle/RJ7/origlogA"
chmod 755 /oracle/RJ7/origlogA
_check_rc $? "chmod failed of /oracle/RJ7/origlogA. Do you want to continue"

_note "Exec: chown root /oracle/RJ7/origlogA"
chown root /oracle/RJ7/origlogA
_check_rc $? "chown failed of /oracle/RJ7/origlogA. Do you want to continue"

_note "Exec: chgrp root /oracle/RJ7/origlogA"
chgrp root /oracle/RJ7/origlogA
_check_rc $? "chgrp failed of /oracle/RJ7/origlogA. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ7/rlv_oracleRJ7_origlogB"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ7/rlv_oracleRJ7_origlogB
_check_rc $? "mkfs failed of /dev/vg_RJ7/rlv_oracleRJ7_origlogB. Do you want to continue"

####### /oracle/RJ7/origlogB ######
# check dir
if [[ -d /oracle/RJ7/origlogB ]]; then
_note "Directory /oracle/RJ7/origlogB already exist"
else
_note "Exec: mkdir -p -m 755 /oracle/RJ7/origlogB"
mkdir -p -m 755 /oracle/RJ7/origlogB
_check_rc $? "mkdir failed of /oracle/RJ7/origlogB. Do you want to continue"
fi
chown root:sys /oracle/RJ7/origlogB

_note "Exec: chmod 755 /oracle/RJ7/origlogB"
chmod 755 /oracle/RJ7/origlogB
_check_rc $? "chmod failed of /oracle/RJ7/origlogB. Do you want to continue"

_note "Exec: chown root /oracle/RJ7/origlogB"
chown root /oracle/RJ7/origlogB
_check_rc $? "chown failed of /oracle/RJ7/origlogB. Do you want to continue"

_note "Exec: chgrp root /oracle/RJ7/origlogB"
chgrp root /oracle/RJ7/origlogB
_check_rc $? "chgrp failed of /oracle/RJ7/origlogB. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ7/rlv_oracleRJ7_mirrlogA"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ7/rlv_oracleRJ7_mirrlogA
_check_rc $? "mkfs failed of /dev/vg_RJ7/rlv_oracleRJ7_mirrlogA. Do you want to continue"

####### /oracle/RJ7/mirrlogA ######
# check dir
if [[ -d /oracle/RJ7/mirrlogA ]]; then
_note "Directory /oracle/RJ7/mirrlogA already exist"
else
_note "Exec: mkdir -p -m 755 /oracle/RJ7/mirrlogA"
mkdir -p -m 755 /oracle/RJ7/mirrlogA
_check_rc $? "mkdir failed of /oracle/RJ7/mirrlogA. Do you want to continue"
fi
chown root:sys /oracle/RJ7/mirrlogA

_note "Exec: chmod 755 /oracle/RJ7/mirrlogA"
chmod 755 /oracle/RJ7/mirrlogA
_check_rc $? "chmod failed of /oracle/RJ7/mirrlogA. Do you want to continue"

_note "Exec: chown root /oracle/RJ7/mirrlogA"
chown root /oracle/RJ7/mirrlogA
_check_rc $? "chown failed of /oracle/RJ7/mirrlogA. Do you want to continue"

_note "Exec: chgrp root /oracle/RJ7/mirrlogA"
chgrp root /oracle/RJ7/mirrlogA
_check_rc $? "chgrp failed of /oracle/RJ7/mirrlogA. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ7/rlv_oracleRJ7_mirrlogB"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ7/rlv_oracleRJ7_mirrlogB
_check_rc $? "mkfs failed of /dev/vg_RJ7/rlv_oracleRJ7_mirrlogB. Do you want to continue"

####### /oracle/RJ7/mirrlogB ######
# check dir
if [[ -d /oracle/RJ7/mirrlogB ]]; then
_note "Directory /oracle/RJ7/mirrlogB already exist"
else
_note "Exec: mkdir -p -m 755 /oracle/RJ7/mirrlogB"
mkdir -p -m 755 /oracle/RJ7/mirrlogB
_check_rc $? "mkdir failed of /oracle/RJ7/mirrlogB. Do you want to continue"
fi
chown root:sys /oracle/RJ7/mirrlogB

_note "Exec: chmod 755 /oracle/RJ7/mirrlogB"
chmod 755 /oracle/RJ7/mirrlogB
_check_rc $? "chmod failed of /oracle/RJ7/mirrlogB. Do you want to continue"

_note "Exec: chown root /oracle/RJ7/mirrlogB"
chown root /oracle/RJ7/mirrlogB
_check_rc $? "chown failed of /oracle/RJ7/mirrlogB. Do you want to continue"

_note "Exec: chgrp root /oracle/RJ7/mirrlogB"
chgrp root /oracle/RJ7/mirrlogB
_check_rc $? "chgrp failed of /oracle/RJ7/mirrlogB. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ7/rlv_oracleRJ7_102_64"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ7/rlv_oracleRJ7_102_64
_check_rc $? "mkfs failed of /dev/vg_RJ7/rlv_oracleRJ7_102_64. Do you want to continue"

####### /oracle/RJ7/102_64 ######
# check dir
if [[ -d /oracle/RJ7/102_64 ]]; then
_note "Directory /oracle/RJ7/102_64 already exist"
else
_note "Exec: mkdir -p -m 755 /oracle/RJ7/102_64"
mkdir -p -m 755 /oracle/RJ7/102_64
_check_rc $? "mkdir failed of /oracle/RJ7/102_64. Do you want to continue"
fi
chown root:sys /oracle/RJ7/102_64

_note "Exec: chmod 755 /oracle/RJ7/102_64"
chmod 755 /oracle/RJ7/102_64
_check_rc $? "chmod failed of /oracle/RJ7/102_64. Do you want to continue"

_note "Exec: chown root /oracle/RJ7/102_64"
chown root /oracle/RJ7/102_64
_check_rc $? "chown failed of /oracle/RJ7/102_64. Do you want to continue"

_note "Exec: chgrp root /oracle/RJ7/102_64"
chgrp root /oracle/RJ7/102_64
_check_rc $? "chgrp failed of /oracle/RJ7/102_64. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ7/rlv_oracleRJ7_oraarch"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ7/rlv_oracleRJ7_oraarch
_check_rc $? "mkfs failed of /dev/vg_RJ7/rlv_oracleRJ7_oraarch. Do you want to continue"

####### /oracle/RJ7/oraarch ######
# check dir
if [[ -d /oracle/RJ7/oraarch ]]; then
_note "Directory /oracle/RJ7/oraarch already exist"
else
_note "Exec: mkdir -p -m 755 /oracle/RJ7/oraarch"
mkdir -p -m 755 /oracle/RJ7/oraarch
_check_rc $? "mkdir failed of /oracle/RJ7/oraarch. Do you want to continue"
fi
chown root:sys /oracle/RJ7/oraarch

_note "Exec: chmod 755 /oracle/RJ7/oraarch"
chmod 755 /oracle/RJ7/oraarch
_check_rc $? "chmod failed of /oracle/RJ7/oraarch. Do you want to continue"

_note "Exec: chown root /oracle/RJ7/oraarch"
chown root /oracle/RJ7/oraarch
_check_rc $? "chown failed of /oracle/RJ7/oraarch. Do you want to continue"

_note "Exec: chgrp root /oracle/RJ7/oraarch"
chgrp root /oracle/RJ7/oraarch
_check_rc $? "chgrp failed of /oracle/RJ7/oraarch. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ7/rlv_oracleRJ7_sapbackup"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ7/rlv_oracleRJ7_sapbackup
_check_rc $? "mkfs failed of /dev/vg_RJ7/rlv_oracleRJ7_sapbackup. Do you want to continue"

####### /oracle/RJ7/sapbackup ######
# check dir
if [[ -d /oracle/RJ7/sapbackup ]]; then
_note "Directory /oracle/RJ7/sapbackup already exist"
else
_note "Exec: mkdir -p -m 755 /oracle/RJ7/sapbackup"
mkdir -p -m 755 /oracle/RJ7/sapbackup
_check_rc $? "mkdir failed of /oracle/RJ7/sapbackup. Do you want to continue"
fi
chown root:sys /oracle/RJ7/sapbackup

_note "Exec: chmod 755 /oracle/RJ7/sapbackup"
chmod 755 /oracle/RJ7/sapbackup
_check_rc $? "chmod failed of /oracle/RJ7/sapbackup. Do you want to continue"

_note "Exec: chown root /oracle/RJ7/sapbackup"
chown root /oracle/RJ7/sapbackup
_check_rc $? "chown failed of /oracle/RJ7/sapbackup. Do you want to continue"

_note "Exec: chgrp root /oracle/RJ7/sapbackup"
chgrp root /oracle/RJ7/sapbackup
_check_rc $? "chgrp failed of /oracle/RJ7/sapbackup. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ7/rlv_oracleRJ7_saparch"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ7/rlv_oracleRJ7_saparch
_check_rc $? "mkfs failed of /dev/vg_RJ7/rlv_oracleRJ7_saparch. Do you want to continue"

####### /oracle/RJ7/saparch ######
# check dir
if [[ -d /oracle/RJ7/saparch ]]; then
_note "Directory /oracle/RJ7/saparch already exist"
else
_note "Exec: mkdir -p -m 755 /oracle/RJ7/saparch"
mkdir -p -m 755 /oracle/RJ7/saparch
_check_rc $? "mkdir failed of /oracle/RJ7/saparch. Do you want to continue"
fi
chown root:sys /oracle/RJ7/saparch

_note "Exec: chmod 755 /oracle/RJ7/saparch"
chmod 755 /oracle/RJ7/saparch
_check_rc $? "chmod failed of /oracle/RJ7/saparch. Do you want to continue"

_note "Exec: chown root /oracle/RJ7/saparch"
chown root /oracle/RJ7/saparch
_check_rc $? "chown failed of /oracle/RJ7/saparch. Do you want to continue"

_note "Exec: chgrp root /oracle/RJ7/saparch"
chgrp root /oracle/RJ7/saparch
_check_rc $? "chgrp failed of /oracle/RJ7/saparch. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ7/rlv_oracleRJ7_RJ7"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_RJ7/rlv_oracleRJ7_RJ7
_check_rc $? "mkfs failed of /dev/vg_RJ7/rlv_oracleRJ7_RJ7. Do you want to continue"

####### /oracle/RJ7 ######
# check dir
if [[ -d /oracle/RJ7 ]]; then
_note "Directory /oracle/RJ7 already exist"
else
_note "Exec: mkdir -p -m 755 /oracle/RJ7"
mkdir -p -m 755 /oracle/RJ7
_check_rc $? "mkdir failed of /oracle/RJ7. Do you want to continue"
fi
chown root:sys /oracle/RJ7

_note "Exec: chmod 755 /oracle/RJ7"
chmod 755 /oracle/RJ7
_check_rc $? "chmod failed of /oracle/RJ7. Do you want to continue"

_note "Exec: chown root /oracle/RJ7"
chown root /oracle/RJ7
_check_rc $? "chown failed of /oracle/RJ7. Do you want to continue"

_note "Exec: chgrp root /oracle/RJ7"
chgrp root /oracle/RJ7
_check_rc $? "chgrp failed of /oracle/RJ7. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_sap/rlv_usr_sap"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_sap/rlv_usr_sap
_check_rc $? "mkfs failed of /dev/vg_sap/rlv_usr_sap. Do you want to continue"

####### /usr/sap ######
# check dir
if [[ -d /usr/sap ]]; then
_note "Directory /usr/sap already exist"
else
_note "Exec: mkdir -p -m 755 /usr/sap"
mkdir -p -m 755 /usr/sap
_check_rc $? "mkdir failed of /usr/sap. Do you want to continue"
fi
chown root:sys /usr/sap

_note "Exec: chmod 755 /usr/sap"
chmod 755 /usr/sap
_check_rc $? "chmod failed of /usr/sap. Do you want to continue"

_note "Exec: chown root /usr/sap"
chown root /usr/sap
_check_rc $? "chown failed of /usr/sap. Do you want to continue"

_note "Exec: chgrp root /usr/sap"
chgrp root /usr/sap
_check_rc $? "chgrp failed of /usr/sap. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_sap/rlv_usrsap_SMD"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_sap/rlv_usrsap_SMD
_check_rc $? "mkfs failed of /dev/vg_sap/rlv_usrsap_SMD. Do you want to continue"

####### /usr/sap/SMD ######
# check dir
if [[ -d /usr/sap/SMD ]]; then
_note "Directory /usr/sap/SMD already exist"
else
_note "Exec: mkdir -p -m 755 /usr/sap/SMD"
mkdir -p -m 755 /usr/sap/SMD
_check_rc $? "mkdir failed of /usr/sap/SMD. Do you want to continue"
fi
chown root:sys /usr/sap/SMD

_note "Exec: chmod 755 /usr/sap/SMD"
chmod 755 /usr/sap/SMD
_check_rc $? "chmod failed of /usr/sap/SMD. Do you want to continue"

_note "Exec: chown root /usr/sap/SMD"
chown root /usr/sap/SMD
_check_rc $? "chown failed of /usr/sap/SMD. Do you want to continue"

_note "Exec: chgrp root /usr/sap/SMD"
chgrp root /usr/sap/SMD
_check_rc $? "chgrp failed of /usr/sap/SMD. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_sap/rlv_usrsapRJ1_ERS05"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_sap/rlv_usrsapRJ1_ERS05
_check_rc $? "mkfs failed of /dev/vg_sap/rlv_usrsapRJ1_ERS05. Do you want to continue"

####### /usr/sap/RJ1/ERS05 ######
# check dir
if [[ -d /usr/sap/RJ1/ERS05 ]]; then
_note "Directory /usr/sap/RJ1/ERS05 already exist"
else
_note "Exec: mkdir -p -m 755 /usr/sap/RJ1/ERS05"
mkdir -p -m 755 /usr/sap/RJ1/ERS05
_check_rc $? "mkdir failed of /usr/sap/RJ1/ERS05. Do you want to continue"
fi
chown root:sys /usr/sap/RJ1/ERS05

_note "Exec: chmod 755 /usr/sap/RJ1/ERS05"
chmod 755 /usr/sap/RJ1/ERS05
_check_rc $? "chmod failed of /usr/sap/RJ1/ERS05. Do you want to continue"

_note "Exec: chown root /usr/sap/RJ1/ERS05"
chown root /usr/sap/RJ1/ERS05
_check_rc $? "chown failed of /usr/sap/RJ1/ERS05. Do you want to continue"

_note "Exec: chgrp root /usr/sap/RJ1/ERS05"
chgrp root /usr/sap/RJ1/ERS05
_check_rc $? "chgrp failed of /usr/sap/RJ1/ERS05. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_sap/rlv_usrsapRJ6_ERS25"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_sap/rlv_usrsapRJ6_ERS25
_check_rc $? "mkfs failed of /dev/vg_sap/rlv_usrsapRJ6_ERS25. Do you want to continue"

####### /usr/sap/RJ6/ERS25 ######
# check dir
if [[ -d /usr/sap/RJ6/ERS25 ]]; then
_note "Directory /usr/sap/RJ6/ERS25 already exist"
else
_note "Exec: mkdir -p -m 755 /usr/sap/RJ6/ERS25"
mkdir -p -m 755 /usr/sap/RJ6/ERS25
_check_rc $? "mkdir failed of /usr/sap/RJ6/ERS25. Do you want to continue"
fi
chown root:sys /usr/sap/RJ6/ERS25

_note "Exec: chmod 755 /usr/sap/RJ6/ERS25"
chmod 755 /usr/sap/RJ6/ERS25
_check_rc $? "chmod failed of /usr/sap/RJ6/ERS25. Do you want to continue"

_note "Exec: chown root /usr/sap/RJ6/ERS25"
chown root /usr/sap/RJ6/ERS25
_check_rc $? "chown failed of /usr/sap/RJ6/ERS25. Do you want to continue"

_note "Exec: chgrp root /usr/sap/RJ6/ERS25"
chgrp root /usr/sap/RJ6/ERS25
_check_rc $? "chgrp failed of /usr/sap/RJ6/ERS25. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_sap/rlv_usrsapSMD_J97"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_sap/rlv_usrsapSMD_J97
_check_rc $? "mkfs failed of /dev/vg_sap/rlv_usrsapSMD_J97. Do you want to continue"

####### /usr/sap/SMD/J97 ######
# check dir
if [[ -d /usr/sap/SMD/J97 ]]; then
_note "Directory /usr/sap/SMD/J97 already exist"
else
_note "Exec: mkdir -p -m 755 /usr/sap/SMD/J97"
mkdir -p -m 755 /usr/sap/SMD/J97
_check_rc $? "mkdir failed of /usr/sap/SMD/J97. Do you want to continue"
fi
chown root:sys /usr/sap/SMD/J97

_note "Exec: chmod 755 /usr/sap/SMD/J97"
chmod 755 /usr/sap/SMD/J97
_check_rc $? "chmod failed of /usr/sap/SMD/J97. Do you want to continue"

_note "Exec: chown root /usr/sap/SMD/J97"
chown root /usr/sap/SMD/J97
_check_rc $? "chown failed of /usr/sap/SMD/J97. Do you want to continue"

_note "Exec: chgrp root /usr/sap/SMD/J97"
chgrp root /usr/sap/SMD/J97
_check_rc $? "chgrp failed of /usr/sap/SMD/J97. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_sap/rlv_usrsapSMD_J98"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_sap/rlv_usrsapSMD_J98
_check_rc $? "mkfs failed of /dev/vg_sap/rlv_usrsapSMD_J98. Do you want to continue"

####### /usr/sap/SMD/J98 ######
# check dir
if [[ -d /usr/sap/SMD/J98 ]]; then
_note "Directory /usr/sap/SMD/J98 already exist"
else
_note "Exec: mkdir -p -m 755 /usr/sap/SMD/J98"
mkdir -p -m 755 /usr/sap/SMD/J98
_check_rc $? "mkdir failed of /usr/sap/SMD/J98. Do you want to continue"
fi
chown root:sys /usr/sap/SMD/J98

_note "Exec: chmod 755 /usr/sap/SMD/J98"
chmod 755 /usr/sap/SMD/J98
_check_rc $? "chmod failed of /usr/sap/SMD/J98. Do you want to continue"

_note "Exec: chown root /usr/sap/SMD/J98"
chown root /usr/sap/SMD/J98
_check_rc $? "chown failed of /usr/sap/SMD/J98. Do you want to continue"

_note "Exec: chgrp root /usr/sap/SMD/J98"
chgrp root /usr/sap/SMD/J98
_check_rc $? "chgrp failed of /usr/sap/SMD/J98. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_sap/rlv_sapmnt"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_sap/rlv_sapmnt
_check_rc $? "mkfs failed of /dev/vg_sap/rlv_sapmnt. Do you want to continue"

####### /sapmnt ######
# check dir
if [[ -d /sapmnt ]]; then
_note "Directory /sapmnt already exist"
else
_note "Exec: mkdir -p -m 755 /sapmnt"
mkdir -p -m 755 /sapmnt
_check_rc $? "mkdir failed of /sapmnt. Do you want to continue"
fi
chown root:sys /sapmnt

_note "Exec: chmod 755 /sapmnt"
chmod 755 /sapmnt
_check_rc $? "chmod failed of /sapmnt. Do you want to continue"

_note "Exec: chown root /sapmnt"
chown root /sapmnt
_check_rc $? "chown failed of /sapmnt. Do you want to continue"

_note "Exec: chgrp root /sapmnt"
chgrp root /sapmnt
_check_rc $? "chgrp failed of /sapmnt. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_oracle/rlv_oracle"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_oracle/rlv_oracle
_check_rc $? "mkfs failed of /dev/vg_oracle/rlv_oracle. Do you want to continue"

####### /oracle ######
# check dir
if [[ -d /oracle ]]; then
_note "Directory /oracle already exist"
else
_note "Exec: mkdir -p -m 755 /oracle"
mkdir -p -m 755 /oracle
_check_rc $? "mkdir failed of /oracle. Do you want to continue"
fi
chown root:sys /oracle

_note "Exec: chmod 755 /oracle"
chmod 755 /oracle
_check_rc $? "chmod failed of /oracle. Do you want to continue"

_note "Exec: chown root /oracle"
chown root /oracle
_check_rc $? "chown failed of /oracle. Do you want to continue"

_note "Exec: chgrp root /oracle"
chgrp root /oracle
_check_rc $? "chgrp failed of /oracle. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_oracle/rlv_oracle_stage"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_oracle/rlv_oracle_stage
_check_rc $? "mkfs failed of /dev/vg_oracle/rlv_oracle_stage. Do you want to continue"

####### /oracle/stage ######
# check dir
if [[ -d /oracle/stage ]]; then
_note "Directory /oracle/stage already exist"
else
_note "Exec: mkdir -p -m 755 /oracle/stage"
mkdir -p -m 755 /oracle/stage
_check_rc $? "mkdir failed of /oracle/stage. Do you want to continue"
fi
chown root:sys /oracle/stage

_note "Exec: chmod 755 /oracle/stage"
chmod 755 /oracle/stage
_check_rc $? "chmod failed of /oracle/stage. Do you want to continue"

_note "Exec: chown root /oracle/stage"
chown root /oracle/stage
_check_rc $? "chown failed of /oracle/stage. Do you want to continue"

_note "Exec: chgrp root /oracle/stage"
chgrp root /oracle/stage
_check_rc $? "chgrp failed of /oracle/stage. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_oracle/rlv_oracle_client"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_oracle/rlv_oracle_client
_check_rc $? "mkfs failed of /dev/vg_oracle/rlv_oracle_client. Do you want to continue"

####### /oracle/client ######
# check dir
if [[ -d /oracle/client ]]; then
_note "Directory /oracle/client already exist"
else
_note "Exec: mkdir -p -m 755 /oracle/client"
mkdir -p -m 755 /oracle/client
_check_rc $? "mkdir failed of /oracle/client. Do you want to continue"
fi
chown root:sys /oracle/client

_note "Exec: chmod 755 /oracle/client"
chmod 755 /oracle/client
_check_rc $? "chmod failed of /oracle/client. Do you want to continue"

_note "Exec: chown root /oracle/client"
chown root /oracle/client
_check_rc $? "chown failed of /oracle/client. Do you want to continue"

_note "Exec: chgrp root /oracle/client"
chgrp root /oracle/client
_check_rc $? "chgrp failed of /oracle/client. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_openv/rlv_usr_openv"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_openv/rlv_usr_openv
_check_rc $? "mkfs failed of /dev/vg_openv/rlv_usr_openv. Do you want to continue"

####### /usr/openv ######
# check dir
if [[ -d /usr/openv ]]; then
_note "Directory /usr/openv already exist"
else
_note "Exec: mkdir -p -m 755 /usr/openv"
mkdir -p -m 755 /usr/openv
_check_rc $? "mkdir failed of /usr/openv. Do you want to continue"
fi
chown root:sys /usr/openv

_note "Exec: chmod 755 /usr/openv"
chmod 755 /usr/openv
_check_rc $? "chmod failed of /usr/openv. Do you want to continue"

_note "Exec: chown root /usr/openv"
chown root /usr/openv
_check_rc $? "chown failed of /usr/openv. Do you want to continue"

_note "Exec: chgrp root /usr/openv"
chgrp root /usr/openv
_check_rc $? "chgrp failed of /usr/openv. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_openv/rlv_usropenvnetbackup_logs"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_openv/rlv_usropenvnetbackup_logs
_check_rc $? "mkfs failed of /dev/vg_openv/rlv_usropenvnetbackup_logs. Do you want to continue"

####### /usr/openv/netbackup/logs ######
# check dir
if [[ -d /usr/openv/netbackup/logs ]]; then
_note "Directory /usr/openv/netbackup/logs already exist"
else
_note "Exec: mkdir -p -m 755 /usr/openv/netbackup/logs"
mkdir -p -m 755 /usr/openv/netbackup/logs
_check_rc $? "mkdir failed of /usr/openv/netbackup/logs. Do you want to continue"
fi
chown root:sys /usr/openv/netbackup/logs

_note "Exec: chmod 755 /usr/openv/netbackup/logs"
chmod 755 /usr/openv/netbackup/logs
_check_rc $? "chmod failed of /usr/openv/netbackup/logs. Do you want to continue"

_note "Exec: chown root /usr/openv/netbackup/logs"
chown root /usr/openv/netbackup/logs
_check_rc $? "chown failed of /usr/openv/netbackup/logs. Do you want to continue"

_note "Exec: chgrp root /usr/openv/netbackup/logs"
chgrp root /usr/openv/netbackup/logs
_check_rc $? "chgrp failed of /usr/openv/netbackup/logs. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_openv/rlv_usropenv_logs"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_openv/rlv_usropenv_logs
_check_rc $? "mkfs failed of /dev/vg_openv/rlv_usropenv_logs. Do you want to continue"

####### /usr/openv/logs ######
# check dir
if [[ -d /usr/openv/logs ]]; then
_note "Directory /usr/openv/logs already exist"
else
_note "Exec: mkdir -p -m 755 /usr/openv/logs"
mkdir -p -m 755 /usr/openv/logs
_check_rc $? "mkdir failed of /usr/openv/logs. Do you want to continue"
fi
chown root:sys /usr/openv/logs

_note "Exec: chmod 755 /usr/openv/logs"
chmod 755 /usr/openv/logs
_check_rc $? "chmod failed of /usr/openv/logs. Do you want to continue"

_note "Exec: chown root /usr/openv/logs"
chown root /usr/openv/logs
_check_rc $? "chown failed of /usr/openv/logs. Do you want to continue"

_note "Exec: chgrp root /usr/openv/logs"
chgrp root /usr/openv/logs
_check_rc $? "chgrp failed of /usr/openv/logs. Do you want to continue"

_note "Exec: mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_openv/rlv_usropenv_patches"
mkfs -F vxfs -o bsize=8192 -o largefiles /dev/vg_openv/rlv_usropenv_patches
_check_rc $? "mkfs failed of /dev/vg_openv/rlv_usropenv_patches. Do you want to continue"

####### /usr/openv/patches ######
# check dir
if [[ -d /usr/openv/patches ]]; then
_note "Directory /usr/openv/patches already exist"
else
_note "Exec: mkdir -p -m 755 /usr/openv/patches"
mkdir -p -m 755 /usr/openv/patches
_check_rc $? "mkdir failed of /usr/openv/patches. Do you want to continue"
fi
chown root:sys /usr/openv/patches

_note "Exec: chmod 755 /usr/openv/patches"
chmod 755 /usr/openv/patches
_check_rc $? "chmod failed of /usr/openv/patches. Do you want to continue"

_note "Exec: chown root /usr/openv/patches"
chown root /usr/openv/patches
_check_rc $? "chown failed of /usr/openv/patches. Do you want to continue"

_note "Exec: chgrp root /usr/openv/patches"
chgrp root /usr/openv/patches
_check_rc $? "chgrp failed of /usr/openv/patches. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk60 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk60 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk60. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk60"
scsictl -m queue_depth=16 /dev/rdisk/disk60
_check_rc $? "scsictl failed for /dev/rdisk/disk60. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk23 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk23 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk23. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk23"
scsictl -m queue_depth=16 /dev/rdisk/disk23
_check_rc $? "scsictl failed for /dev/rdisk/disk23. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk17 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk17 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk17. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk17"
scsictl -m queue_depth=16 /dev/rdisk/disk17
_check_rc $? "scsictl failed for /dev/rdisk/disk17. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk38 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk38 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk38. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk38"
scsictl -m queue_depth=16 /dev/rdisk/disk38
_check_rc $? "scsictl failed for /dev/rdisk/disk38. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk18 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk18 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk18. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk18"
scsictl -m queue_depth=16 /dev/rdisk/disk18
_check_rc $? "scsictl failed for /dev/rdisk/disk18. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk25 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk25 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk25. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk25"
scsictl -m queue_depth=16 /dev/rdisk/disk25
_check_rc $? "scsictl failed for /dev/rdisk/disk25. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk36 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk36 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk36. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk36"
scsictl -m queue_depth=16 /dev/rdisk/disk36
_check_rc $? "scsictl failed for /dev/rdisk/disk36. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk54 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk54 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk54. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk54"
scsictl -m queue_depth=16 /dev/rdisk/disk54
_check_rc $? "scsictl failed for /dev/rdisk/disk54. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk55 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk55 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk55. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk55"
scsictl -m queue_depth=16 /dev/rdisk/disk55
_check_rc $? "scsictl failed for /dev/rdisk/disk55. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk32 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk32 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk32. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk32"
scsictl -m queue_depth=16 /dev/rdisk/disk32
_check_rc $? "scsictl failed for /dev/rdisk/disk32. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk8 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk8 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk8. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk8"
scsictl -m queue_depth=16 /dev/rdisk/disk8
_check_rc $? "scsictl failed for /dev/rdisk/disk8. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk48 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk48 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk48. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk48"
scsictl -m queue_depth=16 /dev/rdisk/disk48
_check_rc $? "scsictl failed for /dev/rdisk/disk48. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk33 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk33 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk33. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk33"
scsictl -m queue_depth=16 /dev/rdisk/disk33
_check_rc $? "scsictl failed for /dev/rdisk/disk33. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk28 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk28 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk28. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk28"
scsictl -m queue_depth=16 /dev/rdisk/disk28
_check_rc $? "scsictl failed for /dev/rdisk/disk28. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk45 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk45 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk45. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk45"
scsictl -m queue_depth=16 /dev/rdisk/disk45
_check_rc $? "scsictl failed for /dev/rdisk/disk45. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk69 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk69 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk69. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk69"
scsictl -m queue_depth=16 /dev/rdisk/disk69
_check_rc $? "scsictl failed for /dev/rdisk/disk69. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk56 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk56 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk56. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk56"
scsictl -m queue_depth=16 /dev/rdisk/disk56
_check_rc $? "scsictl failed for /dev/rdisk/disk56. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk51 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk51 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk51. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk51"
scsictl -m queue_depth=16 /dev/rdisk/disk51
_check_rc $? "scsictl failed for /dev/rdisk/disk51. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk10 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk10 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk10. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk10"
scsictl -m queue_depth=16 /dev/rdisk/disk10
_check_rc $? "scsictl failed for /dev/rdisk/disk10. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk74 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk74 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk74. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk74"
scsictl -m queue_depth=16 /dev/rdisk/disk74
_check_rc $? "scsictl failed for /dev/rdisk/disk74. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk47 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk47 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk47. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk47"
scsictl -m queue_depth=16 /dev/rdisk/disk47
_check_rc $? "scsictl failed for /dev/rdisk/disk47. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk62 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk62 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk62. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk62"
scsictl -m queue_depth=16 /dev/rdisk/disk62
_check_rc $? "scsictl failed for /dev/rdisk/disk62. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk59 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk59 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk59. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk59"
scsictl -m queue_depth=16 /dev/rdisk/disk59
_check_rc $? "scsictl failed for /dev/rdisk/disk59. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk67 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk67 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk67. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk67"
scsictl -m queue_depth=16 /dev/rdisk/disk67
_check_rc $? "scsictl failed for /dev/rdisk/disk67. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk73 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk73 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk73. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk73"
scsictl -m queue_depth=16 /dev/rdisk/disk73
_check_rc $? "scsictl failed for /dev/rdisk/disk73. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk43 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk43 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk43. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk43"
scsictl -m queue_depth=16 /dev/rdisk/disk43
_check_rc $? "scsictl failed for /dev/rdisk/disk43. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk14 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk14 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk14. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk14"
scsictl -m queue_depth=16 /dev/rdisk/disk14
_check_rc $? "scsictl failed for /dev/rdisk/disk14. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk66 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk66 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk66. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk66"
scsictl -m queue_depth=16 /dev/rdisk/disk66
_check_rc $? "scsictl failed for /dev/rdisk/disk66. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk29 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk29 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk29. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk29"
scsictl -m queue_depth=16 /dev/rdisk/disk29
_check_rc $? "scsictl failed for /dev/rdisk/disk29. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk58 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk58 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk58. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk58"
scsictl -m queue_depth=16 /dev/rdisk/disk58
_check_rc $? "scsictl failed for /dev/rdisk/disk58. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk49 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk49 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk49. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk49"
scsictl -m queue_depth=16 /dev/rdisk/disk49
_check_rc $? "scsictl failed for /dev/rdisk/disk49. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk50 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk50 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk50. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk50"
scsictl -m queue_depth=16 /dev/rdisk/disk50
_check_rc $? "scsictl failed for /dev/rdisk/disk50. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk61 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk61 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk61. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk61"
scsictl -m queue_depth=16 /dev/rdisk/disk61
_check_rc $? "scsictl failed for /dev/rdisk/disk61. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk26 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk26 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk26. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk26"
scsictl -m queue_depth=16 /dev/rdisk/disk26
_check_rc $? "scsictl failed for /dev/rdisk/disk26. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk40 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk40 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk40. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk40"
scsictl -m queue_depth=16 /dev/rdisk/disk40
_check_rc $? "scsictl failed for /dev/rdisk/disk40. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk64 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk64 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk64. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk64"
scsictl -m queue_depth=16 /dev/rdisk/disk64
_check_rc $? "scsictl failed for /dev/rdisk/disk64. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk27 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk27 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk27. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk27"
scsictl -m queue_depth=16 /dev/rdisk/disk27
_check_rc $? "scsictl failed for /dev/rdisk/disk27. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk65 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk65 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk65. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk65"
scsictl -m queue_depth=16 /dev/rdisk/disk65
_check_rc $? "scsictl failed for /dev/rdisk/disk65. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk52 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk52 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk52. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk52"
scsictl -m queue_depth=16 /dev/rdisk/disk52
_check_rc $? "scsictl failed for /dev/rdisk/disk52. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk72 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk72 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk72. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk72"
scsictl -m queue_depth=16 /dev/rdisk/disk72
_check_rc $? "scsictl failed for /dev/rdisk/disk72. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk70 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk70 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk70. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk70"
scsictl -m queue_depth=16 /dev/rdisk/disk70
_check_rc $? "scsictl failed for /dev/rdisk/disk70. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk57 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk57 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk57. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk57"
scsictl -m queue_depth=16 /dev/rdisk/disk57
_check_rc $? "scsictl failed for /dev/rdisk/disk57. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk37 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk37 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk37. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk37"
scsictl -m queue_depth=16 /dev/rdisk/disk37
_check_rc $? "scsictl failed for /dev/rdisk/disk37. Do you want to continue"

_note "Exec: scsimgr save_attr -D /dev/rdisk/disk71 -a load_bal_policy=least_cmd_load"
scsimgr save_attr -D /dev/rdisk/disk71 -a load_bal_policy=least_cmd_load
_check_rc $? "scsimgr failed for /dev/rdisk/disk71. Do you want to continue"

_note "Exec: scsictl -m queue_depth=16 /dev/rdisk/disk71"
scsictl -m queue_depth=16 /dev/rdisk/disk71
_check_rc $? "scsictl failed for /dev/rdisk/disk71. Do you want to continue"

} 2>&1 | tee $instlog # tee is used in case of interactive run.
----

Quite impressive, right?


== A life example (hpx189)

Nothing better then the real stuff, right? A life example to proof the concept:

Main Steps to execute:

* become root via +sudo su -+
* cd /home/gdhaese1/projects/SANmigration
* bdf | grep -v vg00
  (/dev/vg_test/lvol1 14221312   20567 13313206    0% /test)
* ./save_san_layout.sh (SANCONF=/tmp/SAN_layout_of_hpx189.conf)
* ./create_san_layout_script.sh
  - Edit diskmap Y/n ? n
  - Shall we add vgexport command(s) to make_SAN_layout_of_hpx189.sh y/N ? y
* cat make_SAN_layout_of_hpx189.sh  (verify the script to execute)
* ./make_SAN_layout_of_hpx189.sh
*  mount /test
* bdf | grep -v vg00
  (/dev/vg_test/lvol1 14221312   20567 13313206    0% /test)

=== Output of make_SAN_layout_of_hpx189.sh

the output is saved as _Installation Log: /var/adm/install-logs/make_SAN_layout_of_hpx189.scriptlog_ (which is mentioned in the header of the banner of the script). To view it just cat this file:

----
#-> cat /var/adm/install-logs/make_SAN_layout_of_hpx189.scriptlog
###############################################################################################
  Installation Script: make_SAN_layout_of_hpx189.sh
              Purpose: Write the SAN creation script (make_SAN_layout_of_hpx189.sh)
           OS Release: 11.31
                Model: ia64
    Installation Host: hpx189
    Installation User: root
    Installation Date: 2012-08-14 @ 14:48:13
     Installation Log: /var/adm/install-logs/make_SAN_layout_of_hpx189.scriptlog
###############################################################################################
 ** Running on HP-UX 11.31
 ** Created temporary directory /tmp/san007349
 ** Exec: umount /dev/vg_test/lvol1
 ** Exec: vgchange -a n /dev/vg_test
Volume group "/dev/vg_test" has been successfully changed.
 ** vgexport -m /tmp/san007349/vg_test.mapfile -f /tmp/san007349/vg_test.outfile  /dev/vg_test
vgexport: Volume group "/dev/vg_test" has been successfully removed.
 ** Saved /etc/lvmtab as /tmp/san007349/lvmtab.out
 ** Exec: pvcreate -f /dev/rdisk/disk4
Physical volume "/dev/rdisk/disk4" has been successfully created.
 ** Exec: pvcreate -f /dev/rdisk/disk5
Physical volume "/dev/rdisk/disk5" has been successfully created.
 ** Exec: mkdir -p -m 755 /dev/vg_test
 ** Exec: mknod /dev/vg_test/group c 64 0x010000
 ** Created /dev/vg_test/group with major nr (64) and minor nr (0x010000)
 ** vgcreate -l 255 -s 16 -p 16 -e 868  /dev/vg_test /dev/disk/disk4
Volume group "/dev/vg_test" has been successfully created.
Volume Group configuration for /dev/vg_test has been saved in /etc/lvmconf/vg_test.conf
 ** Exec: lvcreate  -r N -n lvol1 /dev/vg_test
Logical volume "/dev/vg_test/lvol1" has been successfully created with
character device "/dev/vg_test/rlvol1".
Volume Group configuration for /dev/vg_test has been saved in /etc/lvmconf/vg_test.conf
 ** Exec: lvextend -l 868 /dev/vg_test/lvol1
Logical volume "/dev/vg_test/lvol1" has been successfully extended.
Volume Group configuration for /dev/vg_test has been saved in /etc/lvmconf/vg_test.conf
 ** Exec: mkfs -F vxfs -o bsize=1024 -o largefiles /dev/vg_test/rlvol1
    version 6 layout
    14221312 sectors, 14221312 blocks of size 1024, log size 16384 blocks
    largefiles supported
 ** Directory /test already exist
 ** Exec: chmod 755 /test
 ** Exec: chown root /test
 ** Exec: chgrp root /test
 ** Exec: pvchange  -t 60 /dev/disk/disk4
Physical volume "/dev/disk/disk4" has been successfully changed.
Volume Group configuration for /dev/vg_test has been saved in /etc/lvmconf/vg_test.conf
 ** Exec: scsimgr save_attr -D /dev/rdisk/disk4 -a load_bal_policy=round_robin
Value of attribute load_bal_policy saved successfully
 ** Exec: scsictl -m queue_depth=8 /dev/rdisk/disk4
----

The only thing which is not done automatically is mounting the logical volumes. Do this by hand.
