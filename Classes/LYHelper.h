//
//  LYHelper.h
//  LYCategoryFoundation
//
//  Created by wei feng on 15/11/21.
//  Copyright © 2015年 wei feng. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kLyricTimeKey   @"lyricTimeKey"
#define kLyricStringKey @"lyricStringkey"

@interface LYHelper : NSObject

+ (BOOL)isRetina;
+ (BOOL)isiCloudAvailable;
+ (NSString *)platform;
+ (NSString*)version;
+ (NSString*)systemVersion;
+ (NSString*)appName;
+ (NSString*)OpenUDID;

+ (void)setUserDefaultWithValue:(id)value forKey:(NSString *)key;
+ (id)getUserDefaultForKey:(NSString *)key;

+ (NSMutableArray *)lyricFromContentOfFile:(NSString *)path;
+ (NSMutableArray *)lyricFromContent:(NSString *)lyricContent;

@end
