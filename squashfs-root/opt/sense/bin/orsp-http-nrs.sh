#!/bin/sh -e

if [ ! -f ./curl ]; then
    echo "[ERROR] Please run the script from bin directory"
    exit 1
fi

if [ -z $1 ]; then
    echo "[ERROR] Pass URL as command line argument"
    exit 1
fi

ctx=$(LD_LIBRARY_PATH=../lib ./curl -s http://127.0.0.1:60287/nrsv2/create)

if [ ! $ctx -eq $ctx ] || [ -z $ctx ]; then  # not integer or empty
    echo "[ERROR] /nrsv2/create failed"
    exit 1
fi

res=$(LD_LIBRARY_PATH=../lib ./curl -s -G http://127.0.0.1:60287/nrsv2/query/$ctx/5000/$1)

LD_LIBRARY_PATH=../lib ./curl -s http://127.0.0.1:60287/nrsv2/delete/$ctx

if [ -z "$res" ]; then
    echo "[ERROR] /query/nrs failed"
    exit 1
fi

echo
echo $res | sed "s/, /, \n/g"
