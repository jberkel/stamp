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

        NSLog(@"initialized with %@", self.image);
    }

    return self;
}

- (void)addText:(NSString *)text
{
    [self addTextUsingLayoutManager:text];
}

- (NSDictionary *)attributes
{
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setAlignment:NSCenterTextAlignment];

    return @{
            NSParagraphStyleAttributeName: paragraphStyle,
            NSFontAttributeName: [self font],
            NSForegroundColorAttributeName: [NSColor whiteColor],
//       NSShadowAttributeName: [self shadow],
    };
}

- (void)addTextUsingLayoutManager:(NSString *)text
{
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithString:text attributes:self.attributes];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithContainerSize:NSMakeSize(self.image.size.width,
            self.image.size.height)];

    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];

    NSRange glyphRange = [layoutManager glyphRangeForTextContainer:textContainer];


    NSImage *textImage = [[NSImage alloc] initWithSize:self.image.size];

    [textImage lockFocus];
    [[NSColor clearColor] setFill];
    CGContextFillRect([[NSGraphicsContext currentContext] graphicsPort], CGRectMake(0, 0, textImage.size.width, textImage.size.height));
    [layoutManager drawGlyphsForGlyphRange:glyphRange atPoint:NSMakePoint(0, -5)];
    [textImage unlockFocus];

    [self.image lockFocus];
    [textImage drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    [self.image unlockFocus];

}

- (NSFont *)font
{
    return [NSFont fontWithName:@"HelveticaNeue-Light" size:12.0];
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
