#!/bin/bash

# Compresses the .xml file back into a .tosc file

mkdir -p "xml_export"

s="xml_export/obxd.xml"
t="obxd.tosc"

echo "Compressing $s to $t .."

pigz -c -z < "$s" > "$t"
