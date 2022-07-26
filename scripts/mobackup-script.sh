#!/bin/bash

source lib.sh

file=$1
filename=$2
# extension=$3
# folder=$4
# action=$5

#echo "file: $file"
#echo "filename: $filename"
#echo "extension: $extension"
#echo "folder: $folder"
#echo "action: $action"

# Der Name der Datei in der Nextcloud
targetFile=$(urlencode "$filename")

# Upload Taquiri
targetFolder="/Taquiri%20Intern/MonkeyOffice%20Backup/"
target="$CLOUD_TAQUIRI_PATH$targetFolder$targetFile"
curl -u "$CLOUD_TAQUIRI_USER:$CLOUD_TAQUIRI_PASS" -T "$file" "$target"
res_upload_taquiri=$?

if [ "${res_upload_taquiri}" == 0 ];
then
    rm "$file"
    echo "OK"
else
    echo "nOK"
fi
