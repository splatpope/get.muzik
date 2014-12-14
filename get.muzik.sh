#!/bin/bash
IFS="$(printf '\n\t')"

echo
echo "Initializing get.muzik Youtube Playlist MP3 Extractor..."
sleep 1s


RAW_DIR="./m4a"; [[ ! -d $RAW_DIR ]] && mkdir $RAW_DIR
WAV_DIR="./wav"; mkdir $WAV_DIR

function cleanup {
	echo "[notice] Cleaning up..."
	if [[ $convert = "true" ]]; then
		rm -rf $RAW_DIR
		rm -rf $WAV_DIR
	fi
	echo "Finished."
}

trap cleanup EXIT

convert="true"
download="true"

if [[ $# = 0 || ($# = 1 && $1 = "--help") ]]; then
	set "-h"
fi


while getopts ":hcdo:" opt; do
	case $opt in
		h)
			echo "get.muzik Youtube Playlist MP3 Extractor :
Takes a playlist URL as argument, downloads the audio of its videos and converts it to ./mp3
Options:
	-h or --help : Show this help
	-c : Convert m4a to mp3 only. A m4a directory with files to process must exist.
	-d : Download raw m4a only
	-o TARGET_DIR : Provide a target directory for the processed mp3 files."

			exit
			
			;;
		c)
			download="false"
			if [[ -z $(ls $RAW_DIR) ]]; then
				echo "[error] raw m4a files not found. Exiting..."
				exit
			fi
			;;
		d)
			convert="false"
			
			;;
		o)
			output="true"
			output_dir=$OPTARG
			
			;;
		:)
			echo "[error] $OPTARG requires target directory name."
			exit
			
			;;
	
	esac
done

shift $((OPTIND-1))

PLAYLIST_ID=$1

if [[ -z $PLAYLIST_ID ]]; then
	echo "[error] You need to provide a playlist ID."
	exit
fi



if [[ $output = "true" ]]; then
	MP3_DIR=$output_dir
else
	MP3_DIR="./mp3"
fi
echo
if [[ ! -d $MP3_DIR ]]; then
	echo "[query] Target MP3 directory does not exist. Create it ? [yes/EXIT]"
	select answer in "Yes" "Exit"; do
		case $answer in
			Yes) mkdir $MP3_DIR; break;;
			Exit) exit;;
		esac
    done
fi
echo
echo "[notice] Downloading raw m4a sound files from the playlist..."
sleep 1s
echo
if [[ $download = "true" ]]; then
	cd $RAW_DIR
	youtube-dl -x $PLAYLIST_ID
	cd ..
fi
echo
if [[ $convert = "true" ]]; then
	for files in $RAW_DIR/* ; do
		echo "[extraction] Extracting raw WAV info from $files ..."
		echo
		noext=${files##*/}
		avconv -i $files $WAV_DIR/${noext%.m4a}.wav #>/dev/null 2>&1
		echo
		echo "[encoding] Encoding raw WAV of $files into final MP3 with VBR ..."
		lame -V2 $WAV_DIR/${noext%.m4a}.wav ${MP3_DIR}/${noext%.m4a}.mp3 #>/dev/null 2>&1
		echo
		echo "[notice] MP3 conversion for $files finished."
		echo
	done
fi

