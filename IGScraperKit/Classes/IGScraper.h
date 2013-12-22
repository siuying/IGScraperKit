//
//  IGScraper.h
//  IGScraperKit
//
//  Created by Francis Chong on 12/22/13.
//  Copyright (c) 2013 Francis Chong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IGHTMLQuery.h"

typedef id (^IGScraperBlock)(IGXMLNode* node);

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

 @return object as processed by `scraperBlock`.
 */
-(id) scrape:(NSString*)html;

#ifdef IGSCRAPERKIT_JAVASCRIPT_ADDITIONS
/**
 Create a scraper from JavaScript. Refer ``setScraperBlockWithJavaScript:`` for details.

 @return created scraper.
 */
+(instancetype) scraperWithJavaScript:(NSString*)script;

/**
 Set the scraper block by using javascript. The script is evalulated in a context with ``node`` set to the IGXMLNode being parsed.
 Refer to ``scraperWithBlock:`` for details.
 */
-(void) setScraperBlockWithJavaScript:(NSString*)javascript;
#endif

@end
