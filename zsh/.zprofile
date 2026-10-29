eval "$(/opt/homebrew/bin/brew shellenv)"

export GEM_HOME=$HOME/.gem
export PATH=$GEM_HOME/bin:$PATH
# Add .NET Core SDK tools
export PATH="$PATH:$HOME/.dotnet/tools"
# Go-installed binaries
export PATH="$PATH:$HOME/go/bin"
# QMK toolchain (keg-only, used by qmk compile)
export PATH="$PATH:/opt/homebrew/opt/arm-none-eabi-gcc@8/bin:/opt/homebrew/opt/arm-none-eabi-binutils/bin"
