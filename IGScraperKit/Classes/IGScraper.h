//
//  IGScraper.h
//  IGScraperKit
//
//  Created by Francis Chong on 12/22/13.
//  Copyright (c) 2013 Francis Chong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IGHTMLQuery.h"

typedef id (^IGScraperBlock)(IGXMLNode* node);

extern NSString* const IGScraperErrorDomain;

NS_ENUM(NSInteger, IGScraperErrors) {
    IGScraperErrorUndefinedScraperBlock = 1
};

@interface IGScraper : NSObject

@property (nonatomic, copy) IGScraperBlock scraperBlock;
@property (nonatomic, strong) NSError* error;

-(instancetype) initWithBlock:(IGScraperBlock)scaperBlock;

+(instancetype) scraperWithBlock:(IGScraperBlock)scaperBlock;

-(id) scrape:(NSString*)html;

@end
