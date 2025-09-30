#!/bin/sh -e

if [ ! -f ./curl ]; then
    echo "[ERROR] Please run the script from bin directory"
    exit 1
fi

LD_LIBRARY_PATH=../lib ./curl -s http://127.0.0.1:60287/diag/dump
