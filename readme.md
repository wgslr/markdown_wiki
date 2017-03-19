# Usage
This is a script for recursive rendering of markdown to html. It mirrors directory structure of the source in the target directory, symlinks all files that are not `*.md` and converts `.md` files to html

## Source
The script traverses filesystem upwards from current directory until it find a directory with file `.wikiroot` present. This directory is used as base for all further operations. If `.wikiroot` is not found, current directory is used.

## Target
Default target is `../rendered` relative to the wikiroot directory (see above). Another target directory can be given in commandline as the first argument.  
**warning**: all contents of the target directory will be deleted prior to conversion

# Dependencies
This script requires commands `pandoc` and `realpath` to be available. 

# Examples

# License

MIT license (see file LICENSE for copy).
