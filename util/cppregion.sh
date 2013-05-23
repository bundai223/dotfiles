#!/bin/sh

if [ $# -ne 3 ]; then
	echo "Usage: $0 FILE BEGIN END"
	echo "Example: $0 hoge.cpp 4 18"
fi
beginmark='---beginning_of_cpp_region'
endmark='---end_of_cpp_region'

sed -e "$2i\\
$beginmark" -e "$3a\\
$endmark" "$1" | cpp -C | sed -ne "/$beginmark/,/$endmark/p"
