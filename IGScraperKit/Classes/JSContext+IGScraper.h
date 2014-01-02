//
//  JSContext+IGScraper.h
//  IGScraperKit
//
//  Created by Francis Chong on 1/2/14.
//  Copyright (c) 2014 Francis Chong. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>

@interface JSContext (IGScraper)

/**
 Load IGScraperKit ruby code into current context
 */
- (void) configureScraperKit;

@end
