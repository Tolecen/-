//
//  AnsysClassMethod.m
//  NPLApp
//
//  Created by xiefei on 13-7-12.
//  Copyright (c) 2013年 xiefei. All rights reserved.
//

#import "AnsysClassMethod.h"
#import <objc/runtime.h>
#import "MoccaDeviceInfo.h"
#import "MoccaGTMBase64.h"
//#import "AppShareClass.h"
#define TIME_OUT_DURATION 120
@implementation AnsysClassMethod
@synthesize connect;
@synthesize dict=dict;
@synthesize dataSource;


+(NSData *)directoryToJSONData:(NSDictionary *)dict
{
    
    if(class_getClassMethod([NSJSONSerialization class], @selector(dataWithJSONObject:options:error:))== NULL)
        return nil;
    
    NSError *error=nil;
    
    return  [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    
}

+(NSDictionary *)JSONDataTodirectory:(NSData *)data
{
    
    
    if (class_getClassMethod([NSJSONSerialization class], @selector(JSONObjectWithData:options:error:))==NULL) {
        
        return  nil;
        
    }
    NSError *error=nil;
    
    
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    
}
-(void)postFormRequest:(NSString *)requestString
{
    
//    extern BOOL requesting;
//    requesting=YES;
//    url=[NSURL URLWithString:str];
//    stringurl=[NSString stringWithString:str];
    
    
    
   request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:TIME_OUT_DURATION];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%zd",strlen([requestString UTF8String])] forHTTPHeaderField:@"Content-Length"];
    NSString *string=requestString;
    
    
    
    //    [[NSRunLoop currentRunLoop] run];
    request.HTTPBody=[NSData dataWithBytes:[string UTF8String] length:[string length]];
    self.connect= [NSURLConnection connectionWithRequest:request delegate:self ];
    [[NSRunLoop currentRunLoop] run];
    
    if (self.connect) {
        
        NSMutableData *data1=[[NSMutableData alloc]init];
        self.dataSource=data1;
        [data1 release];
        
    }
    
    
    //    NSString *str = [[NSString alloc] initWithFormat:@"bytes=%u-", request];
    //    [request setValue:str forHTTPHeaderField:@"Range"];
    //    [str release];
    
    
    NSDictionary *dictrequest = [request allHTTPHeaderFields];
    
    NSArray *array = [dictrequest allKeys];
    for(NSObject *obj in array)
    {
        
        NSLog(@"request Url: %@",url);
        NSLog(@"request Body: %@",requestString);
        NSLog(@"request Key: %@", obj);
        NSLog(@"request Object: %@", [dictrequest objectForKey:obj]);
        
    }
    
    
    NSLog(@"1");
    [request  release];
    
    
    //    finished=false;
    //
    //    while(!finished) {
    //        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    //    }
    
    
    indicator=[[UIActivityIndicatorView alloc] init];
    [indicator startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    

}

-(void)postUrlStr:(NSString* )str andJsonData:(NSString *)requestString
{
    
    
    
    extern BOOL requesting;
    requesting=YES;
    url=[NSURL URLWithString:str];
    stringurl=[NSString stringWithString:str];
    
     //        threadPost =[[NSThread alloc] initWithTarget:self selector:@selector(postFormRequest:) object:requestString];
     //    [threadPost start];
     //
     //
    
    
   request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:TIME_OUT_DURATION];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%zd",strlen([requestString UTF8String])] forHTTPHeaderField:@"Content-Length"];
    
    
    //    [[NSRunLoop currentRunLoop] run];
    request.HTTPBody=[NSData dataWithBytes:[requestString UTF8String] length:[requestString length]];
    self.connect= [NSURLConnection connectionWithRequest:request delegate:self];
    
    
    if (self.connect) {
        NSMutableData *data1=[[NSMutableData alloc]init];

        self.dataSource=data1;
        [data1 release];
        
    }
    
    
    //    NSString *str = [[NSString alloc] initWithFormat:@"bytes=%u-", request];
    //    [request setValue:str forHTTPHeaderField:@"Range"];
    //    [str release];
    
    
    NSDictionary *dictrequest = [request allHTTPHeaderFields];
    NSArray *array = [dictrequest allKeys];
    for(NSObject *obj in array)
    {
        
        NSLog(@"request Url: %@",url);
        NSLog(@"request Body: %@",requestString);
        NSLog(@"request Key: %@", obj);
        NSLog(@"request Object: %@", [dictrequest objectForKey:obj]);
        
    }
    
    
    NSLog(@"1");

    indicator=[[UIActivityIndicatorView alloc] init];
    [indicator setFrame:CGRectMake(100, 100, 60, 60)];
    [indicator setBackgroundColor:[UIColor whiteColor]];
    indicator.alpha=0.5;
    
    if ([UIScreen mainScreen].bounds.size.height>482) {
        
        [indicator setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 568.0f)];
        
    }else
    {
        [indicator setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)];
    }
    
    indicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:indicator];
    [indicator startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    
}
-(void)postConnectionForm:(NSString *)requestString
{

    
}
-(void)postUrlStr:(NSString* )str andJsonDataJSON:(NSData *)requestString
{

    extern BOOL requesting;
    requesting=YES;
    
    NSLog(@"url=%@",str);
    url=[NSURL URLWithString:str];
    stringurl=[NSString stringWithString:str];
    
    
    request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:TIME_OUT_DURATION];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody=requestString;
    self.connect= [NSURLConnection connectionWithRequest:request delegate:self ];

    
    if (self.connect) {
        NSMutableData *data1=[[NSMutableData alloc]init];
        self.dataSource=data1;
        [data1 release];
        
    }
    
    
    NSDictionary *dictrequest = [request allHTTPHeaderFields];
    NSArray *array = [dictrequest allKeys];
    
    for(NSObject *obj in array)
    {
       
        NSLog(@"request Body: %@",[AnsysClassMethod JSONDataTodirectory:requestString]);
        NSLog(@"request Key: %@", obj);
        NSLog(@"request Object: %@", [dictrequest objectForKey:obj]);
    }
    
    
