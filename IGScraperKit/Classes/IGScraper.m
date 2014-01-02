//
//  IGScraper.m
//  IGScraperKit
//
//  Created by Francis Chong on 12/22/13.
//  Copyright (c) 2013 Francis Chong. All rights reserved.
//

#import "IGScraper.h"

#ifdef IGSCRAPERKIT_ENABLE_SCRIPTING
#import <JavaScriptCore/JavaScriptCore.h>
#import "JSContext+OpalAdditions.h"
#import "JSContext+IGHTMLQueryRubyAdditions.h"
#import "JSContext+IGScraper.h"

@interface IGScraper()
@property (nonatomic, strong) JSContext* jsContext;
@property (nonatomic, strong) JSValue* scraperScope;
@end
#endif

NSString* const IGScraperErrorDomain = @"IGScraperError";

@implementation IGScraper

-(instancetype) initWithBlock:(IGScraperBlock)scraperBlock {
    if ([super init]) {
        self.scraperBlock = scraperBlock;
    }
    return self;
}

+(instancetype) scraperWithBlock:(IGScraperBlock)scraperBlock {
    return [[self alloc] initWithBlock:scraperBlock];
}

-(id) scrapeWithHTML:(NSString*)html url:(NSString*)url {
    if (self.scraperBlock) {
        NSError* error;
        IGHTMLDocument* doc = [[IGHTMLDocument alloc] initWithHTMLString:html error:&error];
        if (error == nil) {
            return self.scraperBlock(doc, url);
        } else {
            self.error = error;
            return nil;
        }
    } else {
        NSError* error = [NSError errorWithDomain:IGScraperErrorDomain
                                             code:IGScraperErrorUndefinedScraperBlock userInfo:nil];
        self.error = error;
        return nil;
    }
}

#ifdef IGSCRAPERKIT_ENABLE_SCRIPTING
#pragma mark - JavaScriptAdditions

-(JSContext*) jsContext {
    if (!_jsContext) {
        _jsContext = [[JSContext alloc] init];
        __block NSError* localError = nil;
        __weak IGScraper* scraper = self;
        _jsContext.exceptionHandler = ^(JSContext *context, JSValue *exception) {
            NSMutableDictionary* dictionary = [exception toDictionary].mutableCopy;
            dictionary[@"message"] = [exception toString];
            localError = [NSError errorWithDomain:IGScraperErrorDomain
                                             code:IGScraperErrorJavaScriptError
                                         userInfo:dictionary];
            scraper.error = localError;
        };
    }
    return _jsContext;
}

-(JSValue*) scraperScope {
    if (!_scraperScope) {
        [self.jsContext configureScraperKit];
        _scraperScope = [self.jsContext evaluateScript:@"Opal.ScraperScope"];
    }
    return _scraperScope;
}

+(instancetype) scraperWithJavaScript:(NSString*)script {
    IGScraper* scraper = [[self alloc] init];
    [scraper setScraperBlockWithJavaScript:script];
    return scraper;
}

+(instancetype) scraperWithRuby:(NSString*)ruby {
    IGScraper* scraper = [[self alloc] init];
    [scraper setScraperBlockWithRuby:ruby];
    return scraper;
}

-(void) setScraperBlockWithJavaScript:(NSString*)javascript {
    __weak JSContext* context = self.jsContext;
    self.scraperBlock = ^id(IGXMLNode* node, NSString* url){
        context[@"node"] = node;
        context[@"url"] = url;
        return [[context evaluateScript:javascript] toObject];
    };
}

-(void) setScraperBlockWithRuby:(NSString*)ruby {
    __weak JSValue* scraperScope = self.scraperScope;
    self.scraperBlock = ^id(IGXMLNode* node, NSString* url){
        return [[scraperScope invokeMethod:@"$builder" withArguments:@[node, url, ruby]] toObject];
    };
}

#endif
@end
