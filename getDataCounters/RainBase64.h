//
//  AdwoBase64.h
//  Base64Demo
//
//  Created by adwo0710 on 14-3-6.
//  Copyright (c) 2014年 adwo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RainBase64 : NSObject
//解密
+(NSData *)dataWithBase64DecodedString:(NSString *)string;
//加密
+ (NSString *)adwoBase64Encode:(NSData *)data;

@end
