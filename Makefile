TARGET = target
SHA = $(shell git rev-parse --short HEAD)

TEST_OUT = $(TARGET)/output.png
TEST_OUT_2X = $(TARGET)/output@2x.png

default: test

test: unit integration

unit:
	xctool -project stamp.xcodeproj/ -scheme stamp test

integration: run
ifeq (,$(findstring 60 x 60,$(shell file $(TEST_OUT))))
	$(error Wrong image dimensions for $(TEST_OUT_2X))
endif
ifeq (,$(findstring 120 x 120,$(shell file $(TEST_OUT_2X))))
	$(error Wrong image dimensions for $(TEST_OUT_2X))
endif

build:
	mkdir -p target
	xctool -project stamp.xcodeproj/ -scheme stamp CONFIGURATION_BUILD_DIR=target

clean:
	rm -rf target

run: build
	target/stamp tests/icons/Icon.png $(TEST_OUT) $(SHA)
	target/stamp tests/icons/Icon@2x.png $(TEST_OUT_2X) $(SHA)
