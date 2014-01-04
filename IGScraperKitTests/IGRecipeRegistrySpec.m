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
            [registry loadRecipe:Recipe(@"walmart")];
            [[[registry should] have:1] recipes];
        });
    });
    
    describe(@"-scrapeWithHTML:url:", ^{
        it(@"should scrape supplied HTML and URL", ^{
            NSString* html = HTML(@"walmart");
            NSString* url = @"http://www.walmart.com/search/search-ng.do?search_constraint=0&ic=48_0&search_query=batman&Find.x=0&Find.y=0&Find=Find%22";
            [registry loadRecipe:Recipe(@"walmart")];
            NSDictionary* result = [registry scrapeWithHTML:html url:url];
            [[result shouldNot] beNil];
            [[result should] beKindOfClass:[NSDictionary class]];
            [[result[@"title"] should] equal:@"batman - Walmart.com"];
            NSArray* items = result[@"items"];
            [[theValue([items count]) should] equal:theValue(16)];
        });
    });
});

SPEC_END
