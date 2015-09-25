#!/bin/sh

LOG_PATH=~/Dropbox/logs

if [ ! -d $LOG_PATH ]
	then 
	mkdir $LOG_PATH
	echo "Created log directory" 
fi



action=$1
shift

# Log for yesterday
if [ "$action" = 'y' ]
	then
	NOW=$(date -v-1d '+%F')
	action=$1
	shift
else
	NOW=$(date '+%F')	
fi

TODAY_FILENAME="log-$NOW.txt"

# Don't use the actual log - just a debug one
if [ "$action" = 'debug' ]
	then
	if [ ! -d $LOG_FILE/debug ]
		then 
		mkdir $LOG_FILE/debug
		echo "Created debug directory" 
	fi
	TODAY_FILENAME="debug/$TODAY_FILENAME"
	action=$1
	shift
fi

case $action in
	"a" )
		# add text to today's file
		echo "$(date '+%T') $* " >> $LOG_PATH/$TODAY_FILENAME
		;;
	"p" )
		# print today's file
		if [ -e $LOG_PATH/$TODAY_FILENAME ]
		then
			echo $LOG_PATH/$TODAY_FILENAME
			echo ---------------------
			cat $LOG_PATH/$TODAY_FILENAME
		else
			echo "No log file created for today"
		fi
		;;
	"d" )
		# delete the last entry in today's file
		if [ -e $LOG_PATH/$TODAY_FILENAME ]
		then
			sed '$d' < $LOG_PATH/$TODAY_FILENAME > /tmp/LOG_TEMP_FILE 
			mv /tmp/LOG_TEMP_FILE $LOG_PATH/$TODAY_FILENAME
		else
			echo "No log file created for today"
		fi
		;;
	"clean" )
		# clean up the debugging files
		rm -f $LOG_PATH/debug/*
		;;
	"g" )
		grep "$*" $LOG_PATH/*
		;;
	"f" )
		echo $LOG_PATH/$TODAY_FILENAME
		;;
	*)
		echo "Usage l [debug] a|p|d|g|clean [message]"
		;;
esac
