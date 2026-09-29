eval "$(/opt/homebrew/bin/brew shellenv)"

export GEM_HOME=$HOME/.gem
export PATH=$GEM_HOME/bin:$PATH
# Add .NET Core SDK tools
export PATH="$PATH:$HOME/.dotnet/tools"
