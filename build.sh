#!/bin/bash

clear

date=$(date +"%Y_%m_%d")

mkdir "target/debug/$date" > /dev/null 2>&1
cp -a -r "data/" "target/debug/$date/data/"
cp -a -r "src/" "target/debug/$date/src/"

odin build ./src -out:./target/debug/$date/Monochrome