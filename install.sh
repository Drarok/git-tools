#!/bin/bash

if [[ -z "$1" ]]; then
    DEFAULT_INSTALL_PATH="/usr/local/bin";
else
    DEFAULT_INSTALL_PATH="$1";
fi

echo -n "Install git-tools to [$DEFAULT_INSTALL_PATH]: ";
read INSTALL_PATH;
if [[ -z "$INSTALL_PATH" ]]; then
    INSTALL_PATH="$DEFAULT_INSTALL_PATH";
fi

if [[ ! -d "$INSTALL_PATH" ]]; then
    echo "$INSTALL_PATH is not a valid path";
    exit 1;
fi

BIN_PATH=$(pwd);
for TOOL in *; do
    if [[ "$TOOL" == "README.markdown" || "$TOOL" == "install.sh" ]]; then
        continue;
    fi

    INSTALL_CMD="ln -sv $BIN_PATH/$TOOL $INSTALL_PATH";
    echo "$INSTALL_CMD";
    $INSTALL_CMD;
done
