//
//  NSObject+Property.h
//  158Job
//
//  Created by X on 14/9/2.
//  Copyright (c) 2014年 X.H. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Property)

-(instancetype)initWithDictionary:(NSDictionary*)dict;

- (NSArray *)getPropertyList;

- (NSArray*)getPropertyTypeList;

- (NSDictionary *)convertDictionary;

- (void)dictionaryForObject:(NSDictionary*) dict;

- (void)fromDictionary:(NSDictionary*) dict;

@end
