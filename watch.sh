#!/bin/bash

# If set, use WOCR_CONSUME_PATH, else use /consume
WOCR_CONSUME_PATH=${WOCR_CONSUME_PATH:-/consume}
# Remove trailing slash if exists
WOCR_CONSUME_PATH=${WOCR_CONSUME_PATH%/}

inotifywait -r -m $WOCR_CONSUME_PATH -e create -e moved_to --exclude '/\.' |
    while read -r folder action filename; do
        # Is this a change within a subfolder?
        subdirectory=""
        if [[ "$folder" =~ ^$WOCR_CONSUME_PATH/(.*?)/$ ]];
        then
            subdirectory=${BASH_REMATCH[1]}
        else
            echo "File action in root folder detected. Cannot handle that. Aborting"
            continue
        fi

        file=$folder$filename
        folder=${folder%/} # some more trailing slash removal
        extension="${filename##*.}"

        # Debugging output
        # echo "WOCR_CONSUME_PATH: $WOCR_CONSUME_PATH"
        # echo "folder: $folder"
        # echo "action: $action"
        # echo "filename: $filename"
        # echo "extension: $extension"
        # echo "file: $file"
        # echo "subdirectory: $subdirectory"

        # Wait for filetransfer to complete
        filesize=$(stat -c%s "$file")
        sleep 1
        while [[ $filesize -lt $(stat -c%s "$file") ]]; do
            filesize=$(stat -c%s "$file")
            echo "Waiting for transfer to finish (size=$filesize)."
            sleep 1
        done

        # Run command for subfolder
        scriptVarName="WOCR_SCRIPT_$subdirectory"
        if [ -z "${!scriptVarName}" ];
        then
            echo "$scriptVarName is not set. Nothing to do."
            continue
        else
            scriptCmd=$(printf '%s\n' "${!scriptVarName}")
            echo "Running $scriptCmd"
            $scriptCmd "$file" "$filename" "$extension" "$folder" "$action"
        fi

    done
