eval "$(/opt/homebrew/bin/brew shellenv)"

# Added by Toolbox App
export PATH="$PATH:/Users/ruslan/Library/Application Support/JetBrains/Toolbox/scripts"

# Added by hand for Rust
export PATH="$PATH:/Users/ruslan/.cargo/bin"

# Added by hand for Go
export PATH="$PATH:$(go env GOPATH)/bin"

# Added by hand for Java
export JAVA_HOME="$(brew --prefix)/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home"
