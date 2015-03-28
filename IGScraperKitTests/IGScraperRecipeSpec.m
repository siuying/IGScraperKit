//
//  IGScraperRecipeSpec.m
//  IGScraperKit
//
//  Created by Chan Fai Chong on 28/3/15.
//  Copyright (c) 2015 Francis Chong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Kiwi/Kiwi.h>
#import "IGScraperRecipe.h"

SPEC_BEGIN(IGScraperRecipeSpec)

describe(@"IGScraperRecipe", ^{
    __block IGScraperRecipe* recipe;
    beforeEach(^{
        recipe = [[IGScraperRecipe alloc] init];
    });
    
    describe(@"-addURLPattern:withScraperBlock:", ^{
        it(@"should add a new URL handler", ^{
            [recipe addURLPattern:[NSRegularExpression regularExpressionWithPattern:@"https?://google.com/search" options:0 error:nil]
                 withScraperBlock:^id(IGXMLNode *node, NSString *url) {
                return nil;
            }];

            [[theValue([recipe cadHandleURL:[NSURL URLWithString:@"https://google.com/search"]]) should] beTrue];
            [[theValue([recipe cadHandleURL:[NSURL URLWithString:@"http://google.com/search"]]) should] beTrue];
            [[theValue([recipe cadHandleURL:[NSURL URLWithString:@"http://google.com/a"]]) should] beFalse];
        });
        
        it(@"should only run the handler block on scrapeWithHTML:URL: with given URL", ^{
            __block BOOL executed = NO;
            __block BOOL yahooExecuted = NO;
            [recipe addURLPattern:[NSRegularExpression regularExpressionWithPattern:@"https?://yahoo.com/search" options:0 error:nil] withScraperBlock:^id(IGXMLNode *node, NSString *url) {
                yahooExecuted = YES;
                return nil;
            }];
            [recipe addURLPattern:[NSRegularExpression regularExpressionWithPattern:@"https?://google.com/search" options:0 error:nil] withScraperBlock:^id(IGXMLNode *node, NSString *url) {
                executed = YES;
                return nil;
            }];
            [recipe scrapeWithHTML:@"<html>" URL:[NSURL URLWithString:@"https://google.com/search"]];
            [[theValue(executed) shouldEventually] beTrue];
            [[theValue(yahooExecuted) should] beFalse];
        });
    });
});

SPEC_END
