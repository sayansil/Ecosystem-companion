#!/bin/bash

if [ "$1" == "-h" ]; then
  echo "Usage: command [release-type]"
  echo "Where release-type: major / minor / patch (default)"
  exit 0;
fi

versionLine=$(grep -n "version:" pubspec.yaml)
versionLineNumber=$(echo "$versionLine" | cut -d":" -f 1)

versionName=$(echo "$versionLine" | grep -o "[0-9]*\.[0-9]*\.[0-9]")

majorName=$(echo "$versionName" | cut -d"." -f 1)
minorName=$(echo "$versionName" | cut -d"." -f 2)
patchName=$(echo "$versionName" | cut -d"." -f 3)

originalVersionName="$majorName.$minorName.$patchName"

if [ "$1" == major ]; then
  majorName=$((majorName + 1))
  minorName=0
  patchName=0
elif [ "$1" == minor ]; then
  minorName=$((minorName + 1))
  patchName=0
else
  patchName=$((patchName + 1))
fi
printf -v majorCode "%03d" $majorName
printf -v minorCode "%02d" $minorName
printf -v patchCode "%02d" $patchName

finalVersionName="$majorName.$minorName.$patchName"
finalVersionCode="17$majorCode$minorCode$patchCode"
finalVersion="version: $finalVersionName+$finalVersionCode"

awkStr="NR==$versionLineNumber {\$0=\"$finalVersion\"} 1"
awk "$awkStr" pubspec.yaml > pubspec.tmp && mv pubspec.tmp pubspec.yaml
echo "Bumping up version to $finalVersionCode ($originalVersionName => $finalVersionName)"