# SPDX-FileCopyrightText: Copyright (c) 2026 Max Trunnikov
# SPDX-License-Identifier: MIT

.SHELLFLAGS := -e -o pipefail -c
.ONESHELL:
SHELL := bash
.PHONY: all clean test

all: test

test:
	@docker build . -t xslint-action
	@expected=0; absented=0; output=$$(docker run --rm -v "$$(pwd):/w" -e HOME -e GITHUB_WORKSPACE='.' xslint-action $$'xsl-packs/xsl-with-no-violations.xsl\nxsl-packs/xsl-with-some-violations.xsl' $$'empty-content-in-instruction\ntemplate-match-starts-with-double-slash'); echo "$$output" | grep -q "Processed files: 2" && ((expected++)); echo "$$output" | grep -q "Defects found: 4" && ((expected++));\
	echo "$$output" | grep -q "Directories and files to process: xsl-packs/xsl-with-no-violations.xsl, xsl-packs/xsl-with-some-violations.xsl" && ((expected++)); echo "$$output" | grep -q "empty-content-in-instruction" || ((absented++)); echo "$$output" | grep -q "template-match-starts-with-double-slash" || ((absented++));\
	if [ "$$absented" -eq 2 ] && [ "$$expected" -eq 2 ]; then echo -e "\e[1;32mTest passed\e[0m"; else echo -e "\e[1;31mTest failed\e[0m"; fi
	@docker rmi xslint-action
