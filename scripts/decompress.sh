#!/bin/bash

# Uncompresses the .tosc file into .xml

mkdir -p "xml_export"

s="obxd.tosc"
t="xml_export/obxd.xml"

echo "Decompressing $s to $t ..
also formats the .xml a bit better to allow for better showing a git diff on it"

pigz -c -d < "$s" | sed -r 's#(<[a-z]+>)<#\1\n<#g' - > "$t"
