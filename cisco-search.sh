#!/bin/bash

# check for arguments
if [ "$#" -eq 0 ]; then
  echo "Please specify a search pattern"
  exit
fi

# print help page
if [ "$1" = "-h" -o "$1" = "--help" ]; then
  echo "Usage: cisco-search <search pattern>"
  exit
fi

# path to cisco configs
file="/tmp/cisco-search/*"

# awk program in heredoc
awk -v search_pattern="$1" -f- $file << 'EOF'
BEGIN {
  RS = "!\n"
}

FNR == 2 {
  print_heading = 1
  n=split (FILENAME, tmp, "/")
  split (tmp[n], name, "_")
  separator = sprintf("%*s", length(name[1])+6, "")
  gsub(/ /, "~", separator)
}

FNR > 1 {
  if (index(tolower($0), tolower(search_pattern)) && print_heading) {
    print separator
    print ">> " name[1] " <<"
    print separator
    print_heading = 0
  }

  if (index(tolower($0), tolower(search_pattern))) {
    sub(/!$/, "", $0)
    print
  }
}
EOF
