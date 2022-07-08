#!/usr/bin/env bash

logsDirPath="logs"

if $(id -u) -eq 0
then
  fatal "This script must be run as a non-root user."
elif [[ ! -d "${logsDirPath}" ]]
then
  fatal "The \'${logsDirPath}\' directory is not present."
elif [[ $# -lt 1 ]]
then
  fatal "Needs at least one argument, can be gen, rotate, or clean."
fi

info() {
  echo "[INFO] $1"
}

fatal() {
  echo "[FATAL] $1"
  exit 1
}


gen_logs() {
  filename=$1
  number=$2

  for (( i=1; i <= $number; i++)) {
    echo "The quick brown fox jumps over the lazy dog." >> "logs/${filename}"
  }

}

rotate_logs() {
  filename=$1
  threshold=20

  lineCount=$(wc -l "logs/${filename}" | cut -d' ' -f 1)
  if [[ ${lineCount} -ge ${threshold} ]]
  then
	  timestamp=$(date +%s)
	  mv "logs/${filename}" logs/"${filename}"-"${timestamp}"

	  #info "The ${filename} has been renamed to ${filename}-${timestamp}."
  fi
}

clean_logs() {
  threshold=$1

  check_files_count
  fileCount=$?

  while [[ ${fileCount} -gt ${threshold} ]]
  do
    oldestFile=$(ls -1rc logs/ | head -1)

    rm logs/"${oldestFile}"

    check_files_count
    fileCount=$?
  done
}

check_files_count() {
  return "$(ls -1rc logs/ | wc -l)"
}


gen_logs earth-log 50

rotate_logs earth-log 20

clean_logs 5
