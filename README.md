# stamp

[![Build Status](https://travis-ci.org/jberkel/stamp.png?branch=master)](https://travis-ci.org/jberkel/stamp)

Small OSX command line tool to create "stamped" versions of iOS app icons, e.g. to add build numbers / shas.
This is useful when distributing apps as part of a Continous Integration build. The technique is not new, but
existing solutions (e.g. [1][]) have the drawback that they often use external tools like imagemagick which need
to be installed on the build machines.

The advantage of `stamp` is that it has *absolutely no* external dependencies and a small footprint (~50 k), so it
can be included as part of your repository if you wish.

Additionally it makes uses of [TextKit][] which means high quality font rendering and advanced text layouting
possibilities.

## Installation


Install [xctool][], e.g.

    $ brew install xctool

Build

    $ pod install
    $ make build

Run

    $ target/stamp --input icon.png --output output.png --text stamp!

before <img src="https://github.com/jberkel/stamp/wiki/images/Icon.png" style="vertical-align: middle;"> 
after <img src="https://github.com/jberkel/stamp/wiki/images/stamped-Icon.png" style="vertical-align: middle;"/>

[1]: http://www.merowing.info/2013/03/overlaying-application-version-on-top-of-your-icon/
[TextKit]: https://developer.apple.com/library/ios/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/CustomTextProcessing/CustomTextProcessing.html
[xctool]: https://github.com/facebook/xctool
