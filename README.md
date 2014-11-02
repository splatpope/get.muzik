get.muzik
=========

Grabs a youtube playlist's music and converts it to MP3.

INSTALLING : 
============

The INSTALL.sh script will only do you any good if you're using a debian based system.

If you are using another distro, then just make sure you have installed the following components :
* youtube-dl (available on github)
* ffmpeg 
* lame

Then, make the directory mp3/ inside the repo's root.

HOW TO USE :
============

get.muzik simply takes a youtube playlist ID and turns it's contents into mp3 files. This is of course a neat way to grab a large amount of songs easily and make them ready for use on external peripherals.

./get.muzik [-h | --help | -d | -c | -o TARGET_MP3_FOLDER ] PLAYLIST_ID

* -h : get help
* -c : only convert files present in ./m4a/ (for example after a -d)
* -d : only download raw m4a sound data in ./m4a/
* -o TARGET_MP3_FOLDER : provide a target folder for the processed MP3 files

By default, get.muzik will put the processed MP3 files in ./mp3/
