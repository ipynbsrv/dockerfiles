#!/bin/bash

if [ -z "${OWNER+x}" ]; then
  echo "ERROR: No OWNER defined. Exiting."
  exit 64
fi
