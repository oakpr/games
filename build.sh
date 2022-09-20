#!/bin/bash

# Clone all of the games into the working directory
mkdir -p $(dirname $0)/dist/games
cd $(dirname $0)/dist/games
cat ../../games.list | while read line; do
	REPO=$(echo $line | cut -d ' ' -f 1)
	BRANCH=$(echo $line | cut -d ' ' -f 2)
	NAME=$(echo $REPO | rev | cut -d / -f 1 | rev)
	export NAMES="$NAMES $NAME"
	echo "CLONING $BRANCH of $REPO to $NAME"
	rm -rf $NAME
	git clone -b $BRANCH --single-branch $REPO $NAME
done
cd ../../
NAMES=$(cat games.list | cut -d ' ' -f 1 | rev | cut -d '/' -f 1 | rev)
echo $NAMES
cat ./head.html > ./dist/index.html
for name in $NAMES; do
	echo "WRITING HTML FOR $name"
	cat ./template.html | sed "s/NAME/$name/g" >> ./dist/index.html
done
cat ./tail.html >> ./dist/index.html