#!/bin/bash

if [ -z "$BASH_VERSION" ]; then
    echo "Script must be executed with bash."
    exit 1
fi

input_file="$1"
input_basename=${input_file%.*}

function normalize() {
  # Replace '&' with 'and' and replace most special characters
  echo "$1" | sed 's/&/ and /g' | tr -dc '[:alnum:] ()[]._-' | sed -E 's/[[:space:]]+/ /g'
}

# Check input file argument
if [ -z "$input_file" ]; then
  echo "Please specify video file to extract subtitles from as first argument."
  exit 2
fi

if [ ! -f "$input_file" ]; then
    echo "Input file '$input_file' does not exist."
    exit 3
fi

# Read subtitle streams from file
subtitle_streams=$(ffprobe -loglevel error -select_streams s -show_entries stream_tags=language,title -of csv=p=0 "$input_file")

if [ $? -ne 0 ]; then
  echo "Error while reading subtitle streams."
  exit 4
fi

# Set IFS to comma for parsing CSV
IFS=','

index=0
while read -r language title; do
    language=$(normalize "$language")
    title=$(normalize "$title")

    # Pipe empty input into ffmpeg since ffmpeg was stealing data from stdin which should be read by the while loop
    echo -n | ffmpeg -loglevel error -y -i "$input_file" -map 0:s:$index "$input_basename.$title.$language.srt"

    ((index++))
done <<< "$subtitle_streams"
