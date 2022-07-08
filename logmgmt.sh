
gen_logs() {
  filename=$1
  number=$2

  for (( i=1; i<=${number}; i++)) {
    echo "The quick brown fox jumps over the lazy dog." >> logs/${filename}
  }

}

rotate_logs() {
  filename=$1
  threshold=20

  lineCount=$(wc -l logs/${filename} | cut -d' ' -f 1)
  if [[ ${lineCount} -ge ${threshold} ]]
  then
	  timestamp=$(date +%s)
	  mv logs/${filename} logs/${filename}-${timestamp}

	  #info "The ${filename} has been renamed to ${filename}-${timestamp}."
  fi
}

clean_logs() {
  threshold=$1


}


gen_logs earth-log 50

rotate_logs earth-log 20
