#!/bin/bash
#(C) Copyright 2020 Hewlett Packard Enterprise Development LP

if [ $# -le 0 ]
then
   echo "Remote command missing: Usage: \"rexec <remote command with paramaters>\""
   exit -1
fi

SSHUSER="radhakrushnahost"
SSHPASS="host123"
REMOTE_IP="192.168.100.90"

REMOTE_COMMAND="$*"
# Clear known_hosts
rm -f ~/.ssh/known_hosts
command_with_sshpass="sshpass -p $SSHPASS ssh -o StrictHostKeychecking=no -n -l $SSHUSER $REMOTE_IP $REMOTE_COMMAND"

tmp_remote_error_file=$(mktemp)
remote_output="`$REMOTE_COMMAND 2>$tmp_remote_error_file`"
remote_return_code=$?
if [ $remote_return_code != 0 ] #  && $remote_output == "" ]
then
   remote_error=$(< $tmp_remote_error_file)
   rm -rf $tmp_remote_error_file
   if [ ! -z "$remote_error" ]
   then
      echo "$remote_error"
      if [ ! -z "$remote_output" ]
      then
         echo "$remote_output"
      fi
   fi
   exit $remote_return_code
fi

echo "$remote_output"
exit $remote_return_code
