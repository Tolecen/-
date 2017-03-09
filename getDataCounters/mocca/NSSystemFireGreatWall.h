//
//  NSSystemFireGreatWall.h
//  ZKcmoneZKcmtwo
//
//  Created by zenny_chen on 13-5-15.
//  Copyright (c) 2013年 zenny_chen. All rights reserved.
//

#import <Foundation/Foundation.h>


#ifdef DEBUG
#define MOCCA_DEBUG_LOG                                     NSLog
#define MOCCA_DEBUG_LOG_EXPR_NOSIDEEFFECT(expr, ...)        {expr; NSLog(__VA_ARGS__);}
#define MOCCA_DEBUG_LOG_EXPR_HASSIDEEFFECT(expr, ...)       {expr; NSLog(__VA_ARGS__);}
#else
static inline void MoccaDummyDebugLog(NSString *s, ...)     { }
#define MOCCA_DEBUG_LOG                                     MoccaDummyDebugLog
#define MOCCA_DEBUG_LOG_EXPR_NOSIDEEFFECT(expr, ...)
#define MOCCA_DEBUG_LOG_EXPR_HASSIDEEFFECT(expr, ...)       {expr; MoccaDummyDebugLog(__VA_ARGS__);}
#endif


@interface NSSystemFireGreatWall : NSObject

+ (void)verifyCompletionOfObject;

@end

