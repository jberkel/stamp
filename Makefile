WORKSPACE = stamp.xcworkspace
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
	xctool -workspace $(WORKSPACE) -scheme $(SCHEME) test

integration: run
	file $(TEST_OUT)    | grep '60 x 60'
	file $(TEST_OUT_2X) | grep '120 x 120'

build:
	mkdir -p $(TARGET)
	xctool -workspace $(WORKSPACE) -scheme $(SCHEME) DSTROOT=$(TARGET) DEPLOYMENT_LOCATION=YES INSTALL_PATH=/

clean:
	rm -rf $(TARGET)
	xctool -workspace $(WORKSPACE) -scheme $(SCHEME) clean

run: build
	$(STAMP) --input $(TEST_ICON)    --output $(TEST_OUT)    --text $(SHA)
	$(STAMP) --input $(TEST_ICON_2X) --output $(TEST_OUT_2X) --text $(SHA)
