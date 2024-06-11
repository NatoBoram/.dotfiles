# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
	# include .bashrc if it exists
	if [ -f "$HOME/.bashrc" ]; then
		. "$HOME/.bashrc"
	fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
	PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ]; then
	PATH="$HOME/.local/bin:$PATH"
fi

# AMD
PATH="$PATH:/opt/rocm-5.4.2/bin:/opt/rocm-5.4.2/opencl/bin"

# Android
export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
PATH="$ANDROID_HOME/platform-tools:$PATH"
PATH="$ANDROID_HOME/tools/bin:$PATH"
export CAPACITOR_ANDROID_STUDIO_PATH="$HOME/Applications/android-studio/bin/studio.sh"

# ASDF
PATH="$HOME/.asdf/bin:$PATH"
PATH="$HOME/.asdf/shims:$PATH"

# Bun
PATH="$HOME/.bun/bin:$PATH"

# Dart
PATH="$PATH:$HOME/.pub-cache/bin"

# Elixir
PATH="$HOME/Applications/elixir/bin:$PATH"
PATH="$HOME/.mix/escripts:$PATH"

# Flutter
PATH="$HOME/Applications/flutter/bin:$PATH"

# GitHub Copilot CLI
eval "$(github-copilot-cli alias -- "$0")"

# Go
export GOPATH="$HOME/go"
PATH="$GOPATH/bin:$PATH"

# Java
PATH="$HOME/Applications/gradle/bin:$PATH"

# PNPM
export PNPM_HOME="$HOME/.local/share/pnpm"
PATH="$PNPM_HOME:$PATH"

# Python
export PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=python

# Rust
#. "$HOME/.cargo/env"
PATH="$HOME/.cargo/bin:$PATH"

# Swift
PATH="$HOME/Applications/swift/usr/bin:$PATH"
