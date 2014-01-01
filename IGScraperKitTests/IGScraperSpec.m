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
            scraper = [IGScraper scraperWithBlock:^id(IGXMLNode* node, NSString* url) {
                return [[[node queryWithXPath:@"//p"] firstObject] text];
            }];
            NSString* text = [scraper scrapeWithHTML:@"<html><p>Hello World</p></html>" url:@"http://www.google.com/1.html"];
            [[text should] equal:@"Hello World"];
        });

        it(@"should return nil if html not found", ^{
            scraper = [IGScraper scraperWithBlock:^id(IGXMLNode* node, NSString* url) {
                return [[[node queryWithXPath:@"//p"] firstObject] text];
            }];
            NSString* text = [scraper scrapeWithHTML:@"<html></html>" url:@"http://www.google.com/1.html"];
            [[text should] beNil];
        });

        it(@"should scrape html with javascript", ^{
            scraper = [IGScraper scraperWithJavaScript:@"node.queryWithXPath('//p').firstObject().text()"];
            
            NSString* text = [scraper scrapeWithHTML:@"<html><p>Hello World</p></html>" url:@"http://www.google.com/1.html"];
            [[text should] equal:@"Hello World"];
        });

        it(@"should access url with javascript", ^{
            scraper = [IGScraper scraperWithJavaScript:@"url"];
            
            NSString* text = [scraper scrapeWithHTML:@"<html><p>Hello World</p></html>" url:@"http://www.google.com/1.html"];
            [[text should] equal:@"http://www.google.com/1.html"];
        });

        it(@"should return nil and set error when problem parsing javascript", ^{
            scraper = [IGScraper scraperWithJavaScript:@"node.queryWithXPath('//p').firstObject().."];
            
            NSString* text = [scraper scrapeWithHTML:@"<html><p>Hello World</p></html>" url:@"http://www.google.com/1.html"];
            [[text should] beNil];
            [[scraper.error shouldNot] beNil];
        });

        it(@"should scrape html with Ruby", ^{
            scraper = [IGScraper scraperWithRuby:@"node.xpath('//p').first.text"];
            NSString* text = [scraper scrapeWithHTML:@"<html><p>Hello World</p></html>" url:@"http://www.google.com/1.html"];
            [[text should] equal:@"Hello World"];
            [[scraper.error should] beNil];
        });

        it(@"should access URL within Ruby", ^{
            scraper = [IGScraper scraperWithRuby:@"url"];

            NSString* text = [scraper scrapeWithHTML:@"<html><img src='a.jpg'></html>" url:@"http://www.google.com/1.html"];
            [[text should] equal:@"http://www.google.com/1.html"];
            [[scraper.error should] beNil];
        });
    });
    
});

SPEC_END