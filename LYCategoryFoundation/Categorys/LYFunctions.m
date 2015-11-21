//
//  LYFunctions.m
//  LYCategoryFoundation
//
//  Created by wei feng on 15/11/21.
//  Copyright © 2015年 wei feng. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>
#import "LYFunctions.h"
#import "LYHelper.h"

void YUAlert(NSString *title, NSString *content)
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title.length == 0 ? @"提示" : title
                                                    message:([content isKindOfClass:[NSString class]] && content.length) ? content : @""
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

void FFAlert(NSString *title, NSString *content, id delegate, NSInteger tag)
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title.length == 0 ? @"提示" : title
                                                    message:([content isKindOfClass:[NSString class]] && content.length) ? content : @""
                                                   delegate:nil
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    alert.delegate = delegate;
    alert.tag = tag;
    [alert show];
}

void YULog(id object)
{
    NSLog(@"\n\n************************************************\n\n类: %@\n实例: %@\n\n************************************************\n\n", [object class], object);
}

void YULogBool(BOOL boolValue)
{
    NSLog(@"%@", boolValue ? @"布尔值：成功" : @"布尔值：失败");
}

#pragma mark

long long int YUFolderSize(NSString *path)
{
    unsigned long long int bytes = 0;
    
    NSArray *filesArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:path error:nil];
    NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
    NSString *fileName;
    
    while (fileName = [filesEnumerator nextObject]) {
        NSDictionary *fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:[path stringByAppendingPathComponent:fileName] error:nil];
        bytes += [fileDictionary fileSize];
    }
    
    return bytes;
}

void YURemoveFile(NSString *path)
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:path error:nil];
}

void YUCreateDirectory(NSString *path)
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
}

BOOL YUFileExist(NSString *path)
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:path];
}

BOOL ISLANDSCAPE()
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    return UIInterfaceOrientationIsLandscape(orientation);
}

BOOL iPad()
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        return YES;
    }
    return NO;
}

UIInterfaceOrientation CURRENT_ORIENTATION()
{
    return [[UIApplication sharedApplication] statusBarOrientation];
}

BOOL IS_UIView(id object)
{
    return [object isKindOfClass:[UIView class]];
}

BOOL IS_UIViewController(id object)
{
    return [object isKindOfClass:[UIViewController class]];
}

BOOL IS_UIImageView(id object)
{
    return [object isKindOfClass:[UIImageView class]];
}

BOOL IS_NSArray(id object)
{
    return [object isKindOfClass:[NSArray class]];
}

BOOL IS_NSDictionary(id object)
{
    return [object isKindOfClass:[NSDictionary class]];
}

BOOL IS_NSString(id object)
{
    return [object isKindOfClass:[NSString class]];
}

BOOL IS_NSNumber(id object)
{
    return [object isKindOfClass:[NSNumber class]];
}

BOOL IS_CAAnimation(id object)
{
    return [object isKindOfClass:[CAAnimation class]];
}

BOOL IS_CABasicAnimation(id object)
{
    return [object isKindOfClass:[CABasicAnimation class]];
}

BOOL IS_UIButton(id object)
{
    return [object isKindOfClass:[UIButton class]];
}

BOOL IS_UIImage(id object)
{
    return [object isKindOfClass:[UIImage class]];
}

BOOL IS_MPMoviePlayerController(id object)
{
    return [object isKindOfClass:[MPMoviePlayerController class]];
}

BOOL IS_CAAnimationGroup(id object)
{
    return [object isKindOfClass:[CAAnimationGroup class]];
}

BOOL IS_NSData(id object)
{
    return [object isKindOfClass:[NSData class]];
}

#pragma mark - Paths

NSString *YUDocumentPath()
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

NSString *YUCachePath()
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

NSString *YUTempPath()
{
    return NSTemporaryDirectory();
}

NSString *UUIDString()
{
    NSString *uuidString = nil;
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    if (uuid) {
        uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(NULL, uuid));
        CFRelease(uuid);
    }
    return uuidString;
}

UIImage *YUImageWithName(NSString *imageName)
{
    return [UIImage imageNamed:imageName];
}

UIImage *YUImageWithPath(NSString *imageFilePath)
{
    NSData *imageData = [[NSData alloc] initWithContentsOfFile:imageFilePath];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    return image;
}

NSURL *URL(NSString *URLString)
{
    return [NSURL URLWithString:URLString];
}

NSURL *RetinaURL(NSString *URLString)
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@&retina=%d", URLString, [LYHelper isRetina]]];
}

void YUHideStatusBar(BOOL hide)
{
    [[UIApplication sharedApplication] setStatusBarHidden:hide withAnimation:UIStatusBarAnimationSlide];
}

void YellowColorView(UIView *view)
{
    [view setBackgroundColor:[UIColor yellowColor]];
}

void WhiteColorView(UIView *view)
{
    [view setBackgroundColor:[UIColor whiteColor]];
}

void BrownColorView(UIView *view)
{
    [view setBackgroundColor:[UIColor brownColor]];
}

void ClearColorView(UIView *view)
{
    [view setBackgroundColor:[UIColor clearColor]];
}

void BlackColorView(UIView *view)
{
    [view setBackgroundColor:[UIColor blackColor]];
}

void RedColorView(UIView *view)
{
    [view setBackgroundColor:[UIColor redColor]];
}

void GrayColorView(UIView *view)
{
    [view setBackgroundColor:[UIColor grayColor]];
}

void LightColorView(UIView *view)
{
    [view setBackgroundColor:[UIColor lightGrayColor]];
}

void DarkGrayColorView(UIView *view)
{
    [view setBackgroundColor:[UIColor darkGrayColor]];
}

void DarkTextColorView(UIView *view)
{
    [view setBackgroundColor:[UIColor darkTextColor]];
}

void ScrollViewTexturedBackgroundColorView(UIView *view)
{
    //    [view setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
}

UIColor *RGBA(int red, int green, int blue, CGFloat alpha)
{
    return [UIColor colorWithRed:(CGFloat)red/255.0 green:(CGFloat)green/255.0 blue:(CGFloat)blue/255.0 alpha:alpha];
}

void ScaleAspectFitView(UIView *view)
{
    view.contentMode = UIViewContentModeScaleAspectFit;
}

void ScaleAspectFillView(UIView *view)
{
    view.contentMode = UIViewContentModeScaleAspectFill;
}

void ScaleToFillView(UIView *view)
{
    view.contentMode = UIViewContentModeScaleToFill;
}

void ClipsToBounds(UIView *view)
{
    view.clipsToBounds = YES;
}
