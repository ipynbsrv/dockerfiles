#/bin/bash

if [ -z "${BASE_URL+x}" ]; then
  echo "ERROR: No BASE_URL defined. Exiting."
  exit 64
fi

if [ -z "${OWNER+x}" ]; then
  echo "ERROR: No OWNER defined. Exiting."
  exit 64
fi
