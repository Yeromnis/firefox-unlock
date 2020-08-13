#!/bin/bash

# unlockff : unlock Mozilla Firefox profiles
# by Yeromnis https://www.yeromnis.com
# usage: bash unlockff.sh

FIREFOXPATH=~/.mozilla/firefox/
PROFILESFILE=${FIREFOXPATH}profiles.ini


unlockprofile () {

	echo "'$profile_name' profile unlocking..."

	if [ $profile_ispathrelative == 1 ];	then
		profile_path="$FIREFOXPATH$profile_path"
	fi

  	rm ${profile_path}/.parentlock

	unset profile_id

}


if [ -f "$PROFILESFILE" ]; then

	echo "Mozilla Firefox profiles file found..."

	while read line; do

		if [[ $line =~ \[Profile[0-9]+] ]]; then # Profile section
			if [ -z "$profile_id" ]
			then
				profile_id=$(echo $line | sed -n "s/\[Profile\(.*\)]/\1/p")
			else
				unlockprofile
			fi

		elif [[ $line =~ Name= ]]; then # Name
			profile_name=${line:5}

		elif [[ $line =~ IsRelative= ]]; then # Is Relative Path
			profile_ispathrelative=${line:11}

		elif [[ $line =~ Path= ]]; then # Path
			profile_path=${line:5}

		fi

	done < "$PROFILESFILE"

	unlockprofile

	echo "Done."

else

	echo "Mozilla Firefox profiles file not found."
	exit 1

fi
