//
//  AppDelegate.h
//  getDataCounters
//
//  Created by liujianan on 14/10/28.
//  Copyright (c) 2014年 liujianan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnsysClassMethod.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,retain) AnsysClassMethod *ansysForBinding;
@property(nonatomic,retain) AnsysClassMethod *ansysForBinded;


@end

