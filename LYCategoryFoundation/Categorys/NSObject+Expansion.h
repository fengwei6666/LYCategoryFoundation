//
//  NSObject+Expansion.h
//  SmartDevice
//
//  Created by wei feng on 15/6/30.
//  Copyright (c) 2015年 wei feng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (Expansion)

/**
 *  获取自定义属性
 *
 *  @param key 键
 *
 *  @return 返回self
 */
- (id)ooAssociatedObjectForKey:(void *)key;

/**
 *  添加自定义属性
 *
 *  @param object 值
 *  @param key    键
 *  @param policy 引用方式
 */
- (void)setOOAssociatedObject:(id)object forKey:(void *)key policy:(objc_AssociationPolicy)policy;

/**
 *  删除自定义属性
 *
 *  @param key    键
 *  @param policy 引用方式
 */
- (void)removeOOAssociatedObjectForKey:(void *)key policy:(objc_AssociationPolicy)policy;

/**
 *  监听通知
 *
 *  @param name     通知名称
 *  @param selector 回调函数
 */
- (void)listen:(NSString *)name handler:(SEL)selector;

/**
 *  发送通知
 *
 *  @param name     通知名称
 *  @param userInfo 用户自定义数据
 */
- (void)send:(NSString *)name userInfo:(id)userInfo;

/**
 *  发送通知
 *
 *  @param name     通知名称
 *  @param userInfo 用户自定义数据
 *  @param object   object
 */
- (void)send:(NSString *)name userInfo:(id)userInfo object:(id)object;

/**
 *  取消监听通知
 */
- (void)removeListener;

- (BOOL)isArray;
- (BOOL)isDictionary;

@end
