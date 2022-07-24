#!/bin/bash

copy_cmd() {
    curl -u $NEXTCLOUD_USER:$NEXTCLOUD_PASSWORD -T $1 "$NEXTCLOUD_PATH$2"
}

copy_cmd $1 $2
