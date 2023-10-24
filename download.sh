#!/usr/bin/env bash
#GNU General Public License v3.0
#knedl1k 2023

BASE_URL="https://i.iinfo.cz/images"

function help(){
   echo "usage: bash download.sh [<args>]"
   echo "suitable arguments are:"
   echo "-a  .. downloads pictures from saturday and sunday, called LD23_SatXYZ and LD23_SunXYZ, respectively."
   echo "-s  .. downloads pictures from saturday, called LD23_SatXYZ."
   echo "-n  .. downloads pictures from sunday, called LD23_SunXYZ."
   echo "-h  .. prints this help menu."
}

function checkWritePerms(){
   if [[ ! -w "." ]]; then #write perms must be assigned
      echo "unable to write to current directory!\n"
      exit 2
   fi 
}

function saturday(){
   checkWritePerms
   FILE_PREFIX="LD23_Sat"
   echo "Saturday photos are being downloaded to the current directory!"

   wget --quiet -O "$FILE_PREFIX""000" "$BASE_URL/200/linuxdays-2023-sobota.webp"
   for i in {1..106}; do
      if [ "$i" -lt 60 ]; then
         if [ "$i" -lt 10 ]; then
            FILE_NAME="$FILE_PREFIX""00$i"
         else
            FILE_NAME="$FILE_PREFIX""0$i"
         fi
         URL="$BASE_URL/683/linuxdays-2023-sobota-$i.webp"
      elif [ "$i" -ge 60 ] && [ "$i" -lt 88 ]; then
         FILE_NAME="$FILE_PREFIX""0$i"
         URL="$BASE_URL/390/linuxdays-2023-sobota-$(("$i"-60 +1)).webp"
      else
         if [ "$i" -lt 100 ]; then
            FILE_NAME="$FILE_PREFIX""0$i"
         else
            FILE_NAME="$FILE_PREFIX""$i"
         fi
         URL="$BASE_URL/357/linuxdays-2023-sobota-$(("$i"-88 +1)).webp"
      fi
      wget --quiet -O "$FILE_NAME" "$URL"
   done
   echo "Saturday downloaded."
}

function sunday(){
   checkWritePerms
   FILE_PREFIX="LD23_Sun"
   echo "Sunday photos are being downloaded to the current directory!"

   for i in {1..97}; do
      if [ "$i" -lt 29 ]; then
         if [ "$i" -lt 10 ]; then
            FILE_NAME="$FILE_PREFIX""0$i"
         else
            FILE_NAME="$FILE_PREFIX""$i"
         fi
         URL="$BASE_URL/585/linuxdays-2023-nedele-$i.webp"
      elif [ "$i" -ge 29 ] && [ "$i" -lt 56 ]; then
         FILE_NAME="$FILE_PREFIX""$i"
         URL="$BASE_URL/163/linuxdays-2023-nedele-$(("$i"-29 +1)).webp"
      elif [ "$i" -ge 56 ] && [ "$i" -lt 92 ]; then
         FILE_NAME="$FILE_PREFIX""$i"
         URL="$BASE_URL/662/linuxdays-2023-nedele-$(("$i"-56 +1)).webp"
      else
         FILE_NAME="$FILE_PREFIX""$i"
         URL="$BASE_URL/231/linuxdays-2023-nedele-$(("$i"-92 +1)).webp"
      fi
      wget --quiet -O "$FILE_NAME" "$URL"
   done
   echo "Sunday downloaded."
}


while getopts ":asnh" opt; do
   case $opt in
      a) #download pictures from LinuxDays2023 saturday & sunday 
         saturday
         sunday
         echo "Download completed."
         ;;
      s) #download pictures from LinuxDays2023 saturday
         saturday
         echo "Download completed."
         ;;
      n) #download pictures from LinuxDays2023 sunday
         sunday
         echo "Download completed."
         ;;
      h) #print help menu
         help
         ;;
      \?)
         printf "wrong argument: '-%s'\n" "$OPTARG" >&2
         help
         exit 1
         ;;
   esac
done

#no argument on input
if [ $# -eq 0 ]; then
   help
   exit 1
fi