#!/bin/bash

# Split the file starwars.txt into a file for each frame.
# A frame in the original file starts with a single number on a line.
# Initialize the Lua table
lua_table="frames = {"

# Read the input file line by line
while IFS= read -r line; do
  # Check if the line contains only a number (indicating a new frame)
  if [[ $line =~ ^[0-9]+$ ]]; then
    # Increment the frame number
    frame_number=$((frame_number + 1))
    # Set the output file name for the new frame
    output_file="frames/frame_$frame_number.txt"
    # Add a new entry to the Lua table
    if [[ $frame_number -gt 1 ]]; then
      lua_table+="]===],"
    fi
    lua_table+="\n  [${frame_number}] = [===["
  else
    # Append the line to the current frame's output file
    echo "$line" >> "$output_file"
    # Append the line to the Lua table
    lua_table+="$line\n"
  fi
done < starwars.txt

# Close the last frame in the Lua table
lua_table+="]===]\n}"

# Write the Lua table to starwars.lua
echo -e "$lua_table" > starwars.lua
