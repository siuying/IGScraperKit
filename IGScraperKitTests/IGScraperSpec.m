#import "IGScraper.h"
#import "IGXMLNode.h"
#import "Kiwi.h"

SPEC_BEGIN(IGScraperSpec)

describe(@"IGScraper", ^{
    __block IGScraper* scraper;
    
    beforeEach(^{
        scraper = [[IGScraper alloc] init];
    });

    describe(@"-scrape:", ^{
        it(@"should scrape html with block", ^{
            scraper = [IGScraper scraperWithBlock:^id(IGXMLNode* node) {
                return [[[node queryWithXPath:@"//p"] firstObject] text];
            }];
            NSString* text = [scraper scrape:@"<html><p>Hello World</p></html>"];
            [[text should] equal:@"Hello World"];
        });

        it(@"should return nil if html not found", ^{
            scraper = [IGScraper scraperWithBlock:^id(IGXMLNode* node) {
                return [[[node queryWithXPath:@"//p"] firstObject] text];
            }];
            NSString* text = [scraper scrape:@"<html></html>"];
            [[text should] beNil];
        });

        it(@"should scrape html with javascript", ^{
            scraper = [IGScraper scraperWithJavaScript:@"node.queryWithXPath('//p').firstObject().text()"];
            
            NSString* text = [scraper scrape:@"<html><p>Hello World</p></html>"];
            [[text should] equal:@"Hello World"];
        });

        it(@"should return nil and set error when problem parsing javascript", ^{
            scraper = [IGScraper scraperWithJavaScript:@"node.queryWithXPath('//p').firstObject().."];
            
            NSString* text = [scraper scrape:@"<html><p>Hello World</p></html>"];
            [[text should] beNil];
            [[scraper.error shouldNot] beNil];
        });
    });
    
});

SPEC_END