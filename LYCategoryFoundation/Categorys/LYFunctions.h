//
//  LYFunctions.h
//  LYCategoryFoundation
//
//  Created by wei feng on 15/11/21.
//  Copyright © 2015年 wei feng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

void YUAlert(NSString *title, NSString *content);
void FFAlert(NSString *title, NSString *content, id delegate, NSInteger tag);

void YULog(id object);
void YULogBool(BOOL boolValue);

// 文件夹操作
long long int YUFolderSize(NSString *path);
void YURemoveFile(NSString *path);
void YUCreateDirectory(NSString *path);
BOOL YUFileExist(NSString *path);

BOOL ISLANDSCAPE();
BOOL iPad();

UIInterfaceOrientation CURRENT_ORIENTATION();

BOOL IS_UIView(id object);
BOOL IS_UIViewController(id object);
BOOL IS_UIImageView(id object);
BOOL IS_NSArray(id object);
BOOL IS_NSDictionary(id object);
BOOL IS_NSString(id object);
BOOL IS_NSNumber(id object);
BOOL IS_CAAnimation(id object);
BOOL IS_CABasicAnimation(id object);
BOOL IS_UIButton(id object);
BOOL IS_UIImage(id object);
BOOL IS_MPMoviePlayerController(id object);
BOOL IS_CAAnimationGroup(id object);
BOOL IS_NSData(id object);

NSString *YUDocumentPath();
NSString *YUCachePath();
NSString *YUTempPath();
NSString *UUIDString();

UIImage *YUImageWithName(NSString *imageName);
UIImage *YUImageWithPath(NSString *imageFilePath);

NSURL *URL(NSString *URLString);
NSURL *RetinaURL(NSString *URLString);

void YUHideStatusBar(BOOL hide);

void ClearColorView(UIView *view);
void YellowColorView(UIView *view);
void WhiteColorView(UIView *view);
void BrownColorView(UIView *view);
void BlackColorView(UIView *view);
void RedColorView(UIView *view);
void GrayColorView(UIView *view);
void LightColorView(UIView *view);
void DarkGrayColorView(UIView *view);
void DarkTextColorView(UIView *view);
void ScrollViewTexturedBackgroundColorView(UIView *view);

UIColor *RGBA(int red, int green, int blue, CGFloat alpha);

void ScaleAspectFitView(UIView *view);
void ScaleAspectFillView(UIView *view);
void ScaleToFillView(UIView *view);

void ClipsToBounds(UIView *view);
