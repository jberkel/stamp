TARGET = target
SHA = $(shell git rev-parse --short HEAD)

TEST_ICON = tests/icons/Icon.png
TEST_ICON_2X = tests/icons/Icon@2x.png
TEST_OUT = $(TARGET)/stamped-Icon.png
TEST_OUT_2X = $(TARGET)/stamped-Icon@2x.png

default: test

test: unit integration

unit:
	xctool -project stamp.xcodeproj/ -scheme stamp test

integration: run
	file $(TEST_OUT)    | grep '60 x 60'
	file $(TEST_OUT_2X) | grep '120 x 120'

build:
	mkdir -p target
	xctool -project stamp.xcodeproj/ -scheme stamp CONFIGURATION_BUILD_DIR=target

clean:
	rm -rf target

run: build
	target/stamp $(TEST_ICON) $(TEST_OUT) $(SHA)
	target/stamp $(TEST_ICON_2X) $(TEST_OUT_2X) $(SHA)
