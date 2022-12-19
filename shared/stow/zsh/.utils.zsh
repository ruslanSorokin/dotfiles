is_wsl() {
  [[ "$(uname -a 2>/dev/null)" == *"WSL"* ]]
}

is_vscode() {
  [[ -v VSCODE_IPC_HOOK_CLI ]]
}

is_linux() {
  [[ "$(uname 2>/dev/null)" == "Linux" ]]
}

is_darwin() {
  [[ "$(uname 2>/dev/null)" == "Darwin" ]]
}