//    NSLog(@"1");
    
    
    indicator=[[UIActivityIndicatorView alloc] init];
    [indicator setBackgroundColor:[UIColor whiteColor]];
    indicator.alpha=0.5;

    if ([UIScreen mainScreen].bounds.size.height>482) {
        
        [indicator setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 568.0f)];
        
    }else
    {
        
        [indicator setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)];
        
    }
    
    
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:indicator];
    indicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
    [indicator startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    
}
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
    NSLog(@"didReceiveAuthenticationChallenge %@ %zd", [[challenge protectionSpace] authenticationMethod], (ssize_t) [challenge previousFailureCount]);
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        
        [[challenge sender]  useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        
        [[challenge sender]  continueWithoutCredentialForAuthenticationChallenge: challenge];
    }
    
}


-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    NSLog(@"2");
    [self.dataSource   appendData:data];

}

-(void)hiddenIndicator
{
    if (indicator) {
        
        [indicator stopAnimating];
        [indicator removeFromSuperview];
        
    }
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSLog(@"3");
    
//    [SVProgressHUD dismiss];
    extern BOOL requesting;
    requesting=NO;
    [self performSelector:@selector(hiddenIndicator) withObject:nil afterDelay:1];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;

    
    NSLog(@"dict receivedata=%@",[AnsysClassMethod JSONDataTodirectory:self.dataSource]);
    
    //是否是全base64加密
    
    if (requestType==100) {
        
        if (self.dataSource) {
            dict=[AnsysClassMethod JSONDataTodirectory:[MoccaGTMBase64 decodeData:self.dataSource]];
        }
        

    }else
    {
        dict=[AnsysClassMethod JSONDataTodirectory:self.dataSource];

    }
    
    if (target!=nil&&receiveDataSel!=nil&&[target respondsToSelector:receiveDataSel]) {
        [target performSelector:receiveDataSel onThread:[NSThread mainThread] withObject:dict waitUntilDone:YES];
     }
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==0) {
        
        [self.connect start];
        
    }
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    
    extern BOOL requesting;
    requesting=NO;
    
    [self performSelector:@selector(hiddenIndicator) withObject:nil afterDelay:1];
    
    if (target!=nil&&receiveDataSel!=nil&&[target respondsToSelector:receiveDataSel]) {
        [target performSelector:receiveDataSel onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
    }

    NSLog(@"%@",error);
    
}

@end
