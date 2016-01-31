//
//  NSDate+Expansion.h
//  SmartDevice
//
//  Created by wei feng on 15/6/30.
//  Copyright (c) 2015年 wei feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Expansion)

- (NSString *)humaneDateString;
- (NSString *)dateStringWithFormatter:(NSString *)formatter;
- (NSDate *)shortDate;
- (NSDate *)nextDay;
- (NSDate *)preDate;
- (BOOL)isBetween:(NSDate *)beginDate andDate:(NSDate *)endDate;

+ (NSDate *)dateFromString:(NSString *)dateString;
- (NSString *)dateString;
- (NSInteger)hour;
- (NSInteger)minute;
- (NSInteger)weekDay;

@end
