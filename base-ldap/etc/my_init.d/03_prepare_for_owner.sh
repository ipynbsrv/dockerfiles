#!/bin/bash

# set the owner as allowed login user
echo "$OWNER" > /etc/login.user.allowed

# link his home directory to /data/home
LINKED_HOME="/data/home"
if [ ! -L "$LINKED_HOME" ]; then
  unlink "$LINKED_HOME"
fi
ln -s "/home/$OWNER" "$LINKED_HOME"

# chown the container's data to the current user
# if it's a clone, might belong to another user otherwise
find /data/ \
  -not -path "/data/home/*" \
  -not -path "/data/public/*" \
  -not -path "/data/shares/*" \
  -not -user root \
  | xargs chown "$OWNER:$OWNER"
