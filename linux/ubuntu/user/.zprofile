eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"


# Added by hand for Rust
export PATH="$PATH:/Users/ruslan/.cargo/bin"

# Added by hand for Go 
export PATH=$PATH:$(go env GOPATH)/bin
# Added by hand for Java
export JAVA_HOME=$(brew --prefix)/opt/openjdk@17/libexec
