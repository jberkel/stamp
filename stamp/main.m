#import <AppKit/AppKit.h>
#import "Stamper.h"
#import "BRLOptionParser.h"
#import "HexColor.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        BRLOptionParser *parser = [[BRLOptionParser alloc] init];
        NSString *input = nil, *output = nil, *text = nil;
        __block NSColor *textColor = nil, *shadowColor = nil;
        BOOL noShadow;
        BOOL allowEmpty = NO;

        [parser setBanner:@"usage: %s", argv[0]];
        [parser addOption:"input"  flag:0 description:@"input png file"  argument:&input];
        [parser addOption:"output" flag:0 description:@"output png file" argument:&output];
        [parser addOption:"text"   flag:0 description:@"text"        argument:&text];
        __weak typeof(parser) weakParser = parser;
        [parser addOption:"help" flag:'h' description:nil block:^{
            fprintf(stderr, "%s", [[weakParser description] UTF8String]);
            exit(EXIT_SUCCESS);
        }];

        [parser addOption:"color"
                     flag:0 description:@"text color   [rgb|rrggbb]"
        blockWithArgument:^(NSString *color) {
            textColor = [NSColor colorWithHexString:color alpha:1];
        }];
        [parser addOption:"shadow-color"
                     flag:0
              description:@"text shadow color [rgb|rrggbb]"
        blockWithArgument:^(NSString *color) {
            shadowColor = [NSColor colorWithHexString:color alpha:1];
        }];
        [parser addOption:"no-shadow" flag:0 description:@"disable text shadow" value:&noShadow];
        [parser addOption:"allow-empty" flag:0 description:@"ignore errors if text is too long" value:&allowEmpty];

        NSError *error = nil;

        if (argc <= 1) {
            fprintf(stderr, "%s", [[parser description] UTF8String]);
            return EXIT_FAILURE;
        } else if (![parser parseArgc:argc argv:argv error:&error]) {
            const char * message = [[error localizedDescription] UTF8String];
            fprintf(stderr, "%s: %s\n", argv[0], message);
            return EXIT_FAILURE;
        } else if (!input || !output || !text) {
            fprintf(stderr, "%s", [[parser description] UTF8String]);
            return EXIT_FAILURE;
        }

        Stamper *stamper = [[Stamper alloc] initWithFile:input];
        if (textColor) {
            stamper.textColor = textColor;
        }
        if (shadowColor) {
            stamper.textShadow.shadowColor = shadowColor;
        }
        if (noShadow) {
            stamper.textShadow = nil;
        }
        stamper.allowEmpty = allowEmpty;

        if (![stamper addText:text]) {
            fprintf(stderr, "error: text too long\n");
            return EXIT_FAILURE;
        }

        if ([stamper saveTo:output]) {
            return EXIT_SUCCESS;
        } else {
            fprintf(stderr, "error: saving failed\n");
            return EXIT_FAILURE;
        }
    }
}
