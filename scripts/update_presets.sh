#!/bin/bash
#
# Compresses all .xml files back into .tosc
#

# read config
. "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/config.sh"

echo -e "\n == Insert custom shivaPresetStore in $XML_EXPORT_PRESETS\n"

source="$TOSC_PRESETSTORE"
target="$XML_EXPORT_PRESETSTORE"

# Extract shivaPresetStore from presetstore.tos in repo root
echo -e "Decompressing $source to $target ..\n"
pigz -c -d < "$source" > "$target"

echo -e "Formatting $target ..\n"
mv "$target" "$target.bak"
xmllint --format "$target.bak" > "$target"

# Extract and reduce to only the shivaPresetStore node
echo -e "Reducing $target to shivaPresetStore ..\n"
xmlstarlet sel -t -m '//node[@type="GROUP"]/properties/property[value="shivaPresetStore"]' -c ../.. \
  < "$target" \
  > "$target.tmp"
mv "$target.tmp" "$target"

source="$XML_EXPORT_PRESETSTORE"
target="$XML_EXPORT_PRESETS"

# Copy standard obxd.xml as base
cp -a "$XML_EXPORT" "$target"

# Remove old shivaPresetStore in the copy
echo -e "Removing shivaPresetStore in $target ..\n"
xmlstarlet ed -d \
  '//node/properties/property[value="shivaPresetStore"]' \
  < "$target" \
  > "$target.tmp"

mv "$target.tmp" "$target"

# Insert the new shivaPresetStore
echo -e "Inserting new shivaPresetStore in $target ..\n"
xmlstarlet ed --inplace -s \
  '//children[node[@type="GROUP"]/properties/property[value="app"]]' \
  -t elem -name 'inserthere' -v 'inserthere' \
  "$target"

sed -i "/<inserthere>inserthere<\/inserthere>/r $source" "$target"
sed -i "s/<inserthere>inserthere<\/inserthere>//" "$target"

source="$XML_EXPORT_PRESETS"
target="$TOSC_BUILD_PRESETS"

# Compress the version with inserted presets
echo -e "Compressing $source >> $target"
xmllint --noblanks "$source" > "$source.tmp"
mv "$source.tmp" "$source"
pigz -c -z < "$source" > "$target"

# Deploy final compressed file to repo root
cp -a "$target" "$TOSC_FINAL_PRESETS"

echo -e "\nDone.\n"
