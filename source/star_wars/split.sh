#!/bin/bash

# The fil  file starwars.txt into a file for each frame.
# Each frame in the original file starts with a single number on a line.
# This number indicates how long the frame should be visible in tenths of seconds.
# The rest of the lines in the frame contain the ASCII art for that frame.
# Split the file into individual frames and create a Lua table with the frame data.

# Create the frames directory if it doesn't exist
mkdir -p frames

# Remove any existing frame files
rm -f frames/frame_*.txt

# Initialize the frame number and length
frame_number=0
frame_length=1

# Initialize the Lua table
lua_table="frames = {"

# Read the input file line by line
while IFS= read -r line; do
  # Check if the line contains only a number (indicating a new frame)
  if [[ $line =~ ^[0-9]+$ ]]; then
    # Increment the frame number
    frame_number=$((frame_number + 1))
    # Get  the frame length from the line
    frame_length=$(echo "$line" | bc)
    # Set the output file name for the new frame
    output_file="frames/frame_$frame_number.txt"
    # Add a new entry to the Lua table
    if [[ $frame_number -gt 1 ]]; then
      lua_table+="]==]},"
    fi
    lua_table+="\n  [${frame_number}] = {
    length = $frame_length,
    frame = [==["
  else
    # Append the line to the current frame's output file
    echo "$line" >> "$output_file"
    # Append the line to the Lua table
    lua_table+="$line\n"
  fi
done < starwars.txt

# Close the last frame in the Lua table
lua_table+="]==]}\n}"

# Write the Lua table to starwars.lua
echo -e "$lua_table" > starwars.lua
