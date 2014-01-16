@interface Stamper : NSObject

- (instancetype)init __attribute__((unavailable("init not available ")));

- (id)initWithFile:(NSString *)file;

- (void)addText:(NSString *)text;
- (BOOL)saveTo:(NSString *)target;

@end
