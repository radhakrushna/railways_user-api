#!/bin/bash
#(C) Copyright 2020 Hewlett Packard Enterprise Development LP

if [ $# -le 0 ]
then
   echo "Remote command missing: Usage: \"rexec <remote command with paramaters>\""
   exit -1
fi
echo "HI--1"

# Ideally should be set as an environment variable to reuse this script
SSHUSER="radhakrushnahost"
SSHPASS="host123"
REMOTE_IP="127.0.0.1"

REMOTE_COMMAND="$*"
# Clear known_hosts
rm -f ~/.ssh/known_hosts
echo "HI--2"
command_with_sshpass="sshpass -p $SSHPASS ssh -o StrictHostKeychecking=no -n -l $SSHUSER $REMOTE_IP $REMOTE_COMMAND"
echo "HI--3"
tmp_remote_error_file=$(mktemp)
remote_output="`$command_with_sshpass 2>$tmp_remote_error_file`"
echo "HI--4"
remote_return_code=$?
echo "HI--5"
if [ $remote_return_code != 0 ] #  && $remote_output == "" ]
then
   echo "HI--6"
   remote_error=$(< $tmp_remote_error_file)
   echo "HI--7"
   rm -rf $tmp_remote_error_file
   echo "HI--8"
   if [ ! -z "$remote_error" ]
   then
      echo "$remote_error"
      echo "HI--9"
      if [ ! -z "$remote_output" ]
      then
         echo "$remote_output"
         echo "HI--10"
      fi
   fi
   echo "HI--11"
   exit $remote_return_code
fi

echo "$remote_output"
echo "HI--13"
exit $remote_return_code
