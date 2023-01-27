BUILD_DIR := build
SRC_DIR := src

CSS_SRC := $(wildcard css/*.css)
CSS_OUT := $(patsubst css/%.css, $(BUILD_DIR)/%.css, $(CSS_SRC))

all: $(BUILD_DIR)/script.js $(BUILD_DIR)/style.css $(CSS_OUT)

$(BUILD_DIR):
	mkdir $(BUILD_DIR) || true

$(BUILD_DIR)/script.js: $(SRC_DIR)/main.ts
	tsc -b tsconfig.json

$(BUILD_DIR)/style.css:
	sass css/style.scss $(BUILD_DIR)/style.css

$(CSS_OUT): $(BUILD_DIR)/%.css: css/%.css
	cp $< $@

.PHONY:
list: $(CSS_OUT)
	@echo $?


.PHONY:
clean:
	rm -rf build/
