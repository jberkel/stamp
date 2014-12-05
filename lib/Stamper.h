@interface Stamper : NSObject

@property (nonatomic, readwrite) NSColor  *textColor;
@property (nonatomic, readwrite) NSShadow *textShadow;
@property (nonatomic, readwrite) BOOL allowEmpty;

- (instancetype)init __attribute__((unavailable("init not available ")));
- (instancetype)initWithFile:(NSString *)file;

- (BOOL)addText:(NSString *)text;
- (BOOL)saveTo:(NSString *)target;

@end
