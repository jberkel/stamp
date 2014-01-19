PROJECT = stamp.xcodeproj
SCHEME = stamp
TARGET = target

TEST_ICON = tests/icons/Icon.png
TEST_ICON_2X = tests/icons/Icon@2x.png
TEST_OUT = $(TARGET)/stamped-Icon.png
TEST_OUT_2X = $(TARGET)/stamped-Icon@2x.png
STAMP = $(TARGET)/stamp

SHA = $(shell git rev-parse --short HEAD)

default: test

test: unit integration

unit:
	xctool -project $(PROJECT) -scheme $(SCHEME) test

integration: run
	file $(TEST_OUT)    | grep '60 x 60'
	file $(TEST_OUT_2X) | grep '120 x 120'

build:
	mkdir -p $(TARGET)
	xctool -project $(PROJECT) -scheme $(SCHEME) CONFIGURATION_BUILD_DIR=$(TARGET)

clean:
	rm -rf $(TARGET)

run: build
	$(STAMP) $(TEST_ICON) $(TEST_OUT) $(SHA)
	$(STAMP) $(TEST_ICON_2X) $(TEST_OUT_2X) $(SHA)
