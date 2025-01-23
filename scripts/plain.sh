#!/bin/bash
#
# Compresses all .xml files back into .tosc
#

# read config
. "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/config.sh"

echo -e "\n == Removing eye-candy from $XML_BUILD_PLAIN ==\n"

#####
# All eye-candy backgrounds with extra design element were named "backdrop".
# Here, we manually delete those nodes from the xml file before compressing.
#
xmlstarlet ed -d '//children/node[properties/property/value[contains(text(), "backdrop")]]' \
  <  "$XML_BUILD_PLAIN" \
  > "$XML_BUILD_PLAIN.tmp"

mv "$XML_BUILD_PLAIN.tmp" "$XML_BUILD_PLAIN"

echo -e "\nDone.\n"
