//
//  WRJsonParser.h
//  rehab
//
//  Created by Matech on 3/3/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WRJsonParser : NSObject

+(instancetype)ParserFromString:(NSString*)value;
+(instancetype)ParserFromDictionary:(NSDictionary*)dict;
-(instancetype)initWithString:(NSString*)value;

@property(readonly, nonatomic) id resultObject;
@property(readonly, nonatomic) id extraObject;
@property(readonly, nonatomic) BOOL isSuccess;
@property(nonatomic) NSInteger errorCode;
@property(nonatomic) NSString* errorString;

@end
