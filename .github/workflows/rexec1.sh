#!/bin/bash
#(C) Copyright 2020 Hewlett Packard Enterprise Development LP

if [ $# -le 0 ]
then
   echo "Remote command missing: Usage: \"rexec <remote command with paramaters>\""
   exit -1
fi

# Ideally should be set as an environment variable to reuse this script
SSHUSER="radhakrushnahost"
SSHPASS="host123"
REMOTE_IP="192.168.100.103"
REMOTE_TYPE=$1

REMOTE_COMMAND="$2"
# Clear known_hosts
rm -f ~/.ssh/known_hosts
if [$REMOTE_TYPE == "ssh"]
then
   command_with_sshpass="sshpass -p $SSHPASS ssh -o StrictHostKeychecking=no -n -l $SSHUSER $REMOTE_IP $REMOTE_COMMAND"
if else [$REMOTE_TYPE == "scp"]
   command_with_sshpass="sshpass -p $SSHPASS scp -r /home/radha/Desktop/actions-runner/_work/railways_user-api/railways_user-api/katalonTest $SSHUSER@$REMOTE_IP:/home/radhakrushnahost/Desktop/"
fi

echo "$command_with_sshpass"
tmp_remote_error_file=$(mktemp)
remote_output="`$command_with_sshpass 2>$tmp_remote_error_file`"
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
