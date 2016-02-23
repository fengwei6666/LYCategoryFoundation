//
//  NSObject+Expansion.m
//  SmartDevice
//
//  Created by wei feng on 15/6/30.
//  Copyright (c) 2015年 wei feng. All rights reserved.
//

#import "NSObject+Expansion.h"

@implementation NSObject (Expansion)

- (id)ooAssociatedObjectForKey:(void *)key;
{
    return objc_getAssociatedObject(self, key);
}

- (void)setOOAssociatedObject:(id)object forKey:(void *)key policy:(objc_AssociationPolicy)policy;
{
    objc_setAssociatedObject(self, key, object, policy);
}

- (void)removeOOAssociatedObjectForKey:(void *)key policy:(objc_AssociationPolicy)policy;
{
    [self setOOAssociatedObject:nil forKey:key policy:policy];
}

#pragma mark

- (void) listen:(NSString *)name handler:(SEL)selector
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:selector name:name object:nil];
}

- (void) send:(NSString *)name userInfo:(id)userInfo
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:self userInfo:userInfo];
}

- (void) send:(NSString *)name userInfo:(id)userInfo object:(id)object;
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:object userInfo:userInfo];
}
- (void) removeListener
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)isArray
{
    return [self isKindOfClass:[NSArray class]];
}

- (BOOL)isDictionary
{
    return [self isKindOfClass:[NSDictionary class]];
}

@end
