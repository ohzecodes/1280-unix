#!/bin/bash

target="dir"
numDirs=100
numFiles=10000
maxLength=12
seed=12800201930

exec >&2

printHelp() {
	cat <<- USAGE
		Creates a bunch of test files.
		Usage: $(basename $0) [options]

		Options:
		-t targetDir
		-d numDirs
		-f numFiles
		-l maxLength
		-s seed
	USAGE
	exit ${1:-1};
}

while getopts ":t:d:f:l:s:h" opt; do
	case "$opt" in
		t)	target="$OPTARG" ;;
		d)	numDirs="$OPTARG" ;;
		f)	numFiles="$OPTARG" ;;
		l)	maxLength="$OPTARG" ;;
		s)	seed="$OPTARG" ;;
		h)	printHelp 0;;
		:)	echo "Option -$OPTARG requires and argument"; printHelp 1;;
		*)	echo "Unknown option: -$OPTARG"; printHelp 1;;
	esac
done

[ -e "$target" ] && while : ; do
	read -p "'$target' exists. Delete? [yN] "
	case "$REPLY" in
		[Yy]|[Yy][Ee][Ss] ) rm -vr "$target" | tail -1; break;;
		[Nn]|[Nn][Oo] ) exit 0;;
		* ) exit 1;;
	esac
done

echo "${0##*/} -t $target -d $numDirs -f $numFiles -l $maxLength -s $seed"

mkdir -pv "$target" \
	&& cd "$target" \
	|| exit 1

(
	# makes a stream of random characters
	RANDOM=$(( seed + 1 ))

	chars[0]='abcdefghijklmnopqrstuvwxyz'
	chars[1]="$( tr '[:lower:]' '[:upper:]' <<< ${chars[0]} )"
	chars[2]="0123456789"
	chars[3]='.'
	chars[4]=' '
	chars[5]='@#$%^&()_+=~`[]{};,'\'

	prob[0]=200
	prob[1]=30
	prob[2]=20
	prob[3]=10
	prob[4]=5
	prob[5]=1

	eval $( tr ' ' '\n' <<< "${prob[*]}" \
		| awk '{ while ( $1-- ) print NR-1 }' \
		| awk '{ print "prob[" NR-1 "]=" $1 }' )
	probMod=${#prob[*]}

	while : ; do
		r=$(( RANDOM % probMod ))
		charSet=${chars[${prob[$r]}]}
		len=${#charSet}
		r=$(( RANDOM % len ))
		printf '%c' "${charSet:$r:1}"
	done
) | (

# eats a stream of random characters

getRandDir() {
	local i=$(( $1 % ${#dirs[@]} ))
	echo -n "${dirs[$i]}/"
}

progress() {
	printf "\r$1: %5i / $3 (%02i%%)" $2 $(( 100 * $2 / $3 ))
}

randChars() {
	local len=$(( RANDOM % maxLength + 1 ))
	read -rN $len REPLY
	printf "%s\0" "$REPLY"
}

makeDirs() {
	dirs[0]='.'
	for i in $( seq $numDirs ) ; do
		local r=$RANDOM$RANDOM
		(RANDOM=$r; getRandDir $RANDOM ; randChars ) | xargs -0 mkdir -p
		readarray -t dirs <<< "$(find -type d -print | sort)"
		progress "Dir" $i $numDirs >&2
	done
	declare -ar dirs
}

makeFiles() {
	local r=$RANDOM$RANDOM
	(	RANDOM=$r
		for i in $( seq $numFiles ) ; do
			getRandDir $RANDOM ; randChars
			progress "File" $i $numFiles >&2
		done
	) | xargs -0 touch
	readarray -t files <<< "$(find -type f -print | sort)"
	declare -ar files
}

getRandFile() {
	local i=$(( $1 % ${#files[@]} ))
	printf '%s' "${files[$i]}"
}

sizeFiles() {
	local num=$1
	local min=$2
	local max=$3
	local range=$(( max - min ))
	local size
	local r
	for i in $( seq $num ); do
		size=$RANDOM$RANDOM
		size=$(( size % range + min))
		r=$RANDOM$RANDOM
		cat /dev/zero | head -c $size > "$(getRandFile $r)"
	done
}

dateFiles() {
	local num=$1
	local date="$2"
	local r
	for i in $( seq $num ); do
		r=$RANDOM$RANDOM
		touch -d "$date" "$(getRandFile $r)"
	done
}

RANDOM=$(( seed + 2 ))
makeDirs; echo >&2
makeFiles; echo >&2
sizeFiles 10 1060 4090
dateFiles 10 "7 months ago"
dateFiles 10 "14 months ago"
dateFiles 10 "last week"
dateFiles 10 "tomorrow"
)

find | sort | shasum
