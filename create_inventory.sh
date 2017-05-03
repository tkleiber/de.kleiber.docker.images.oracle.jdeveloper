#!/bin/sh
# Create Central Inventory
output=`id`
UserID=`echo $output | cut -f1 -d ' ' | cut -f2 -d '=' | cut -f1 -d '('`
if [ "$UserID" != "0" ]; then
echo "This script must be executed as root"
exit 1
fi
if [ $# -ne 2 ]
then
echo "Error in $0 - Invalid Argument Count"
echo "Syntax: $0 inventory_location group_name"
exit
fi
echo "Setting the inventory to $1"
echo "Setting the group name to $2"
INVDIR=/etc
PLATFORMID=`uname -a | awk '{{print $1}}'`


if [ "$PLATFORMID" = "Linux" ]
then
INVDIR=/etc
fi


if [ "$PLATFORMID" = "SunOS" ]
then
INVDIR=/var/opt/oracle
fi


if [ "$PLATFORMID" = "HP-UX" ];
then
INVDIR=/var/opt/oracle
fi


if [ "$PLATFORMID" = "AIX" ]
then
INVDIR=/etc
fi


echo "Creating inventory pointer file in $INVDIR directory"
if [ -d $INVDIR ]; then
chmod 755 $INVDIR;
else
mkdir -p $INVDIR;
fi
INVPTR=${INVDIR}/oraInst.loc
INVLOC=$1
GRP=$2
PTRDIR="`dirname $INVPTR`";
# Create the software inventory location pointer file
if [ ! -d "$PTRDIR" ]; then
mkdir -p $PTRDIR;
fi
echo "Creating the Oracle inventory pointer file ($INVPTR)";
echo    inventory_loc=$INVLOC > $INVPTR
echo    inst_group=$GRP >> $INVPTR
chmod 644 $INVPTR
# Create the inventory directory if it doesn't exist
if [ ! -d "$INVLOC" ];then
echo "Creating the Oracle inventory directory ($INVLOC)";
mkdir -p $INVLOC;
fi
echo "Changing permissions of $1 to 770.";
chmod -R g+rw,o-rwx $1;
if [ $? != 0 ]; then
echo "OUI-35086:WARNING: chmod of $1 to 770 failed!";
fi
echo "Changing groupname of $1 to $2.";
chgrp -R $2 $1;
if [ $? != 0 ]; then
echo "OUI-10057:WARNING: chgrp of $1 to $2 failed!";
fi
echo "The execution of the script is complete"


exit 0