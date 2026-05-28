#!/usr/bin/env bash

# lint this repo
shellcheck --shell=bash --external-sources \
	setup.bash \
	scripts/*

shfmt --language-dialect bash --diff \
	setup.bash \
	scripts/*

# lint the asdf plugin scripts
shellcheck --shell=bash --external-sources \
	bin/* --source-path=lib/ \
	lib/*

shfmt --language-dialect bash --diff \
	bin/* \
	lib/*

# lint the template/
shellcheck --shell=bash --external-sources \
	template/bin/* --source-path=template/lib/ \
	template/lib/* \
	template/scripts/*

shfmt --language-dialect bash --diff \
	template/**/*
