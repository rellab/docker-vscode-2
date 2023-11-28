#!/bin/bash

CODESTATUS=`$CODEBIN tunnel user show`

if [ $CODESTATUS = "not logged in" ]; then
    $CODEBIN tunnel user login --provider $CODEPROVIDER
fi

$CODEBIN tunnel --name=$CODETUNNEL --accept-server-license-terms
