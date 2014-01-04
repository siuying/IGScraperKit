//
//  IGScraperDelegate.h
//  IGScraperKit
//
//  Created by Francis Chong on 1/4/14.
//  Copyright (c) 2014 Francis Chong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IGScraper.h"

@protocol IGScraping;

@protocol IGScraperDelegate <NSObject>

@optional

-(void) scraper:(id<IGScraping>)scraper scrapeDidFailed:(NSError*)error;

-(void) scraper:(id<IGScraping>)scraper scrapeDidSucceed:(id)result;

@end