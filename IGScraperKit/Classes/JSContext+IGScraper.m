//
//  JSContext+IGScraper.m
//  IGScraperKit
//
//  Created by Francis Chong on 1/2/14.
//  Copyright (c) 2014 Francis Chong. All rights reserved.
//

#import "JSContext+IGScraper.h"
#import "JSContext+IGHTMLQueryRubyAdditions.h"
#import "IGScraper.h"

@implementation JSContext (IGScraper)

- (void) configureScraperKit {
    [self configureIGHTMLQuery];
    NSString* path = [[NSBundle bundleForClass:[IGScraper class]] pathForResource:@"scraper_kit" ofType:@"js"];
    NSString* script = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self evaluateScript:script];
}

@end
