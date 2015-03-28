//
//  IGRecipeRegistry.h
//  IGScraperKit
//
//  Created by Francis Chong on 1/4/14.
//  Copyright (c) 2014 Francis Chong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "IGScraper.h"
#import "IGScraperDelegate.h"

/**
 IGRecipeRegistry load recipes defined in ruby class, and find scrapers defined in recipes.
 */
@interface IGRecipeRegistry : NSObject <IGScraping>

@property (nonatomic, strong) JSContext* context;

@property (nonatomic, weak) id<IGScraperDelegate> delegate;

-(void) loadRecipe:(NSString*)rubyRecipe error:(NSError* __autoreleasing *)error;

-(NSArray*) recipes;

/**
 Get a scraper that can scrape the supplied URL.
 
 @return a IGScraper that can scrape the URL if one is defined in recipe.
 @return nil if no appropriate scraper defined.
 */
-(IGScraper*) scraperWithUrl:(NSString*)url;

/**
 Scrape the HTML, using scraper defined in recipes loaded.

 @param html HTML string
 @param url URL string of the page to be parsed

 @return object as processed by the recipe scraper, if any. Return nil if not found.
 */
-(id) scrapeWithHTML:(NSString*)html URL:(NSURL*)URL;

@end
