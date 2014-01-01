//
//  IGScraper.h
//  IGScraperKit
//
//  Created by Francis Chong on 12/22/13.
//  Copyright (c) 2013 Francis Chong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IGHTMLQuery.h"

typedef id (^IGScraperBlock)(IGXMLNode* node, NSString* url);

extern NSString* const IGScraperErrorDomain;

NS_ENUM(NSInteger, IGScraperErrors) {
    IGScraperErrorUndefinedScraperBlock = 1,
    IGScraperErrorJavaScriptError = 2
};

@interface IGScraper : NSObject

/**
 A block to scrape the HTML.
 */
@property (nonatomic, copy) IGScraperBlock scraperBlock;

/**
 Store error during scraping.
 */
@property (nonatomic, strong) NSError* error;

/**
 Initialize a scraper with block.
 */
-(instancetype) initWithBlock:(IGScraperBlock)scaperBlock;

/**
 Create a scraper with block.
 */
+(instancetype) scraperWithBlock:(IGScraperBlock)scaperBlock;

/**
 Scrape the HTML.
 @param html HTML string
 @param url URL string of the page to be parsed

 @return object as processed by `scraperBlock`.
 */
-(id) scrapeWithHTML:(NSString*)html url:(NSString*)url;

#ifdef IGSCRAPERKIT_ENABLE_SCRIPTING
/**
 Create a scraper from JavaScript. Refer ``setScraperBlockWithJavaScript:`` for details.

 @return created scraper.
 */

+(instancetype) scraperWithJavaScript:(NSString*)script;
/**
 Create a scraper from Ruby. The script is evalulated in a context with ``self`` set to the IGXMLNode being parsed.
 Refer to ``scraperWithBlock:`` for details.

 @return created scraper.
 */
+(instancetype) scraperWithRuby:(NSString*)ruby;

/**
 Set the scraper block by using javascript. The script is evalulated in a context with ``node`` set to the IGXMLNode being parsed.
 Refer to ``scraperWithBlock:`` for details.
 */
-(void) setScraperBlockWithJavaScript:(NSString*)javascript;

/**
 Set the scraper block by using Ruby. The script is evalulated in a context with ``self`` set to the IGXMLNode being parsed.
 Refer to ``scraperWithBlock:`` for details.
 */
-(void) setScraperBlockWithRuby:(NSString*)ruby;
#endif

@end
