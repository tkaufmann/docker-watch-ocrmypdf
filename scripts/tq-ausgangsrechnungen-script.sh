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

# Der Name der Datei in der Nextcloud
targetFile=$(urlencode "$filename")

# Upload Taquiri
targetFolder="/Taquiri%20Intern/Buchhaltung/Taquiri%20Rechnungsausgang/"
target="$CLOUD_TAQUIRI_PATH$targetFolder$targetFile"
curl -u "$CLOUD_TAQUIRI_USER:$CLOUD_TAQUIRI_PASS" -T "$file" "$target"
res_upload_taquiri=$?

# Upload Stb
targetFolder="/Rechnungsausgang/"
target="$CLOUD_STB_PATH$targetFolder$targetFile"
curl -k -u "$CLOUD_STB_USER:$CLOUD_STB_PASS" -T "$file" "$target"
res_upload_penne=$?

if [ "${res_upload_penne}" == 0 ] && [ "${res_upload_taquiri}" == 0 ];
then
    # Upload erfolgreich
#    printf "Datei: $filename\nUpload Stb Exit Code: $res_upload_penne\nUpload Taquiri Exit Code: $res_upload_taquiri" | /usr/bin/mail -s "Erfolg beim Taquiri Ausgangsrechnungen Nextcloud-Upload" tim@timkaufmann.de
    rm -f "$file"
else
    # Upload fehlgeschlagen
#    printf "Datei: $filename\nUpload Stb Exit Code: $res_upload_penne\nUpload Taquiri Exit Code: $res_upload_taquiri" | /usr/bin/mail -s "Problem beim Taquiri Ausgangsrechnungen Nextcloud-Upload" tim@timkaufmann.de
    echo "Upload fehlgeschlagen"
fi
