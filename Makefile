BUILD_DIR := 'build'
SRCDIR := 'src'

all: $(BUILD_DIR)/script.js $(BUILD_DIR)/style.css

$(BUILD_DIR):
	mkdir $(BUILD_DIR) || true

$(BUILD_DIR)/script.js:
	tsc -b tsconfig.json

$(BUILD_DIR)/style.css:
	sass css/style.scss $(BUILD_DIR)/style.css

.PHONY:
clean:
	rm -rf build/
