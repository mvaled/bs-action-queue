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
