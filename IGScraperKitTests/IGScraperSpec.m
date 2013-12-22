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
            scraper.scraperBlock = ^id(IGXMLNode* node) {
                return [[[node queryWithXPath:@"//p"] firstObject] text];
            };
            NSString* text = [scraper scrape:@"<html><p>Hello World</p></html>"];
            [[text should] equal:@"Hello World"];
        });
    });
    
    describe(@"-setScraperBlockWithJavaScript:", ^{
        it(@"should use js to scrape", ^{
            [scraper setScraperBlockWithJavaScript:@"node.queryWithXPath('//p').firstObject().text()"];
            
            NSString* text = [scraper scrape:@"<html><p>Hello World</p></html>"];
            [[text should] equal:@"Hello World"];
        });

        it(@"should return error when problem parsing script", ^{
            [scraper setScraperBlockWithJavaScript:@"node.queryWithXPath('//p').firstObject.."];
            NSString* text = [scraper scrape:@"<html><p>Hello World</p></html>"];
            [[text should] beNil];
            [[scraper.error shouldNot] beNil];
        });
    });
    
});

SPEC_END