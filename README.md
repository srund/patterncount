# Pattern Count

## Introduction
This little script counts on how many rows each input pattern occurs on.

The inspiration was parsing output from `ps -ef` on a machine with some process
families occuring hundreds of times and that had to be monitored.

## Installation

This is just a little script that can be run as is.

## Usage

```
./pattern_count.sh [OPTIONS] -p PATTERNS FILENAME
```

```
$: ./pattern_count.sh --pattern one,two,three myfile.log
```

### Flags

*-p / --pattern* : (Required) A list of patterns to match in the file. The list
should by default be comma-separated. The patterns are passed on to `grep` with
it's `-E` flag as is. 

*-o / --output* : (Optional) Output file. Defaults to `stdout`.

*-d / --delimiter* : (Optional) Set the pattern list delimiter. Defaults to `,`

### An Example

Consider a file with the following contents:
```
one
two
two three
three
three
One
Two
Two Three
Three
Three
```

The below which contain proper but simple regex expressions, delimited with
periods (not best option if using regex), the input file set to `testfile.txt`,
output to `outfile.txt` and finally the delimiter defined as periods for the
list.

```
$: ./pattern_count.sh --pattern '[Tt]wo.[Oo]ne.[Tt]hree' testfile.txt -o outfile.txt -d '.'
```
When run we expect the following output:
```
4
2
6
```
Note that the rows with both two and three have been counted twice since they
matched same both the pattern for two and three.
