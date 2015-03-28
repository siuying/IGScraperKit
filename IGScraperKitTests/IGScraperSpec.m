#import "IGScraper.h"
#import "IGXMLNode.h"
#import "Kiwi.h"
#import <JavaScriptCore/JavaScriptCore.h>

SPEC_BEGIN(IGScraperSpec)

describe(@"IGScraper", ^{
    __block IGScraper* scraper;
    
    beforeEach(^{
        scraper = [[IGScraper alloc] init];
    });

    describe(@"-scrape:", ^{
        it(@"should scrape html with block", ^{
            scraper = [IGScraper scraperWithBlock:^id(IGXMLNode* node, NSString* url) {
                return [[[node queryWithXPath:@"//p"] firstObject] text];
            }];
            NSString* text = [scraper scrapeWithHTML:@"<html><p>Hello World</p></html>" URL:[NSURL URLWithString:@"http://www.google.com/1.html"]];
            [[text should] equal:@"Hello World"];
        });

        it(@"should return nil if html not found", ^{
            scraper = [IGScraper scraperWithBlock:^id(IGXMLNode* node, NSString* url) {
                return [[[node queryWithXPath:@"//p"] firstObject] text];
            }];
            NSString* text = [scraper scrapeWithHTML:@"<html></html>" URL:[NSURL URLWithString:@"http://www.google.com/1.html"]];
            [[text should] beNil];
        });
    });
    
});

SPEC_END