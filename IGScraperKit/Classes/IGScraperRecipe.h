//
//  IGScraperRecipe.h
//  IGScraperKit
//
//  Created by Francis Chong on 27/3/15.
//  Copyright (c) 2015 Francis Chong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IGScraperKit.h"

extern NSString* const IGScraperRecipeErrorDomain;

/**
 * IGScraperRecipe is a scraper that handle set of URL patterns
 */
@interface IGScraperRecipe : NSObject <IGScraping>

@property (nonatomic, copy) NSString* title;

@property (nonatomic, weak) id<IGScraperDelegate> delegate;

/**
 * Add an URL handler with given URL pattern
 * @param handler a scraper block that handle given URL pattern
 * @param urlPattern a NSRegularExpression that match URL
 */
-(void) addURLPattern:(NSRegularExpression*)urlPattern
     withScraperBlock:(IGScraperBlock)handler;

/**
 * Check if recipe can handle given URL
 */
-(BOOL) cadHandleURL:(NSURL*)URL;

/**
 * @throw NSException exception is throw if html or URL is nil
 */
-(id) scrapeWithHTML:(NSString*)html URL:(NSURL*)URL;

@end
