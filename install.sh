#!/bin/bash

brew install --cask \
	bankid \
	enpass \
	firefox \
	gpg-suite-pinentry \
	intellij-idea \
	joplin \
	mactex \
	mendeley \
	microsoft-excel \
	microsoft-powerpoint \
	microsoft-word \
	opera \
	pycharm \
	sage \
	signal \
	skype \
	slack \
	spotify \
	sublime-text \
	tor-browser \
	tunnelblick \
	virtualbox \
	wireshark \
	zoom \
	zotero \
	zulip

brew upgrade --cask

brew install \
	gmp \
	nmap \
	openssl \
	python \
	python3 \
	rust \
	wget \
	wireguard-tools

brew upgrade

brew unlink python && brew link --overwrite python # make sure python links to python2
#pip2 install --upgrade pip setuptools # upgrade to latest pip2
pip3 install --upgrade pip setuptools # upgrade to latest pip3

# never use the generic “python” and “pip”.
# always use “python[2/3]” and “pip[2/3]”.

pip3 install pygments

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
