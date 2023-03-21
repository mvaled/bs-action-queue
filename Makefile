PATH := ./node_modules/.bin/:$(PATH)

install: package.json
	yarn install

RESCRIPT_FILES := $(shell find src/ -type f -name '*.res')

clean:
	rm -rf ./node_modules

compile: $(RESCRIPT_FILES) install
	@if [ -n "$(INSIDE_EMACS)" ]; then \
	    NINJA_ANSI_FORCED=0 rescript build -with-deps; \
	else \
		rescript build -with-deps; \
	fi

format: $(RESCRIPT_FILES) install
	rescript format -all

.PHONY: clean install

# For Emacs users
node_modules yarn.lock: package.json
	yarn install

compile-rescript: $(RESCRIPT_FILES) yarn.lock node_modules
	@if [ -n "$(INSIDE_EMACS)" ]; then \
	    NINJA_ANSI_FORCED=0 rescript build -with-deps; \
	else \
		rescript build -with-deps; \
	fi
