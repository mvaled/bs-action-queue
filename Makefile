PATH := ./node_modules/.bin/:$(PATH)

install node_modules yarn.lock: package.json
	yarn install
	touch node_modules

clean:
	rm -rf ./node_modules

RESCRIPT_FILES := $(shell find src/ -type f -name '*.res')
compile: $(RESCRIPT_FILES) node_modules
	@if [ -n "$(INSIDE_EMACS)" ]; then \
	    NINJA_ANSI_FORCED=0 rescript build -with-deps; \
	else \
		rescript build -with-deps; \
	fi

format: $(RESCRIPT_FILES) install
	rescript format -all

test: compile
	ava

publish: compile
	yarn publish --access public

.PHONY: clean install test publish
