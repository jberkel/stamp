#import <XCTest/XCTest.h>
#import "Stamper.h"

@interface StamperTest : XCTestCase
@property Stamper *subject;
@property NSString *target;
@end

@implementation StamperTest

- (void)setUp
{
    [super setUp];
    self.subject = [[Stamper alloc] initWithFile:@"tests/icons/Icon.png"];
    self.target = [NSTemporaryDirectory() stringByAppendingPathComponent:@"icon.png"];

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

- (void)testSaveToShouldReturnTrueIfFailedSavedSuccessfully
{
    XCTAssertTrue([self.subject saveTo:self.target], @"saveTo should return");
}

- (void)testSaveToShouldCreateFile
{
    [self.subject saveTo:self.target];
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:self.target], @"file does not exist");
}

@end
