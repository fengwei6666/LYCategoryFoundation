//
//  NSDate+Expansion.m
//  SmartDevice
//
//  Created by wei feng on 15/6/30.
//  Copyright (c) 2015年 wei feng. All rights reserved.
//

#import "NSDate+Expansion.h"

@implementation NSDate (Expansion)

- (NSString *)humaneDateString;
{
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    comps = [calendar components:unitFlags fromDate:self toDate:now options:0];
    
    NSInteger months = [comps month];
    NSInteger days = [comps day];
    NSInteger hours = [comps hour];
    NSInteger mins = [comps minute];
    //NSInteger secs = [comps second];
    
    NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
    dateForm.dateFormat = @"MM-dd HH:mm:ss";
    
    if (months == 0)
    {
        if (days == 0)
        {
            if (hours == 0)
            {
                if (mins == 0)
                {
                    return @"刚刚";
                }
                else
                {
                    return [NSString stringWithFormat:@"%ld分钟前",(long)mins];
                }
            }
            else
            {
                return [NSString stringWithFormat:@"%ld小时前",(long)hours];
            }
        }
        else
        {
            return [NSString stringWithFormat:@"%@",[dateForm stringFromDate:now]];
            
        }
    }
    else
    {
        return [NSString stringWithFormat:@"%@",[dateForm stringFromDate:now]];
    }
}

- (NSString *)dateStringWithFormatter:(NSString *)formatter;
{
    NSDateFormatter *_fomatter = [[NSDateFormatter alloc] init];
    [_fomatter setDateFormat:formatter];
    
    return [_fomatter stringFromDate:self];
}

- (NSDate *)shortDate;
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger desiredComponents = (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);
    
    NSDateComponents *components = [calendar components:desiredComponents fromDate:self];
    
    return [calendar dateFromComponents:components];
}

- (NSDate *)nextDay;
{
    return [self dateByAddingTimeInterval:86400];
}

- (NSDate *)preDate;
{
    return [self dateByAddingTimeInterval:-86400];
}

- (BOOL)isBetween:(NSDate *)beginDate andDate:(NSDate *)endDate;
{
    if ([self compare:beginDate] == NSOrderedAscending)
        return NO;
    
    if ([self compare:endDate] == NSOrderedDescending)
        return NO;
    
    return YES;
}

+ (NSDate *)dateFromString:(NSString *)dateString;
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
    
}

- (NSString *)dateString;
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息 +0000。
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    
    NSString *destDateString = [dateFormatter stringFromDate:self];
        
    return destDateString;
    
}

- (NSInteger)hour
{
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    return [calendar component:NSCalendarUnitHour fromDate:self];
}

- (NSInteger)minute
{
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    return [calendar component:NSCalendarUnitMinute fromDate:self];
}

- (NSInteger)weekDay
{
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    return [calendar component:NSCalendarUnitWeekday fromDate:self];
}

@end
