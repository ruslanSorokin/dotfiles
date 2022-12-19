eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Added by hand for Rust
export PATH="$PATH:/home/ruslan/.cargo/bin"

# Added by hand for Go
export PATH="$PATH:$(go env GOPATH)/bin"

# Added by hand for Java
export PATH="/home/linuxbrew/.linuxbrew/opt/openjdk@17/bin:$PATH"
export JAVA_HOME="$(brew --prefix)/opt/openjdk@17/libexec"

# Added by hand for user binaries
export PATH="$PATH:/home/ruslan/bin"
