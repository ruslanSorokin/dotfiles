#!/usr/bin/env bash

if command -v home-manager >/dev/null 2>&1; then
  echo "Found home-manager"
else
  echo "Installing home-manager"
  nix --extra-experimental-features "nix-command flakes" run home-manager/master -- init --switch
fi
