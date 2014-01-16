SHA = $(shell git rev-parse --short HEAD)

default: test

test:
	xctool -project stamp.xcodeproj/ -scheme stamp test

build: 
	mkdir -p target
	xctool -project stamp.xcodeproj/ -scheme stamp CONFIGURATION_BUILD_DIR=target

clean:
	rm -rf target

run: build
	target/stamp tests/icons/Icon.png target/output.png $(SHA)
