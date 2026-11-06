#!/bin/bash
set -e
echo "[setup] installing deps"
sudo apt-get update -qq
sudo apt-get install -y -qq rclone jq curl
pip install --quiet requests
echo "[setup] done"
