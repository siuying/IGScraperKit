//
//  IGRecipeRegistry.m
//  IGScraperKit
//
//  Created by Francis Chong on 1/4/14.
//  Copyright (c) 2014 Francis Chong. All rights reserved.
//

#import "IGRecipeRegistry.h"
#import <JavaScriptCore/JavaScriptCore.h>

#import "IGScraper.h"
#import "JSContext+OpalAdditions.h"
#import "IGHTMLQuery.h"
#import "JSContext+IGHTMLQueryRubyAdditions.h"

@interface IGRecipeRegistry()
@property (nonatomic, strong) JSContext* context;
@property (nonatomic, strong) JSValue* recipeRegistry;
@end

@implementation IGRecipeRegistry

-(instancetype) init {
    self = [super init];
    [self setup];
    return self;
}

-(void) loadRecipe:(NSString*)rubyRecipe {
    if (!rubyRecipe) {
        [NSException raise:NSInvalidArgumentException format:@"recipe cannot be nil"];
    }

    [self.context evaluateRuby:rubyRecipe];
    NSAssert(rubyRecipe != nil, @"error loading %@", rubyRecipe);
}

-(NSArray*) recipes {
    return [[self.context evaluateRuby:@"ScraperKit::RecipeRegistry.instance.recipes.collect{|r| r.metadata.to_n }"] toArray];
}

-(IGScraper*) scraperWithUrl:(NSString*)url {
    JSValue* scraper = [[self recipeRegistry] invokeMethod:@"$scraper_for_url" withArguments:@[url]];
    if ([scraper isUndefined] || [scraper isNull] || [[scraper invokeMethod:@"$to_n" withArguments:@[]] isNull]) {
        return nil;
        
    } else {
        IGScraperBlock scraperBlock = ^id(IGXMLNode* node, NSString* url){
            JSValue* xmlNode = [[[scraper context] evaluateRuby:@"lambda {|node| XMLNode.new(node) }"] callWithArguments:@[node]];
            JSValue* value = [scraper invokeMethod:@"$scrape" withArguments:@[xmlNode, url]];
            if ([value isNull] || [value isUndefined]) {
                return nil;
            } else {
                JSValue* nativeValue = [value invokeMethod:@"$to_n" withArguments:@[]];
                if ([nativeValue isNull] || [nativeValue isUndefined]) {
                    return nil;
                } else {
                    return [nativeValue toObject];
                }
            }
        };
        return [IGScraper scraperWithBlock:scraperBlock];
    }
}

-(id) scrapeWithHTML:(NSString*)html url:(NSString*)url {
    JSValue* scraper = [[self recipeRegistry] invokeMethod:@"$scraper_for_url" withArguments:@[url]];
    if ([scraper isUndefined] || [scraper isNull] || [[scraper invokeMethod:@"$to_n" withArguments:@[]] isNull]) {
        return nil;
        
    } else {
        IGHTMLDocument* doc = [[IGHTMLDocument alloc] initWithHTMLString:html error:nil];
        JSValue* xmlNode = [[[scraper context] evaluateRuby:@"lambda {|node| XMLNode.new(node) }"] callWithArguments:@[doc]];
        JSValue* value = [scraper invokeMethod:@"$scrape" withArguments:@[xmlNode, url]];
        if ([value isNull] || [value isUndefined]) {
            return nil;
        } else {
            JSValue* nativeValue = [value invokeMethod:@"$to_n" withArguments:@[]];
            if ([nativeValue isNull] || [nativeValue isUndefined]) {
                return nil;
            } else {
                return [nativeValue toObject];
            }
        }
    }
}

#pragma mark - Private

/**
 Load base classed required.
 */
-(void) setup {
    self.context = [[JSContext alloc] init];
    [self.context configureIGHTMLQuery];
    
    NSString* path = [[NSBundle bundleForClass:[self class]] pathForResource:@"scraper_kit" ofType:@"js"];
    NSString* script = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSAssert(script != nil, @"error loading scraper_kit.js");
    [self.context evaluateScript:script];
}

#pragma mark - Private JavaScript methods

-(JSValue*) recipeRegistry {
    if (!_recipeRegistry) {
        _recipeRegistry = [self.context evaluateScript:@"Opal.ScraperKit.RecipeRegistry.$instance()"];
    }
    return _recipeRegistry;
}

@end
