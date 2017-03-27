#!/usr/local/bin/bash
# Add bash path to Plex path.
#set path = ($path /usr/local/bin)

# Sleep for a pseudorandom period (up to 10 seconds) to limit the number of instances that start at once
# $$ = process % = modulo
sleep `echo $$%10 | bc`

now=`date +"%Y%m%d"`
echo "Script started ${now}" >> /tmp/comchap.log

starttime=`date +%s`
echo "At this second mark: ${starttime}" >> /tmp/comchap.log

filedirname=$(dirname "$1")
echo "filedirname: ${filedirname}" >> /tmp/comchap.log

fullfilename=$(basename "$1")
echo "fullfilename: ${fullfilename}"

extensioname="${fullfilename##*.}"
echo "extensioname: ${extensioname}" >> /tmp/comchap.log 

filename="${fullfilename%.*}"
echo "filename: ${filename}" >> /tmp/comchap.log 

echo "Processing: $now $1" >> /tmp/comchap.log
# Everything betwen here and the next # needs to be on one line! Make sure there's no linewrap.
/usr/local/comskiplinux/comchap/comcut --ffmpeg=/usr/local/bin/ffmpeg --comskip=/usr/local/comskiplinux/Comskip-master/comskip --lockfile=/tmp/comchap.lock --comskip-ini=/usr/local/comskiplinux/Comskip-master/comskip.ini "$1" "/tmp/${fullfilename}"

# Re-encode as an mp4 file so we keep the original
ffmpeg -i "/tmp/${fullfilename}" -acodec copy -vcodec copy "${filedirname}/${filename}.mp4"

#
endtime=`date +%s`
timediff=`expr $endtime - $starttime`
echo "Complete, ran for: $timediff seconds $1"
