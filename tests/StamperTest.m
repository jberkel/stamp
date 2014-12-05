#import <XCTest/XCTest.h>
#import "Stamper.h"

@interface StamperTest : XCTestCase
@property Stamper *subject;
@property NSString *initial;
@property NSString *target;
@end

@implementation StamperTest

- (void)setUp
{
    [super setUp];
    self.initial = @"tests/icons/Icon.png";
    self.target = [NSTemporaryDirectory() stringByAppendingPathComponent:@"icon.png"];
    self.subject = [[Stamper alloc] initWithFile:self.initial];

    if ([[NSFileManager defaultManager] fileExistsAtPath:self.target]) {
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:self.target error:&error];
        XCTAssertNil(error);
    }
}

- (void)testAddTextToImage
{
    XCTAssertTrue([self.subject addText:@"Testing"]);
}

- (void)testAddingMoreTestWhichCanFitReturnsFalse
{
    XCTAssertFalse([self.subject addText:@"Testing abcdefghijklmno qrstuvxyzdsa 123456789"]);
}

- (void)testAddingMoreTestWhichCanFitReturnsTrueIfAllowEmpty
{
    self.subject.allowEmpty = YES;

    XCTAssertTrue([self.subject addText:@"Testing abcdefghijklmno qrstuvxyzdsa 123456789"]);
}

- (void)testSaveToShouldReturnTrueIfFailedSavedSuccessfully
{
    XCTAssertTrue([self.subject saveTo:self.target], @"saveTo should return");
}

- (void)testSaveToShouldCreateFile
{
    [self.subject saveTo:self.target];
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:self.target], @"file does not exist");
}

- (void)testSavedFileSHouldHaveTheRightSize
{
    [self.subject saveTo:self.target];

    NSImage *initialImage = [[NSImage alloc] initWithData:[NSData dataWithContentsOfFile:self.initial]];
    NSImage *targetImage = [[NSImage alloc] initWithData:[NSData dataWithContentsOfFile:self.target]];

    XCTAssertTrue(NSEqualSizes(targetImage.size, initialImage.size));
}

@end
