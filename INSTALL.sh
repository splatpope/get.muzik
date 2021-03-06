#!/bin/bash



has_youtubedl=$(which youtube-dl)
has_avconv=$(which avconv)
has_lame=$(which lame)

if [[ $USER != "root" ]]; then
	echo "[error] Please launch with sudo."
	exit
fi

if [[ -z $has_youtubedl ]]; then
	echo "[notice] You do not have youtube-dl. Installing it.."
	curl https://yt-dl.org/downloads/2014.10.30/youtube-dl -o /usr/local/bin/youtube-dl
	chmod a+x /usr/local/bin/youtube-dl
else
	echo "[notice] youtube-dl detected. Carrying on..."
fi

if [[ -z $has_avconv ]]; then
	echo "[notice] You do not have avconv. Installing it..."
	apt-get install libav-tools
else
	echo "[notice] avconv detected. Carrying on..."
fi

if [[ -z $has_lame ]]; then
	echo "[notice] You do not have lame. Installing it..."
	apt-get install lame
else
	echo "[notice] lame detected. Carrying on..."
fi

if [[ ! -d ./mp3/ ]]; then
	mkdir ./mp3/
	chmod a+rw ./mp3/
	echo "[notice] ./mp3/ folder created. get.muzik will put processed mp3 files here by default."
fi


echo "[notice] Finished."
