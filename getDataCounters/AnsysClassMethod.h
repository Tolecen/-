//
//  AnsysClassMethod.h
//  NPLApp
//
//  Created by xiefei on 13-7-12.
//  Copyright (c) 2013年 xiefei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVProgressHUD.h"
BOOL requesting;

#import <CommonCrypto/CommonDigest.h>

@interface NSString (md5)
-(NSString *) md5HexDigest;
@end
@implementation NSString (md5)

-(NSString *) md5HexDigest
{
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

@end



@interface AnsysClassMethod : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate,UIAlertViewDelegate>
{
    NSURLConnection * connect;
    NSMutableData * dataSource;
    NSDictionary * dict;
    NSURL * url;
    NSString *stringurl;
    BOOL finished;
    NSThread *threadPost;
    NSMutableURLRequest* request;
    UIActivityIndicatorView *indicator;
    @public
    SVProgressHUD *svprogress;
    id target;
    SEL receiveDataSel;
    int requestType;
    
}
@property (retain,nonatomic) NSDictionary *dict;
@property(retain,nonatomic) NSURLConnection * connect;
@property(retain,nonatomic) NSMutableData * dataSource;

-(void)postUrlStr:(NSString* )str andJsonData:(NSString *)requestString;
-(void)postUrlStr:(NSString* )str andJsonDataJSON:(NSData *)requestString;
//json 数据转换
+(NSData *)directoryToJSONData:(NSDictionary *)dict;

+(NSDictionary *)JSONDataTodirectory:(NSData *)dict;
@end
