#!/usr/bin/env bash

# format this repo
shfmt --language-dialect bash --write \
	setup.bash \
	scripts/*.bash

# format the asdf plugin scripts
shfmt --language-dialect bash --write \
	bin/* \
	lib/*

# format the template/
shfmt --language-dialect bash --write \
	template/**/*
