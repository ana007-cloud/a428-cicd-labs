#!/bin/bash -ex
isExistApp=$(pgrep node)
if [[ -n $isExistApp ]]; then
    kill -9 $isExistApp
fi
