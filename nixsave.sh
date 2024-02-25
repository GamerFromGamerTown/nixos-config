#!/bin/sh
# Ensure that the environment variables and paths are correct for sudo and git
export PATH=/run/current-system/sw/bin:/run/current-system/sw/sbin:$PATH
sudo git -C /etc/nixos add . && sudo git -C /etc/nixos commit -m "Automatic update"
