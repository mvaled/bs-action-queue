PATH := ./node_modules/.bin/:$(PATH)

install: package.json
	yarn install

RESCRIPT_FILES := $(shell find src/ -type f -name '*.res')

clean:
	rm -rf ./node_modules

compile: $(RESCRIPT_FILES) install
	rescript build -with-deps

format: $(RESCRIPT_FILES) install
	rescript format -all

.PHONY: clean install

# For Emacs users
yarn.lock: package.json
	yarn install

compile-rescript: $(RESCRIPT_FILES) yarn.lock
	[ -n "$(INSIDE_EMACS)" ] && (rescript build -with-deps | sed "s@  $(shell pwd)/@@") || rescript build -with-deps
