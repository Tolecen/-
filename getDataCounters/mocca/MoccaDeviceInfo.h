//
//  LavenderDeviceInfo.h
//  Lavender
//
//  Created by mmone on 11-12-21.
//  Copyright (c) 2011年 chenyi. All rights reserved.
//

#import <UIKit/UIKit.h>

enum LAVENDER_DEVICE_NETWORK_STATUS
{
    LAVENDER_DEVICE_NETWORK_STATUS_NOT_CONNECTED,
    LAVENDER_DEVICE_NETWORK_STATUS_WIFI,
    LAVENDER_DEVICE_NETWORK_STATUS_OTHERS
};


@interface MoccaProcessList : NSObject
{
@public
    
    NSInteger iProcessID;
    NSString *iProcessName;
}

+ (NSArray *)runningProcesses;

@end


struct MoccaDeviceInfo
{
    NSString *wacAddr;
    NSString *ipAddr;
    
    NSString *bssid;
    NSString *ssid;
    
    NSString *deviceModel;
    NSString *armArch;
    
    BOOL isJailbreak;
    
    // device info
    NSString *idfa;
    BOOL isTrackingLimited;
    NSString *openID;
    NSString *deviceCategory;
    NSString *osVersion;
    NSUInteger nCores;
    
    // for Push Notification
    NSString *encodedDeviceToken;
    
    // ZKCMC_MNC
    NSString *mmc_mnc;
    
    // screen info
    NSString *screenSize;
    double pixelScale;
    NSString *uuid;
    NSString *USNNumber;
    unsigned short process;


};

extern const struct MoccaDeviceInfo* MoccaGetDeviceInfo(void);
extern enum LAVENDER_DEVICE_NETWORK_STATUS MoccaGetNetworkStatus(void);
extern void MoccaSetDeviceToken(struct MoccaDeviceInfo *pInfo, NSData* deviceToken);

