#import "Stamper.h"

@interface Stamper ()
@property (nonatomic) NSImage *image;
@property (nonatomic) NSString *iconFile;
@end

@implementation Stamper

- (instancetype)initWithFile:(NSString *)file
{
    self = [super init];
    if (self) {
        NSParameterAssert(file);
        _iconFile = file;
        _textShadow = [self defaultTextShadow];
        _textColor  = [NSColor whiteColor];
        _allowEmpty = NO;
    }
    return self;
}

- (BOOL)addText:(NSString *)text
{
    return [self addTextUsingLayoutManager:text];
}

- (BOOL)saveTo:(NSString *)target
{
    NSData *pngData = [[self bitmapRepresentation] representationUsingType:NSPNGFileType properties:nil];
    return [pngData writeToFile:target atomically:YES];
}

#pragma mark private

- (BOOL)addTextUsingLayoutManager:(NSString *)text
{
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithString:text attributes:self.textAttributes];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    NSSize containerSize = NSMakeSize(self.iconSize.width, self.iconSize.height);
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithContainerSize:containerSize];

    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];

    NSRange glyphRange = [self adjustFontSize:layoutManager
                                 forMaxHeight:(self.iconSize.height * (1/3.0))
                                  textStorage:textStorage
                                textContainer:textContainer
                                         font:self.font];

    if (glyphRange.length > 0) {
        [self.image lockFocusFlipped:YES];
        NSRect usedRect = [layoutManager usedRectForTextContainer:textContainer];
        NSPoint point = NSMakePoint(0, self.iconSize.height - usedRect.size.height - self.bottomPadding);
        [layoutManager drawGlyphsForGlyphRange:glyphRange atPoint:point];
        [self.image unlockFocus];
        return YES;
    } else {
        return self.allowEmpty;
    }
}

- (CGFloat)bottomPadding
{
    return self.iconSize.width / 24.0;
}

- (NSRange)adjustFontSize:(NSLayoutManager *)layoutManager
             forMaxHeight:(CGFloat)maxHeight
               textStorage:(NSTextStorage *)textStorage
             textContainer:(NSTextContainer *)textContainer
                      font:(NSFont *)font
{
    [textStorage setFont:font];
    NSRange renderedRange = [layoutManager glyphRangeForTextContainer:textContainer];
    NSRect  usedRect = [layoutManager usedRectForTextContainer:textContainer];
    NSUInteger numGlyphs = [layoutManager numberOfGlyphs];

    if (usedRect.size.height <= maxHeight && renderedRange.length == numGlyphs) {
        return renderedRange;
    } else {
        CGFloat newPointSize = font.pointSize - 0.1;
        /*
        NSLog(@"decreasing font size to %f, "
                "usedRect: %@ "
                "maxHeight: %f "
                "renderedRange: (%lu/%lu)", newPointSize,
                NSStringFromRect(usedRect),
                maxHeight,
                renderedRange.length,
                numGlyphs);
                */
        CGFloat minPointSize = MAX(8, self.iconSize.height / 10.0);

        if (newPointSize >= minPointSize) {
            return [self adjustFontSize:layoutManager
                           forMaxHeight:maxHeight
                            textStorage:textStorage
                          textContainer:textContainer
                                   font:[NSFont fontWithName:font.fontName size:newPointSize]];
        } else {
            return NSMakeRange(0, 0);
        }
    }
}

- (NSFont *)font
{
    return [NSFont fontWithName:@"HelveticaNeue-Light" size:self.iconSize.height / 4.0];
}

- (NSShadow *)defaultTextShadow
{
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = NSMakeSize(1.5, 1);
    shadow.shadowBlurRadius = 0.2;
    shadow.shadowColor = [NSColor controlDarkShadowColor];
    return shadow;
}

- (NSDictionary *)textAttributes
{
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSCenterTextAlignment;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSMutableDictionary *attrs = @{
        NSParagraphStyleAttributeName: paragraphStyle,
        NSFontAttributeName: [self font],
        NSForegroundColorAttributeName: self.textColor ?: [NSColor whiteColor],
    }.mutableCopy;

    if (self.textShadow) {
        attrs[NSShadowAttributeName] = self.textShadow;
    }
    return attrs;
}

- (NSSize)iconSize
{
    return self.image.size;
}

- (NSImage *)image
{
    if (!_image) {
        _image = [[NSImage alloc] initWithData:[NSData dataWithContentsOfFile:self.iconFile]];
        NSAssert(_image, @"image could not be loaded from %@", self.iconFile);
    }
    return _image;
}

- (NSBitmapImageRep *)bitmapRepresentation
{
    NSBitmapImageRep *bitmapImageRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
                                                                               pixelsWide:(NSInteger)self.iconSize.width
                                                                               pixelsHigh:(NSInteger)self.iconSize.height
                                                                            bitsPerSample:8
                                                                          samplesPerPixel:4
                                                                                 hasAlpha:YES
                                                                                 isPlanar:NO
                                                                           colorSpaceName:NSDeviceRGBColorSpace
                                                                              bytesPerRow:0
                                                                             bitsPerPixel:0];
    bitmapImageRep.size = self.iconSize;

    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithBitmapImageRep:bitmapImageRep]];

    [self.image drawAtPoint:NSMakePoint(0, 0)
                   fromRect:NSZeroRect
                  operation:NSCompositeSourceOver
                   fraction:1.0];

    [NSGraphicsContext restoreGraphicsState];

    return bitmapImageRep;
}

@end
