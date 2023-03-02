
# Setting PATH for Python 3.8
# The original version is saved in .zprofile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.8/bin:${PATH}"
export PATH

##
# Your previous /Users/lauralangdon/.zprofile file was backed up as /Users/lauralangdon/.zprofile.macports-saved_2020-08-03_at_12:59:32
##

# MacPorts Installer addition on 2020-08-03_at_12:59:32: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"

# export WORKON_HOME=$HOME/.virtualenvs
# export PROJECT_HOME=$HOME/Devel
# source /usr/local/bin/virtualenvwrapper.sh

eval "$(/opt/homebrew/bin/brew shellenv)"
