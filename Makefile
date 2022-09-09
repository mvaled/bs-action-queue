PATH := ./node_modules/.bin/:$(PATH)

install: package.json
	pnpm install

RESCRIPT_FILES := $(shell find src/ -type f -name '*.res')

clean:
	rm -rf ./node_modules

compile: $(RESCRIPT_FILES) install
	rescript build -with-deps

format: $(RESCRIPT_FILES) install
	rescript format -all

.PHONY: clean install

# For Emacs users
pnpm-lock.yaml: package.json
	pnpm install

compile-rescript: $(RESCRIPT_FILES) pnpm-lock.yaml
	[ -n "$(INSIDE_EMACS)" ] && (rescript build -with-deps | sed "s@  $(shell pwd)/@@") || rescript build -with-deps
