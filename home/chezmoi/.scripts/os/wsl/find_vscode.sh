#!/usr/bin/env bash

eval "$(wslupath -W)/System32/WindowsPowerShell/v1.0/powershell.exe -c 'where.exe code'" | head -n 1 | rargs wslpath "{0}"
