#!/bin/sh

LOG_PATH=~/logs

if [ ! -d $LOG_FILE ]
	then 
	mkdir $LOG_FILE
	echo "Created log directory" 
fi



action=$1
shift

if [ "$action" = 'y' ]
	then
	NOW=$(date -v-1d '+%F')
	action=$1
	shift
else
	NOW=$(date '+%F')	
fi

TODAY_FILENAME="log-$NOW.txt"

if [ "$action" = 'debug' ]
	then
	if [ ! -d $LOG_FILE/debug ]
		then 
		mkdir $LOG_FILE/debug#
		echo "Created debug directory" 
	fi
	TODAY_FILENAME="debug/$TODAY_FILENAME"
	action=$1
	shift
fi

echo $action $TODAY_FILENAME

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
	*)
		echo "Usage l [debug] a|p|d|g|clean [message]"
		;;
esac
