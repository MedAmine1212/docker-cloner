#!/bin/sh

REPO_URL="https://github.com/webstudio-is/webstudio"
CLONE_DIR="/app/webstudio"

if [ -d "$CLONE_DIR" ]; then
  echo "Repository already cloned. Pulling latest changes..."
  cd "$CLONE_DIR" && git pull
else
  echo "Cloning repository..."
  git clone "$REPO_URL" "$CLONE_DIR"
fi
