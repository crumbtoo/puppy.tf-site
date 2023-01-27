BUILD_DIR := build
SRC_DIR := src

CSS_SRC := $(wildcard css/*.css)
CSS_OUT := $(patsubst css/%.css, $(BUILD_DIR)/%.css, $(CSS_SRC))

SCSS_SRC := $(shell ls css/*.scss | grep -v 'css/_')
SCSS_OUT := $(patsubst css/%.scss, $(BUILD_DIR)/%.css, $(SCSS_SRC))

SCSS_FLAGS := --style=compressed \
			  --no-error-css \
			  --stop-on-error

all: $(BUILD_DIR)/script.js $(SCSS_OUT) $(CSS_OUT)

$(BUILD_DIR):
	mkdir $(BUILD_DIR) || true

$(BUILD_DIR)/script.js: $(SRC_DIR)/main.ts
	tsc -b tsconfig.json

$(SCSS_OUT): $(BUILD_DIR)/%.css: css/%.scss
	sass $(SCSS_FLAGS) $< $@

$(CSS_OUT): $(BUILD_DIR)/%.css: css/%.css
	cp $< $@

test:
	@echo $(SCSS_SRC)

.PHONY:
clean:
	rm -rf build/
