#!/usr/bin/env bash

set -o errexit 

source utils.sh

logsDirPath="logs"

if [[ $(id -u) -eq 0 ]]
then
  fatal "This script must be run as a non-root user."
elif [[ ! -d "${logsDirPath}" ]]
then
  fatal "The '${logsDirPath}' directory is not present."
elif [[ $# -lt 1 ]]
then
  fatal "Needs at least one argument, can be gen, rotate, or clean."
fi


gen_logs() {
  filename=$1
  number=$2

  for (( i=1; i <= $number; i++)) {
    echo "The quick brown fox jumps over the lazy dog." >> "${logsDirPath}/${filename}"
  }

}

rotate_logs() {
  filename=$1
  threshold=20

  lineCount=$(wc -l "${logsDirPath}/${filename}" | cut -d' ' -f 1)
  if [[ ${lineCount} -ge ${threshold} ]]
  then
	  timestamp=$(date +%s)
	  mv "${logsDirPath}/${filename}" "${logsDirPath}/${filename}"-"${timestamp}"

	  info "The ${filename} has been renamed to ${filename}-${timestamp}."
  fi
}

clean_logs() {
  threshold=$1

  while [[ $(find "${logsDirPath}/" -type 'f' | wc -l) -gt $threshold ]]
  do
    oldestFile=$(find "${logsDirPath}/" -type "f" | sort -d | head -1)

    info "Deleting file '${oldestFile}'"
    rm "${oldestFile}"
  done
}

print_usage() {
cat << EOF
logmgmt is a log management utility that is capable of doing the following:

- Rotating the logs: rename the current log file to name-timestamp.
- Cleaning the logs: delete old logs files to re-claim the storage space.

[USAGE]

 logmgmt [subcommand]

 Subcommand can be:
   gen - This will generate logs for testing
   rotate - This will do the rotation of the log file if it has number of lines than greater than 20
   clean - This will delete the old logs from logs directory, and always keep 5 log files in the directory
EOF
}

case $1 in 
  "gen") 
	  gen_logs earth-log 50
	  ;;
  "rotate") 
	  rotate_logs earth-log 20
	  ;;
  "clean") 
	  clean_logs 5
	  ;;
  "--help") 
	  print_usage
	  ;;
esac
