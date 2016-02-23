//
//  FFLog.h
//  StoryRadio
//
//  Created by wei feng on 15/9/15.
//  Copyright (c) 2015年 wei feng. All rights reserved.
//

#ifndef StoryRadio_FFLog_h
#define StoryRadio_FFLog_h

#define kEnableLog  1

#ifdef kEnableLog
    #define FFLog(format, ...) NSLog(@"%s(%d): " format, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
    #define FFLog(format, ...)
#endif

#endif
