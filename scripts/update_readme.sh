#!/bin/bash

# read config
. "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/config.sh"

echo -e "\n == Update README ==\n"

cd "$REPO" || exit 1

sed -ir 's|href="file:///home/sven/Git-Repos/touchosc_obxd_template/docs/html/readme.css"|href="./docs/html/readme.css"|g' README.html
