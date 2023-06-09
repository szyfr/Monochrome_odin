#!/bin/bash

clear

date=$(date +"%Y_%m_%d")

mkdir "target/debug/$date" > /dev/null 2>&1
cp -r -u "data/" "target/debug/$date/data/"
cp -r -u "src/" "target/debug/$date/src/"

odin build ./src -out:./target/debug/$date/Monochrome -target:wasi_wasm 