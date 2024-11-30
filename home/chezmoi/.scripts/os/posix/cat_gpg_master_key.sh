#!/usr/bin/env bash
gpg --show-key --with-colons --with-fingerprint "$1" | sed -ne '/^pub:/,/^fpr:/ { /^fpr:/ p }' | cut -d: -f10
