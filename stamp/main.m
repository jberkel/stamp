#import "Stamper.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        if (argc > 3) {
            NSString *file = [NSString stringWithUTF8String:argv[1]];
            NSString *output = [NSString stringWithUTF8String:argv[2]];
            NSString *text = [NSString stringWithUTF8String:argv[3]];

            Stamper *stamper = [[Stamper alloc] initWithFile:file];
            if (![stamper addText:text]) {
                fprintf(stderr, "error: text too long\n");
                return -1;
            }

            if ([stamper saveTo:output]) {
                return 0;
            } else {
                fprintf(stderr, "error: saving failed\n");
                return -1;
            }
        } else {
            fprintf(stderr, "Usage: stamp [input] [output] [text]\n");
            return -1;
        }
    }
}
