@interface Stamper : NSObject

- (instancetype)init __attribute__((unavailable("init not available ")));
- (instancetype)initWithFile:(NSString *)file;

- (BOOL)addText:(NSString *)text;
- (BOOL)saveTo:(NSString *)target;

@end
