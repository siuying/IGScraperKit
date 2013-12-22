#import "Kiwi.h"
#import "IGScraper.h"
#import "IGXMLNode.h"

SPEC_BEGIN(IGScraperSpec)

describe(@"-scrape:", ^{
    __block IGScraper* scraper;
    
    beforeEach(^{
        scraper = [[IGScraper alloc] init];
    });

    it(@"should scrape html with block", ^{
        scraper.scraperBlock = ^id(IGXMLNode* node) {
            return [[[node queryWithXPath:@"//p"] firstObject] text];
        };
        NSString* text = [scraper scrape:@"<html><p>Hello World</p></html>"];
        [[text should] equal:@"Hello World"];
    });
});

SPEC_END