#!/bin/bash

if [ -z "${OWNER+x}" ]; then
  echo "ERROR: No container owner defined. Exiting."
  exit 1
fi

# set the owner as allowed login user
echo "$OWNER" > /etc/login.user.allowed
# link his home directory to /data/home
LINKED_HOME="/data/home"
if [ ! -L "$LINKED_HOME" ]; then
  unlink "$LINKED_HOME"
fi
ln -s "/home/$OWNER" "$LINKED_HOME"
