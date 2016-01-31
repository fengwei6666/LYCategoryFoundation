//
//  LYHelper.m
//  LYCategoryFoundation
//
//  Created by wei feng on 15/11/21.
//  Copyright © 2015年 wei feng. All rights reserved.
//

#import "LYHelper.h"
#import <sys/types.h>
#import <sys/sysctl.h>
#import <UIKit/UIKit.h>

@implementation LYHelper

+ (BOOL)isRetina;
{
    return ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0));
}

+ (BOOL)isiCloudAvailable;
{
    NSURL *ubiq = [[NSFileManager defaultManager]
                   URLForUbiquityContainerIdentifier:nil];
    if (ubiq) {
        NSLog(@"iCloud access at %@", ubiq);
        return YES;
    } else {
        NSLog(@"No iCloud access");
        return NO;
    }
}

+ (NSString *)platform;
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

+ (NSString*)version;
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+ (NSString*)systemVersion;
{
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString*)appName;
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

+ (NSString*)OpenUDID;
{
    return nil;
    //    return [OpenUDID value];
}

+ (void)setUserDefaultWithValue:(id)value forKey:(NSString *)key;
{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)getUserDefaultForKey:(NSString *)key;
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (NSMutableArray *)lyricFromContentOfFile:(NSString *)path
{
    NSError *error = nil;
    NSString *contentStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (!error && [contentStr length] > 0)
    {
        return [LYHelper lyricFromContent:contentStr];
    }
    return nil;
}

+ (NSMutableArray *)lyricFromContent:(NSString *)lyricContent
{
    if ([lyricContent length] > 0)
    {
        NSArray *array = [lyricContent componentsSeparatedByString:@"\r"];
        if (!array || [array count] < 2)
        {
            array = [lyricContent componentsSeparatedByString:@"\n"];
        }
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:[array count]];
        for (int i = 0; i < [array count]; i++)
        {
            NSString *linStr = [array objectAtIndex:i];
            NSArray *lineArray = [linStr componentsSeparatedByString:@"]"];
            if ([lineArray[0] length] > 8)
            {
                NSString *str1 = [linStr substringWithRange:NSMakeRange(3, 1)];
                NSString *str2 = [linStr substringWithRange:NSMakeRange(6, 1)];
                if ([str1 isEqualToString:@":"] && [str2 isEqualToString:@"."])
                {
                    NSString *lrcStr = [lineArray objectAtIndex:1];
                    NSString *timeStr = [[lineArray objectAtIndex:0] substringWithRange:NSMakeRange(1, 5)];//分割区间求歌词时间
                    //把时间 和 歌词 加入词典
                    [result addObject:@{kLyricTimeKey : timeStr,
                                        kLyricStringKey : lrcStr}];
                }
            }
        }
        return result;
    }
    return nil;
}

@end
