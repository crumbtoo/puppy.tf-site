BUILD_DIR := build
SRC_DIR := src

CSS_SRC := $(wildcard css/*.css)
CSS_OUT := $(patsubst css/%.css, $(BUILD_DIR)/%.css, $(CSS_SRC))

SCSS_PARTIALS := $(shell ls css/*.scss | grep 'css/_')
SCSS_SRC := $(shell ls css/*.scss | grep -v 'css/_')
SCSS_OUT := $(patsubst css/%.scss, $(BUILD_DIR)/%.css, $(SCSS_SRC))

HTML_SRC := index.html
HTML_OUT := build/index.html

SCSS_FLAGS := --style=compressed \
			  --no-error-css \
			  --stop-on-error

all: $(BUILD_DIR)/script.js $(SCSS_OUT) $(CSS_OUT) $(HTML_OUT)

$(BUILD_DIR):
	mkdir $(BUILD_DIR) || true

$(BUILD_DIR)/script.js: $(SRC_DIR)/main.ts
	tsc -b tsconfig.json

$(SCSS_OUT): $(BUILD_DIR)/%.css: css/%.scss $(SCSS_PARTIALS)
	sass $(SCSS_FLAGS) $< $@

$(CSS_OUT): $(BUILD_DIR)/%.css: css/%.css
	cp $< $@

$(HTML_OUT): $(BUILD_DIR)/%.html: index.html
	cpp -P -x c -E -traditional-cpp $< -o $@

.PHONY:
clean:
	rm -rf build/
