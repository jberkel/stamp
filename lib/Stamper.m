#import "Stamper.h"

@interface Stamper ()
@property NSImage *image;
@end

@implementation Stamper

- (id)initWithFile:(NSString *)file
{
    self = [super init];
    if (self) {
        NSParameterAssert(file);
        _image = [[NSImage alloc] initWithContentsOfFile:file];
        NSAssert(_image, @"image is nil");
    }

    return self;
}

- (void)addText:(NSString *)text
{
    [self.image lockFocus];

    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setAlignment:NSCenterTextAlignment];

    NSDictionary *attributes = @{
       NSParagraphStyleAttributeName: paragraphStyle,
       NSFontAttributeName: [self font],
       NSForegroundColorAttributeName: [NSColor whiteColor],
//       NSShadowAttributeName: [self shadow],
    };

    [text drawWithRect:NSMakeRect(0, 5, self.image.size.width, self.image.size.height)
               options:NSStringDrawingDisableScreenFontSubstitution
            attributes:attributes];


    [self.image unlockFocus];
}

- (NSFont *)font
{
    return [NSFont fontWithName:@"ComicSansMS" size:12.0];
}

- (NSShadow *)shadow
{
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = NSMakeSize(0, -8);
    shadow.shadowBlurRadius = 0.5;
    shadow.shadowColor = [NSColor colorWithCalibratedWhite:1 alpha:0.55];
    return shadow;
}


- (BOOL)saveTo:(NSString *)target
{
    NSData *pngData = [[self imageRep] representationUsingType:NSPNGFileType properties:nil];
    return [pngData writeToFile:target atomically:YES];
}

#pragma mark private

- (NSBitmapImageRep *)imageRep
{
    CGImageRef cgRef = [self.image CGImageForProposedRect:NULL
                                                  context:nil
                                                    hints:nil];

    NSBitmapImageRep *bitmapImageRep = [[NSBitmapImageRep alloc] initWithCGImage:cgRef];
    [bitmapImageRep setSize:[self.image size]];
    return bitmapImageRep;
}

@end
