BUILD_DIR := build
SRC_DIR := src

CSS_SRC := $(wildcard css/*.css)
CSS_OUT := $(patsubst css/%.css, $(BUILD_DIR)/%.css, $(CSS_SRC))

SCSS_PARTIALS := $(shell ls css/*.scss | grep '^css/_')
SCSS_SRC := $(shell ls css/*.scss | grep -v '^css/_')
SCSS_OUT := $(patsubst css/%.scss, $(BUILD_DIR)/%.css, $(SCSS_SRC))

SCSS_FLAGS := --style=compressed \
			  --no-error-css \
			  --stop-on-error

ELM_SRC := $(wildcard src/*.elm)

# HTML_SRC := index.html $(wildcard html/*.html html/*/*.html)
# HTML_OUT := build/index.html

all: $(SCSS_OUT) $(CSS_OUT) $(BUILD_DIR)/index.html $(BUILD_DIR)/main.js

$(BUILD_DIR):
	mkdir $(BUILD_DIR) || true

$(SCSS_OUT): $(BUILD_DIR)/%.css: css/%.scss $(SCSS_PARTIALS)
	sass $(SCSS_FLAGS) $< $@

$(CSS_OUT): $(BUILD_DIR)/%.css: css/%.css
	cp $< $@

$(HTML_OUT): $(BUILD_DIR)/%.html: $(HTML_SRC)
	cpp -P -x c -E -traditional-cpp $< -o $@

$(BUILD_DIR)/main.js: $(ELM_SRC)
	elm make src/Main.elm --output=$@

$(BUILD_DIR)/index.html: html/index.html
	cp $< $@

.PHONY:
clean:
	rm -rf build/
