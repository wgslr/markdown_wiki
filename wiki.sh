#!/bin/bash -e
# 2017-03-19 
# Wojciech Geisler

# dependencies: pandoc, realpath






# folder to create files in, relative to wikiroot

# export to access variables in subshell invoked by find -exec

TARGET=${1:-"../rendered"}
export TARGET=${TARGET%/} # remove trailing slash
export CSS="styles.css"

# converts to html
# argument: source path as given by find
function render {
	# find the target dirname
	DIRNAME=`dirname "$TARGET/$1"`

	# path to css realtive to target file
	CSS=`realpath --relative-to "$DIRNAME" "$TARGET"`"/$CSS"

	# convert
	FILE="$TARGET/${1%.md}" # remove trailing .md
	pandoc --toc -Ss -t html "$1" -o "$FILE" -c "$CSS" --columns 1000
}
# make function accessible in subshell
export -f render

# find wiki root
ORG_ROOT=`pwd`
ROOT=`pwd`
while [ ! -f '.wikiroot' ]; do
	if [ "$ROOT" == '/' ]; then
		cd "$ORG_ROOT"
		ROOT="$ORG_ROOT"
		break
	else
		cd ..
		ROOT=`pwd`
	fi
done

if [ -d "$TARGET" ]; then
	rm -r "$TARGET" || true
fi

# replicate directory structure
find \( -iwholename "./$TARGET" -o -iname ".?*" \) -prune -o -type d					-exec mkdir -p "$TARGET/{}" \;

# symlink data files
find \( -iwholename "./$TARGET" -o -iname ".?*" \) -prune -o -type f ! -iname "*.md"	-exec ln -fsr "{}" "$TARGET/{}" \;

# create hardlinks
#find \( -iwholename "./$TARGET" -o -iname ".?*" \) -prune -o -type f ! -iname "*.md"	-exec ln -f "{}" "$TARGET/{}" \;

# convert markdown files
find \( -iwholename "./$TARGET" -o -iname ".?*" \) -prune -o -type f -iname "*.md"		-exec bash -c 'render "{}"' \;

if [ -f "$CSS" ]; then 
	cp "$CSS" "$TARGET/$CSS" --remove-destination
fi
