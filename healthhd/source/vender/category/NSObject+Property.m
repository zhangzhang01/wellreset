//
//  NSObject+Property.m
//  158Job
//
//  Created by X on 14/9/2.
//  Copyright (c) 2014年 X.H. All rights reserved.
//

#import "NSObject+Property.h"
#import <objc/runtime.h>

@implementation NSObject (Property)

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [self init];
    if(self)
    {
        [self fromDictionary:dict];
    }
    return self;
}

- (NSArray *)getPropertyList
{
    NSMutableArray *props = [NSMutableArray array];
    Class c = [self class];
    while (YES) {
        if(c == [NSObject class])
        {
            break;
        }
        unsigned int outCount, i;
        objc_property_t *properties = class_copyPropertyList(c, &outCount);
        for (i = 0; i<outCount; i++)
        {
            const char* char_f = property_getName(properties[i]);
            NSString *propertyName = [NSString stringWithUTF8String:char_f];
            [props addObject:propertyName];
        }
        free(properties);
        c = [c superclass];
    }
    return props;
}

-(NSArray*)getPropertyTypeList
{
    NSMutableArray *types = [NSMutableArray array];
    Class c = [self class];
    while (YES) {
        if(c == [NSObject class])
        {
            break;
        }
        unsigned int count;
        objc_property_t* properties = class_copyPropertyList([self class], &count);
        for (int i = 0; i < count; i++) {
            objc_property_t property = properties[i];
            const char * type = property_getAttributes(property);
            
            NSString * typeString = [NSString stringWithUTF8String:type];
            NSArray * attributes = [typeString componentsSeparatedByString:@","];
            NSString * typeAttribute = [attributes objectAtIndex:0];
            NSString * propertyType = [typeAttribute substringFromIndex:1];
            if ([typeAttribute hasPrefix:@"T@"]) {
                propertyType = [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length]-4)];
            }
            [types addObject:propertyType];
        }
        free(properties);
        
        c = [c superclass];
    }
    return types;
}

- (NSDictionary *)convertDictionary
{
    /*
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSArray *propertyList = [self getPropertyList];
    for (NSString *key in propertyList)
    {
        NSString *value = [self valueForKey:key];
        if (value)
        {
            [dict setObject:value forKey:key];
        }
    }
    return dict;
     */
    return [[self class] getObjectData:self];
}

+ (id)getObjectInternal:(id)obj
{
    if([obj isKindOfClass:[NSString class]]
       || [obj isKindOfClass:[NSNumber class]]
       || [obj isKindOfClass:[NSNull class]])
    {
        return obj;
    }
    
    if([obj isKindOfClass:[NSArray class]])
    {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++)
        {
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    
    if([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys)
        {
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self getObjectData:obj];
}

+ (NSDictionary*)getObjectData:(id)obj
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);//获得属性列表
    for(int i = 0;i < propsCount; i++)
    {
        objc_property_t prop = props[i];
        
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];//获得属性的名称
        id value = [obj valueForKey:propName];//kvc读值
        if(value == nil)
        {
            value = [NSNull null];
        }
        else
        {
            value = [self getObjectInternal:value];//自定义处理数组，字典，其他类
        }
        [dic setObject:value forKey:propName];
    }
    return dic;
}
- (void)dictionaryForObject:(NSDictionary*) dict{
    for (NSString *key in [dict allKeys]) {
        id value = [dict objectForKey:key];
        
        if (value==[NSNull null]) {
            continue;
        }
        if ([value isKindOfClass:[NSDictionary class]]) {
            id subObj = [self valueForKey:key];
            if (subObj)
                [subObj dictionaryForObject:value];
        }
        else{
            [self setValue:value forKeyPath:key];
        }
    }
}

- (void)fromDictionary:(NSDictionary*) dict
{
    NSArray *propertyList = [self getPropertyList];
    for (NSString *key in propertyList)
    {
        id value = [dict objectForKey:key];
        if (value == [NSNull null])
        {
            continue;
        }
        if(value == nil)
        {
            continue;
        }
        if([value isKindOfClass:[NSString class]] && [value isEqualToString:@"null"])
        {
            value = @"";
        }
        
        if ([value isKindOfClass:[NSDictionary class]])
        {
            id subObj = [self valueForKey:key];
            if (subObj)
            {
                [subObj dictionaryForObject:value];
            }
        }
        else
        {
            [self setValue:value forKeyPath:key];
        }
    }
    NSArray *typeArray = [self getPropertyTypeList];
    NSArray *nameArray = [self getPropertyList];
    for(NSUInteger index = 0; index < nameArray.count; index++)
    {
        if(index >= typeArray.count)
        {
            break;
        }
        
        NSString *type = [typeArray objectAtIndex:index];
        if([type rangeOfString:@"NSString"].location != NSNotFound)
        {
            NSString *name = [nameArray objectAtIndex:index];
            if([self valueForKeyPath:name] == nil || [self valueForKeyPath:name] == [NSNull null])
            {
                [self setValue:@"" forKeyPath:name];
            }
        }
    }
}

@end
