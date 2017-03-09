//
//  AppDelegate.m
//  getDataCounters
//
//  Created by liujianan on 14/10/28.
//  Copyright (c) 2014年 liujianan. All rights reserved.
//

#import "AppDelegate.h"
#import "MoccaDeviceInfo.h"
#import "AlertCustomView.h"
#import "RainBase64.h"
#define Normal          1           //是否是正式模式

#define USER_ICON_IMAGEURL_KEY @"iconurl"
#define USER_NAME_KEY @"username"

#define IPHONE_FRAME CGRectMake(0.0f,0,320.0f,413.0f)


#if Normal

#define BeanIP                          @"http://weixinmall.adwo.com/weixinmall/"
#define BeanIP2                         @"web/common/checkin"
#define BeanIP3                         @"v2/device/reg" //设备checkin

#else


#define BeanIP                          @"http://211.99.11.51:8888/WeixinMall/"

#define BeanIP2                         @"web/common/checkin"

#define BeanIP3                         @"v2/device/checkin" //设备checkin

#endif


@interface AppDelegate ()

@end


@implementation AppDelegate

@synthesize ansysForBinding;
@synthesize ansysForBinded;
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@  %@",url.absoluteString,url.host] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
//    [alert release];
    
    NSString *command = [url absoluteString];
    
    NSRange range = [command rangeOfString:@"authid="];
    if(range.location == NSNotFound)
        return NO;

    NSUInteger startIndex = range.location + range.length;
    
    range = [command rangeOfString:@"&"];
    if(range.location == NSNotFound)
        range = [command rangeOfString:@"="];
    NSUInteger endIndex = range.location == NSNotFound? [command length] : range.location;
    
    NSString *commandName = [command substringWithRange:NSMakeRange(startIndex, endIndex - startIndex)];
    
    
    
    NSString *commandExt = [command substringFromIndex:endIndex+1];
    
    
    
    NSRange rangeExt = [commandExt rangeOfString:@"ext="];
    
    
    if(rangeExt.location == NSNotFound)
    {
        return NO;
    }
    
        
    
    NSInteger startIndexExt = rangeExt.location + rangeExt.length;
    
    
    
    rangeExt = [commandExt rangeOfString:@"&"];
//   rangeExt =  [commandExt rangeOfString:@"&" options:NSCaseInsensitiveSearch range:NSMakeRange(endIndex - startIndex, endIndex)];
    
    
    if(rangeExt.location == NSNotFound)
        rangeExt = [commandExt rangeOfString:@"="];
    
    
    NSUInteger endIndexExt = rangeExt.location == NSNotFound? [commandExt length] : rangeExt.location;
    
    NSString *commandNameExt = [commandExt substringWithRange:NSMakeRange(startIndexExt, endIndexExt - startIndexExt)];
    
    
    
//    UIAlertView *alertId = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@ %@",commandName,commandNameExt] delegate:self cancelButtonTitle:@"OK1" otherButtonTitles:nil, nil];
//    [alertId show];
//    [alertId release];
    // 在 host 等于 item.taobao.com 时，说明一个宝贝详情的 url，
    
    // 那么就使用本地的 TBItemDetailViewController 来显示
    
//    if ([[url host] isEqualToString:@"com.looperstudio.51books"]) {
//        
//        // 这里只是简单地假设 url 形式为 taobao://item.taobao.com/item.htm?id=12345678
//        
//        // 先获取要查看的宝贝详情的 itemId
//        
//        NSString *itemId = [[url query] substringFromIndex:[[url query] rangeOfString:@"id="].location+3];
//        
//        // 使用本地 ViewController 来显示淘宝商品详情
//
//    }
    
    if ([commandNameExt isEqualToString:@"1"]) {
        AnsysClassMethod *ansys1=[[AnsysClassMethod alloc] init];
        self.ansysForBinding=ansys1;
        [ansys1 release];
        
        const struct MoccaDeviceInfo *device = MoccaGetDeviceInfo();
        
        NSMutableDictionary *deviceObj = [NSMutableDictionary dictionaryWithCapacity:16];
        
        
        [deviceObj setObject:commandName forKey:@"userid"];
        [deviceObj setObject:device->idfa forKey:@"idfa"];
        [deviceObj setObject:device->deviceModel forKey:@"detailtype"];
        [deviceObj setObject:device->osVersion forKey:@"os_version"];
        [deviceObj setObject:[NSNumber numberWithBool:device->isJailbreak] forKey:@"isjailbreak"];
        [deviceObj setObject:[NSString stringWithFormat:@"%d",device->process] forKey:@"jbcheck"];
        
        
        NSString *stringMd5=[[NSString stringWithFormat:@"%@%@%@",device->idfa,@"-adwx-",commandName] md5HexDigest];
        [deviceObj setObject:stringMd5 forKey:@"sign"];
        
        NSLog(@"stringMd5=%@",[NSString stringWithFormat:@"%@%@%@",device->idfa,@"-adwx-",commandName]);
        
        self.ansysForBinding->target=self;
        self.ansysForBinding->receiveDataSel=@selector(receiveDataForBinding:);
        
        [self.ansysForBinding postUrlStr:[NSString stringWithFormat:@"%@%@",BeanIP,BeanIP2] andJsonDataJSON:[AnsysClassMethod directoryToJSONData:deviceObj]];
    }else
    {
        
        AnsysClassMethod *ansys1=[[AnsysClassMethod alloc] init];
        self.ansysForBinded=ansys1;
        [ansys1 release];
        
        const struct MoccaDeviceInfo *device = MoccaGetDeviceInfo();
        
        NSMutableDictionary *deviceObj = [NSMutableDictionary dictionaryWithCapacity:16];
        [deviceObj setObject:commandName forKey:@"userid"];
        [deviceObj setObject:device->idfa forKey:@"idfa"];
        [deviceObj setObject:device->deviceModel forKey:@"detailtype"];
        [deviceObj setObject:device->osVersion forKey:@"os_version"];
        [deviceObj setObject:[NSNumber numberWithBool:device->isJailbreak] forKey:@"isjailbreak"];

        
        NSString *stringMd5=[[NSString stringWithFormat:@"%@%@%@",device->idfa,@"-adwx-",commandName] md5HexDigest];
        [deviceObj setObject:stringMd5 forKey:@"sign"];
        
        NSLog(@"stringMd5=%@",[NSString stringWithFormat:@"%@%@%@",device->idfa,@"-adwx-",commandName]);
        

        
        self.ansysForBinded->target=self;
        self.ansysForBinded->receiveDataSel=@selector(receiveDataForBinding:);
        
        NSLog(@"diveceJsonObject=%@",deviceObj);
    
        
        [self.ansysForBinded postUrlStr:[NSString stringWithFormat:@"%@%@",BeanIP,BeanIP3] andJsonDataJSON:[AnsysClassMethod directoryToJSONData:deviceObj]];
        
    
        
    }
   

    
    return YES;
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"");
//    [AdMasterConvMobi initWithMasterId:@"c715"];
//    [AdMasterConvMobi enableLog:YES];
    
    // Override point for customization after application launch.
    return YES;
}

-(void)receiveDataForBinding:(NSDictionary *)dict
{
    
    NSLog(@"dict=%@",dict);
    
    
    
//    AlertCustomView *alertView=[[AlertCustomView alloc] initWithFrame:IPHONE_FRAME];
//    alertView->target=self;
//    [alertView alertShowWith:[dict objectForKey:@"message"]];
//    [self.view addSubview:alertView];
//    [alertView release];
//    
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
    
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
