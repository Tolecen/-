//
//  NSSystemFireGreatWall.m
//  ZKcmoneZKcmtwo
//
//  Created by zenny_chen on 13-5-15.
//  Copyright (c) 2013年 zenny_chen. All rights reserved.
//

#import "NSSystemFireGreatWall.h"
#import <UIKit/UIKit.h>

@interface NSSystemFireGreatWall()<UIAlertViewDelegate>

@end


@implementation NSSystemFireGreatWall

static NSSystemFireGreatWall *theFireGreatWall = nil;

+ (void)verifyCompletionOfObject
{
    @synchronized([NSSystemFireGreatWall class])
    {
        if(theFireGreatWall == nil)
            theFireGreatWall = [[NSSystemFireGreatWall alloc] init];
    }
    
    [theFireGreatWall showInfo];
    
}

- (void)showInfo
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请注意：" message:@"本应用即将关闭，若想继续使用请关闭所谓的广告拦截插件或安全卫士等流氓应用" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    alert.delegate = self;
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    exit(-1);
}

@end

