#import "Stamper.h"
#import "BRLOptionParser.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        BRLOptionParser *parser = [[BRLOptionParser alloc] init];
        NSString *input = nil, *output = nil, *text = nil;

        [parser setBanner:@"usage: %s", argv[0]];
        [parser addOption:"input"  flag:'i' description:@"input file"  argument:&input];
        [parser addOption:"output" flag:'o' description:@"output file" argument:&output];
        [parser addOption:"text"   flag:'t' description:@"text"        argument:&text];

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
