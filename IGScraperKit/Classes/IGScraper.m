//
//  IGScraper.m
//  IGScraperKit
//
//  Created by Francis Chong on 12/22/13.
//  Copyright (c) 2013 Francis Chong. All rights reserved.
//

#import "IGScraper.h"
#import "IGHTMLQuery.h"

NSString* const IGScraperErrorDomain = @"IGScraperError";

@implementation IGScraper

-(instancetype) initWithBlock:(IGScraperBlock)scraperBlock {
    if ([super init]) {
        self.scraperBlock = scraperBlock;
    }
    return self;
}

+(instancetype) scraperWithBlock:(IGScraperBlock)scraperBlock {
    return [[self alloc] initWithBlock:scraperBlock];
}

-(id) scrapeWithHTML:(NSString*)html url:(NSString*)url {
    if (self.scraperBlock) {
        NSError* error;
        IGHTMLDocument* doc = [[IGHTMLDocument alloc] initWithHTMLString:html error:&error];
        if (error == nil) {
            return self.scraperBlock(doc, url);
        } else {
            self.error = error;
            return nil;
        }
    } else {
        NSError* error = [NSError errorWithDomain:IGScraperErrorDomain
                                             code:IGScraperErrorUndefinedScraperBlock userInfo:nil];
        self.error = error;
        return nil;
    }
}

@end
