#!/bin/bash
################################################################################
#   Counts the number of rows each input pattern occur on.
#   Rows with multiple patterns will match and be counted many times.
#
#   Usage:
#       $: pattern_count.sh -p one,two testfile.txt
#       $: pattern_count.sh -p [Aa],mypattern testfile.txt --output OUTPUT-FILE
################################################################################

## Program parameters
OUTFILE='/dev/stdout'
FILENAME=''
PATTERN=''
DELIMITER=','

## Params
SHORT_ARGS='p:d:o:'
LONG_ARGS='pattern:,delimiter:,output:' # Comma separated

# We put the parsed options in a variable for now since we want to check getopts
# return value. Using getopt together with set would have removed the return val
options=$(getopt -o "$SHORT_ARGS" --long "$LONG_ARGS" -- "$@")

if [ $? -ne 0 ]; then
	echo 'getopt could not parse input. Terminating...' >&2
	exit 1
fi
eval set -- "$options" # Changing positional params to getopt filtered version of them.
unset options # We don't need the options any more.

# consume 1-2 positional params as flags at the time until there are no more.
while true
do
	case "$1" in
		'-p' | '--pattern' )
			PATTERN=$2
			shift 2 # b has a mandatory option
			;;
		'-d' | '--delimiter' )
			DELIMITER=$2
			shift 2 #
			;;
		'-o' | '--output' )
			OUTFILE=$2
			shift 2 #
			;;
		'--') # End of flagged params
			shift
			break # Break while loop
			;; # Put here because it doesn't feel right to remove it
		*)
			echo "We shouldn't get here. Terminating ..."
			exit 1
	esac
done

FILENAME=$1 # shift above has moved params, $0 is still script name

## Debug
#echo $FILENAME
#echo $PATTERN
#echo $DELIMITER

## Verify 
if [ $FILENAME == '' ]; then
	echo "Error: No input file defined. Terminating" >&2
fi
if [ $PATTERN == '' ]; then
	echo "Error: No pattern defined. Terminating" >&2
fi
## Do stuff
echo -n '' > $OUTFILE # Empty file before use
pattern_array=${PATTERN//$DELIMITER/ }
for p in ${pattern_array[@]} # Start Stop
do
	grep -E $p $FILENAME | wc -l >> $OUTFILE
done
## End
exit 0 # 0 = success

