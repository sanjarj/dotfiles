# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH";

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null;
done;

# Add tab completion for many Bash commands
if [ -r "${BREW_PREFIX}/etc/profile.d/bash_completion.sh" ]; then
	# Ensure existing Homebrew v1 completions continue to work
	export BASH_COMPLETION_COMPAT_DIR="${BREW_PREFIX}/etc/bash_completion.d";
	source "${BREW_PREFIX}/etc/profile.d/bash_completion.sh";
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi;

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;

# pyenv, see https://github.com/pyenv/pyenv#basic-github-checkout
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
fi
# pyenv-virtualenv, see: brew info pyenv-virtualenv
if which pyenv-virtualenv-init > /dev/null; then
    eval "$(pyenv virtualenv-init -)"
fi

if command -v broot 1>/dev/null 2>&1; then
	eval "$(broot --print-shell-function bash)"
fi

# asdf version manager
if test -f "${BREW_PREFIX}/opt/asdf/libexec/asdf.sh"; then
	source "${BREW_PREFIX}/opt/asdf/libexec/asdf.sh"
	source ~/.asdf/plugins/java/set-java-home.bash
fi

# iterm2 integration
test -e ~/.iterm2_shell_integration.bash && source ~/.iterm2_shell_integration.bash || true

# max open files for session
ulimit -S -n 64000

# global max files should be configured via launchctl:
# 1. create file /Library/LaunchDaemons/limit.maxfiles.plist:
#    <?xml version="1.0" encoding="UTF-8"?>
#    <!DOCTYPE plist PUBLIC "-//Apple/DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
#    <plist version="1.0">
#        <dict>
#            <key>Label</key>
#            <string>limit.maxfiles</string>
#            <key>ProgramArguments</key>
#            <array>
#                <string>launchctl</string>
#                <string>limit</string>
#                <string>maxfiles</string>
#                <string>64000</string>
#                <string>64000</string>
#            </array>
#            <key>RunAtLoad</key>
#            <true/>
#        </dict>
#    </plist>
# 2. run: launchctl load /Library/LaunchDaemons/limit.maxfiles.plist
# 3. restart
