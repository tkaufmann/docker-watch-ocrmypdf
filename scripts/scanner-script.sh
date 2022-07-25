#!/bin/bash

source lib.sh

file=$1
filename=$2
extension=$3
# folder=$4
# action=$5

#echo "file: $file"
#echo "filename: $filename"
#echo "extension: $extension"
#echo "folder: $folder"
#echo "action: $action"

if [[ ! "$extension" =~ ^(pdf|PDF)$ ]];
then
    echo "$extension is not supported. Skipping."
    exit
fi

# Der Name der Datei in /tmp
tmpfile="/tmp/$filename"

ocrmypdf -l eng+deu --rotate-pages --deskew --clean --force-ocr --jobs 2 --output-type pdfa --optimize 1 "$file" "$tmpfile"

# Der Name der Datei in der Nextcloud
targetFile=$(urlencode "$filename")

# Upload Taquiri
targetFolder="/Scanner/"
target="$CLOUD_TAQUIRI_PATH$targetFolder$targetFile"
curl -u "$CLOUD_TAQUIRI_USER:$CLOUD_TAQUIRI_PASS" -T "$tmpfile" "$target"
res_upload_taquiri=$?

if [ "${res_upload_taquiri}" == 0 ];
then
    rm "$file"
    rm "$tmpfile"
fi
