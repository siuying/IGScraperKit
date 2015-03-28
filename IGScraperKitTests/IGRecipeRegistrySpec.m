//
//  IGRecipeRegistrySpec.m
//  IGScraperKit
//
//  Created by Francis Chong on 1/4/14.
//  Copyright 2014 Francis Chong. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "IGRecipeRegistry.h"

@class IGRecipeRegistrySpec;

NSString* Recipe(NSString* resource) {
    NSString* path = [[NSBundle bundleForClass:[IGRecipeRegistry class]] pathForResource:resource ofType:@"rb"];
    NSString* script = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return script;
}

NSString* HTML(NSString* resource) {
    NSString* path = [[NSBundle bundleForClass:[IGRecipeRegistry class]] pathForResource:resource ofType:@"html"];
    NSString* script = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return script;
}

SPEC_BEGIN(IGRecipeRegistrySpec)

describe(@"IGRecipeRegistry", ^{
    __block IGRecipeRegistry* registry;
    beforeEach(^{
        registry = [[IGRecipeRegistry alloc] init];
    });

    describe(@"-loadRecipe:", ^{
        it(@"should load a ruby recipe", ^{
            [registry loadRecipe:Recipe(@"walmart") error:nil];
            [[[registry should] have:1] recipes];
        });
        
        it(@"should return error on broken spec", ^{
            NSError* error;
            [registry loadRecipe:Recipe(@"broken") error:&error];
            [[error shouldNot] beNil];
            [[theValue(error.code) should] equal:theValue(IGScraperErrorScriptingError)];
            [[[error domain] should] equal:IGScraperErrorDomain];
        });
    });

    describe(@"-scraperWithUrl:", ^{
        it(@"should create scraper with url", ^{
            NSString* html = HTML(@"walmart");
            NSString* url = @"http://www.walmart.com/search/search-ng.do?search_constraint=0&ic=48_0&search_query=batman&Find.x=0&Find.y=0&Find=Find%22";
            [registry loadRecipe:Recipe(@"walmart") error:nil];
            
            IGScraper* scraper = [registry scraperWithUrl:url];
            [[scraper shouldNot] beNil];

            NSDictionary* result = [scraper scrapeWithHTML:html URL:[NSURL URLWithString:url]];
            [[result shouldNot] beNil];
            [[result should] beKindOfClass:[NSDictionary class]];
            [[result[@"title"] should] equal:@"batman - Walmart.com"];
            NSArray* items = result[@"items"];
            [[theValue([items count]) should] equal:theValue(16)];
        });
    });
    
    describe(@"-scrapeWithHTML:url:", ^{
        it(@"should scrape and return hash (dictionary)", ^{
            NSString* html = HTML(@"walmart");
            NSString* url = @"http://www.walmart.com/search/search-ng.do?search_constraint=0&ic=48_0&search_query=batman&Find.x=0&Find.y=0&Find=Find%22";
            [registry loadRecipe:Recipe(@"walmart") error:nil];
            NSDictionary* result = [registry scrapeWithHTML:html URL:[NSURL URLWithString:url]];
            [[result shouldNot] beNil];
            [[result should] beKindOfClass:[NSDictionary class]];
            [[result[@"title"] should] equal:@"batman - Walmart.com"];
            NSArray* items = result[@"items"];
            [[theValue([items count]) should] equal:theValue(16)];
        });

        it(@"should scrape and return aray", ^{
            NSString* html = HTML(@"google");
            NSString* url = @"https://www.google.com/search?q=doughnuts";
            [registry loadRecipe:Recipe(@"google") error:nil];

            NSArray* result = [registry scrapeWithHTML:html URL:[NSURL URLWithString:url]];
            [[result shouldNot] beNil];
            [[result should] beKindOfClass:[NSArray class]];
            [[theValue([result count]) should] equal:theValue(10)];
        });
        
        it(@"should scrape text page with on_text", ^{
            NSString* html = @"[1]";
            NSString* url = @"http://www.walmart.com/test.json";
            [registry loadRecipe:Recipe(@"walmart") error:nil];

            NSArray* result = [registry scrapeWithHTML:html URL:[NSURL URLWithString:url]];
            [[result shouldNot] beNil];
            [[result should] beKindOfClass:[NSArray class]];
            [[result should] equal:@[@1]];
        });
    });
});

SPEC_END
