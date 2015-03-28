//
//  IGScraperRecipe.m
//  IGScraperKit
//
//  Created by Francis Chong on 27/3/15.
//  Copyright (c) 2015 Francis Chong. All rights reserved.
//

#import "IGScraperRecipe.h"
#import <IGHTMLQuery/IGHTMLQuery.h>

NSString* const IGScraperRecipeErrorDomain = @"IGScraperRecipeErrorDomain";

@interface IGScraperRecipe ()
@property (nonatomic, strong) NSMutableDictionary* recipes;
@end

@implementation IGScraperRecipe

-(instancetype) init
{
    self = [super init];
    self.recipes = [NSMutableDictionary dictionary];
    return self;
}

-(void) addURLHandler:(IGScraperBlock)handler withURLPattern:(NSRegularExpression*)urlPattern
{
    [self.recipes setObject:handler forKey:urlPattern];
}

-(BOOL) cadHandleURL:(NSURL*)URL
{
    __block BOOL canHandle = false;
    NSString* urlString = URL.absoluteString;
    [self.recipes enumerateKeysAndObjectsUsingBlock:^(NSRegularExpression* urlPattern, IGScraperBlock handler, BOOL *stop) {
        if ([[urlPattern matchesInString:urlString options:0 range:NSMakeRange(0, urlString.length)] count] > 0) {
            canHandle = YES;
            *stop = YES;
        }
    }];
    return canHandle;
}

-(id) scrapeWithHTML:(NSString*)html URL:(NSURL*)URL
{
    NSParameterAssert(html);
    NSParameterAssert(URL);

    __block id result = nil;
    __block BOOL matched = false;
    NSString* urlString = URL.absoluteString;
    [self.recipes enumerateKeysAndObjectsUsingBlock:^(NSRegularExpression* urlPattern, IGScraperBlock handler, BOOL *stop) {
        if ([[urlPattern matchesInString:urlString options:0 range:NSMakeRange(0, urlString.length)] count] > 0) {
            NSError* error;
            IGHTMLDocument* doc = [[IGHTMLDocument alloc] initWithHTMLString:html error:&error];
            if (error == nil) {
                result = handler(doc, urlString);
                if (self.delegate) {
                    [self.delegate scraper:self scrapeDidSucceed:result];
                }
            } else {
                [self.delegate scraper:self scrapeDidFailed:error];
            }
            matched = YES;
            *stop = YES;
        }
    }];
    
    if (!matched) {
        [self.delegate scraper:self scrapeDidFailed:[NSError errorWithDomain:IGScraperRecipeErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey: @"No scraper handler found", NSLocalizedFailureReasonErrorKey: [@"no scraper supported for URL: " stringByAppendingString:URL.absoluteString] }]];
    }

    return result;
}

@end
