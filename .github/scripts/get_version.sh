#!/bin/bash

pubspec_file="pubspec.yaml"

versionLine=$(grep -n "version:" "$pubspec_file")
versionName=$(echo "$versionLine" | grep -o "[0-9]*\.[0-9]*\.[0-9]")

majorName=$(echo "$versionName" | cut -d"." -f 1)
minorName=$(echo "$versionName" | cut -d"." -f 2)
patchName=$(echo "$versionName" | cut -d"." -f 3)

originalVersionName="v$majorName.$minorName.$patchName"

echo "$originalVersionName"