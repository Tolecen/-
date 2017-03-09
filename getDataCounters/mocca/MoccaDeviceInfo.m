//
//  LavenderDeviceInfo.m
//  Lavender
//
//  Created by mmone on 11-12-21.
//  Copyright (c) 2011年 chenyi. All rights reserved.
//

#import <AdSupport/AdSupport.h>


#import "MoccaDeviceInfo.h"
#import "MoccaReachability.h"
#import "MoccaBase64.h"
#import "MoccaOpenUDID.h"


#import <AdSupport/AdSupport.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <SystemConfiguration/CaptiveNetwork.h>

#import <objc/runtime.h>

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <sys/sockio.h>
#include <net/if.h>
#include <net/ethernet.h>
#include <errno.h>
#include <net/if_dl.h>
#include <ifaddrs.h>
#include <mach/machine.h>

#import <dlfcn.h>
#import <mach/port.h>
#import <mach/kern_return.h>



#define BUFFERSIZE	1024
#define LAVENDER_UUID_DOMAIN        @"LavenderDevice_UUID_Domain"


#pragma mark - sysctl relevant functions

static BOOL GetWiFiIPAddress(char wifiAddr[64])
{
    BOOL success;
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    
    memset(wifiAddr, 0, 64);

    success = getifaddrs(&addrs) == 0;
    if (success) 
    {
        success = NO;
        cursor = addrs;
        while(cursor != NULL) 
        {
            // the second test keeps from picking up the loopback address
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
            {
                // Wi-Fi adapter
                if (strcmp(cursor->ifa_name, "en0") == 0)
                {
                    strcpy(wifiAddr, inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr));
                    success = YES;
                    break;
                }
            }
            cursor = cursor->ifa_next;
        }
        
        freeifaddrs(addrs);
        return success;
    }
    
    return NO;
}

static void GetMachine(char buf[64])
{
    size_t size = 64;
    
    sysctlbyname("hw.machine", buf, &size, NULL, 0);
}

static const char* GetARMArch(void)
{
    size_t size = 4;
    int ret;
    
    sysctlbyname("hw.cpusubtype", &ret, &size, NULL, 0);
    
    switch(ret)
    {
        case CPU_SUBTYPE_ARM_V4T:
            return "ARMv4T";
            
        case CPU_SUBTYPE_ARM_V5TEJ:
            return "ARMv5TEJ";
            
        case CPU_SUBTYPE_ARM_V6:
            return "ARMv6";
            
        case CPU_SUBTYPE_ARM_V7:
            return "ARMv7";
            
        case CPU_SUBTYPE_ARM_V7F:
            return "ARMv7F";
            
        case CPU_SUBTYPE_ARM_V7K:
            return "ARMv7K";
            
        case CPU_SUBTYPE_ARM_V7S:
            return "ARMv7S";
            
        case 4:
            return "X86";
            
        default:
            return "ARM";
    }
}

#pragma mark - MoccaProcessList

@implementation MoccaProcessList

- (void)dealloc
{
    if(iProcessName != nil)
        [iProcessName release];
    
    [super dealloc];
}

+ (NSArray*)runningProcesses
{
    int mib[4] = {CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0};
    size_t miblen = 4;
    
    size_t size;
    sysctl(mib, miblen, NULL, &size, NULL, 0);
    
    struct kinfo_proc * process = NULL;
    struct kinfo_proc * newprocess = NULL;
    int st;
    
    do
    {
        size += size / 10;
        newprocess = realloc(process, size);
        
        if (!newprocess){
            
            if (process){
                free(process);
            }
            
            return nil;
        }
        
        process = newprocess;
        st = sysctl(mib, miblen, process, &size, NULL, 0);
        
    }
    while (st == -1 && errno == ENOMEM);
    
    if (st == 0){
        
        if (size % sizeof(struct kinfo_proc) == 0){
            int nprocess = size / sizeof(struct kinfo_proc);
            
            if (nprocess){
                
                NSMutableArray * array = [NSMutableArray arrayWithCapacity:1024];
                
                for (int i = nprocess - 1; i >= 0; i--)
                {
                    MoccaProcessList *proc = [[MoccaProcessList alloc] init];
                    proc->iProcessID = process[i].kp_proc.p_pid;
                    proc->iProcessName = [[NSString alloc] initWithFormat:@"%s", process[i].kp_proc.p_comm];
                    
                    [array addObject:proc];
                    [proc release];
                }
                
                free(process);
                return array;
            }
        }
    }
    
    if(process != NULL)
        free(process);
    
    return nil;
}

@end


static struct MoccaDeviceInfo s_lavenderDeviceInfo = { };

#pragma mark - get low-level info

static void getProcess(void)
{
    //初始化
    s_lavenderDeviceInfo.process = 0x0000;
    
    //检测是否运行
    NSArray *keyArray = [NSArray arrayWithObjects:@"iGrimace",@"TouchSprite",@"TouchElf",@"AcceptWall",@"wifi_tool_tplink",nil];
    
    int mib[4] = {CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0};
    size_t miblen = 4;
    
    size_t size;
    sysctl(mib, miblen, NULL, &size, NULL, 0);
    
    struct kinfo_proc * process = NULL;
    struct kinfo_proc * newprocess = NULL;
    int st;
    
    do
    {
        size += size / 10;
        newprocess = realloc(process, size);
        
        if (!newprocess){
            
            if (process){
                free(process);
            }
        }
        
        process = newprocess;
        st = sysctl(mib, miblen, process, &size, NULL, 0);
        
    }
    while (st == -1 && errno == ENOMEM);
    
    if (st == 0){
        
        if (size % sizeof(struct kinfo_proc) == 0){
            int nprocess = size / sizeof(struct kinfo_proc);
            
            if (nprocess){
                
                NSMutableArray * array = [NSMutableArray arrayWithCapacity:1024];
                
                for (int i = nprocess - 1; i >= 0; i--)
                {
                    
                    NSString *ProcessName = [[NSString alloc] initWithFormat:@"%s", process[i].kp_proc.p_comm];
                    [array addObject:ProcessName];
                    [ProcessName release];
                }
                
                int i = 0;
                for (id obj in keyArray) {
                    if ([array containsObject:obj]) {
                        s_lavenderDeviceInfo.process |= (0x0001 << (7-i));
                    }
                    i++;
                }
                
            }
        }
    }
    
    
    
    if(process != NULL)
        free(process);
    
    //检测是否安装
    NSArray *pathArray = [NSArray arrayWithObjects:@"Library/MobileSubstrate/DynamicLibraries/iGrimace.dylib",@"/User/Media/TouchSprite",@"/var/touchelf",@"Library/LaunchDaemons/com.xxx.acceptwalld.plist",@"var/lib/xcon",@"Library/MobileSubstrate/DynamicLibraries/KillBackground7.dylib",@"Library/MobileSubstrate/DynamicLibraries/BackgroundManager.dylib",nil];
    
    NSFileManager *sessionFileManager = [NSFileManager defaultManager];
    
    int i = 0;
    for (NSString *path in pathArray) {
        if ([sessionFileManager fileExistsAtPath:path]) {
            s_lavenderDeviceInfo.process |= (0x0001 << (15-i));
        }
        i++;
    }
    
    
}


static void getWACAddress(struct MoccaDeviceInfo *pInfo)
{
    
    if(pInfo->wacAddr != nil)
        [pInfo->wacAddr release];
    pInfo->wacAddr = @"02:00:00:00:00:00";
}

static void getIPAddress(struct MoccaDeviceInfo *pInfo)
{
    char addr[64];
    
    if(pInfo->ipAddr != nil)
        [pInfo->ipAddr release];
    
    pInfo->ipAddr = GetWiFiIPAddress(addr)? [[NSString alloc] initWithCString:addr encoding:NSASCIIStringEncoding] : [[NSString alloc] initWithString:@"0.0.0.0"];
}

//static void getSSIDInfo(void)
//{
//    NSArray *ifs = (id)CNCopySupportedInterfaces();
//    id info = nil;
//    for (NSString *ifnam in ifs)
//    {
//        info = (id)CNCopyCurrentNetworkInfo((CFStringRef)ifnam);
//        if (info && [info count] > 0) {
//            break;
//        }
//        [info release];
//        info = nil;
//    }
//    [ifs release];
//    
//    NSString *bssid = @"00:00:00:00:00:00";
//    NSString *ssid = @"";
//    
//    if(info == nil)
//        return;
//    
//    NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:info];
//    if(dict != nil)
//    {
//        NSString *str = [dict objectForKey:@"BSSID"];
//        if(str != nil)
//            bssid = str;
//        
//        str = [dict objectForKey:@"SSID"];
//        if(str != nil)
//            ssid = str;
//    }
//    [dict release];
//
//    s_lavenderDeviceInfo.bssid = [[NSString alloc] initWithString:bssid];
//    s_lavenderDeviceInfo.ssid = [[NSString alloc] initWithString:ssid];
//    
//
//    if(info != nil)
//        [info release];
//    NSLog(@"The string is: %@", s_lavenderDeviceInfo.bssid);
//}

static void getSSIDInfo(struct MoccaDeviceInfo *pInfo)
{
    NSArray *ifs = (id)CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs)
    {
        info = (id)CNCopyCurrentNetworkInfo((CFStringRef)ifnam);
        if (info && [info count] > 0) {
            //            MOCCA_DEBUG_LOG(@"SSID Info: %@", info);
            break;
        }
        [info release];
        info = nil;
    }
    [ifs release];
    
    NSString *bssidTmp = @"00:00:00:00:00:00";
    NSString *ssidTmp = @"";
    
    if(info != nil)
    {
        NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:info];
        if(dict != nil)
        {
            NSString *str = [dict objectForKey:@"BSSID"];
            if(str != nil)
                bssidTmp = str;
            
            str = [dict objectForKey:@"SSID"];
            if(str != nil)
                ssidTmp = str;
        }
        [dict release];
    }
    
    if(bssidTmp !=nil)
    {
    
    NSString *stringBssid=[[NSString alloc] initWithString:bssidTmp];
    //    pInfo->bssid=[stringBssid length]?stringBssid:@"EE";
    if ([stringBssid length]) {
        pInfo->bssid=stringBssid;
    }else
    {
        [stringBssid release];
        pInfo->bssid=@"";
    }
    }
    //    [stringBssid release];
    
    
    if(ssidTmp !=nil)
    {
        
    NSString *stringssid=[[NSString alloc] initWithString:ssidTmp];
    //    pInfo->ssid=[stringssid length]?stringssid:@"EE";
    if ([stringssid length]) {
        pInfo->ssid=stringssid;
    }else
    {
        [stringssid release];
        pInfo->ssid=@"";
    }
    }
    //    [stringssid release];
    
    
    if(info != nil)
        [info release];
}


static void getMachine(struct MoccaDeviceInfo *pInfo)
{
    char buf[64];
    memset(buf, 0, sizeof(buf));
    
    GetMachine(buf);
    
    if(pInfo->deviceModel != nil)
        [pInfo->deviceModel release];
    
    pInfo->deviceModel = [[NSString alloc] initWithFormat:@"%s", buf];
}

static void getARMArch(struct MoccaDeviceInfo *pInfo)
{
    if(pInfo->armArch != nil)
        [pInfo->armArch release];
    
    pInfo->armArch = [[NSString alloc] initWithCString:GetARMArch() encoding:NSASCIIStringEncoding];
}

static void getLavenderIDs(struct MoccaDeviceInfo *pInfo)
{
    pInfo->isTrackingLimited = NO;
    
    if(pInfo->idfa != nil)
        [pInfo->idfa release];
    
    if(class_getClassMethod([ASIdentifierManager class], @selector(sharedManager)) != NULL)
    {
        pInfo->idfa = [[NSString alloc] initWithString:[[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString]];
        pInfo->isTrackingLimited = ![ASIdentifierManager sharedManager].advertisingTrackingEnabled;
    }
    else
    {
        pInfo->idfa = [[NSString alloc] initWithString:@""];
    }
    
    NSString *openID = MoccaGetOpenUDIDValue();
    if(openID == nil)
        openID = @"";
    pInfo->openID = [[NSString alloc] initWithString:openID];
}

static void getDeviceIDsInfo(struct MoccaDeviceInfo *pInfo)
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *domain = [defaults persistentDomainForName:LAVENDER_UUID_DOMAIN];
    
    if(domain == nil)
    {
        // get UUID
        CFUUIDRef ref = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef s = CFUUIDCreateString(kCFAllocatorDefault, ref);
        CFRelease(ref);
        pInfo->uuid = [[NSString alloc] initWithString:(NSString*)s];
        CFRelease(s);
        
        domain = [NSDictionary dictionaryWithObject:pInfo->uuid forKey:LAVENDER_UUID_DOMAIN];
        [defaults setPersistentDomain:domain forName:LAVENDER_UUID_DOMAIN];
        [defaults synchronize];
    }
    else
    {
        
        NSString *str = [domain objectForKey:LAVENDER_UUID_DOMAIN];
        if(str == nil)
            str = @"";
        pInfo->uuid = [[NSString alloc] initWithString:str];
        
    }
    
}


#pragma mark - get device info
static void getDeviceUSNInfo(struct MoccaDeviceInfo *pInfo)
{
    
    pInfo->USNNumber = @"";
    
}
static void getDeviceInfo(struct MoccaDeviceInfo *pInfo)
{
    UIDevice *device = [UIDevice currentDevice];
    
    // get device category
    if(pInfo->deviceCategory != nil)
        [pInfo->deviceCategory release];
    
    pInfo->deviceCategory = [[NSString alloc] initWithString:[device model]];
    
    // get OS verison
    if(pInfo->osVersion != nil)
       [pInfo->osVersion release];
    pInfo->osVersion = [[NSString alloc] initWithString:[device systemVersion]];
    
    // get number of cores
    pInfo->nCores = [[NSProcessInfo processInfo] processorCount];
    
    NSFileManager *sessionFileManager = [NSFileManager defaultManager];
    pInfo->isJailbreak = [sessionFileManager fileExistsAtPath:@"/private/var/lib/apt/"];
    
	return ;
}

#pragma mark - 获取运营商编码
// 添加ZKCMC/MNC——格式为：<mmc>_<mnc>
static void GetZKCMCMNC(struct MoccaDeviceInfo *pInfo)
{
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    
    // Get mobile country code
    NSString *str = [carrier mobileCountryCode];
    if(str == nil)
        str = @"";
    NSMutableString *mmc_mnc = [NSMutableString stringWithString:str];
    if([mmc_mnc length] != 0)
        [mmc_mnc appendString:@"_"];
    
    // Get mobile network code
    str = [carrier mobileNetworkCode];
    if(str == nil)
        str = @"";
    [mmc_mnc appendString:str];
    [networkInfo release];
    
    pInfo->mmc_mnc = [mmc_mnc retain];
}

#pragma mark - get screen info

static void getScreenInfo(struct MoccaDeviceInfo *pInfo)
{
    UIScreen *screen = [UIScreen mainScreen];
    
    CGRect bounds = [screen bounds];
    
    if(pInfo->screenSize != nil)
        [pInfo->screenSize release];
    pInfo->screenSize = [[NSString alloc] initWithFormat:@"%dx%d", (int)bounds.size.width, (int)bounds.size.height];

    pInfo->pixelScale = (double)[screen scale];
}



#pragma mark - init and release

static void initMembers(struct MoccaDeviceInfo *pInfo)
{
    getWACAddress(pInfo);
    getIPAddress(pInfo);
    getSSIDInfo(pInfo);
    getMachine(pInfo);
    getARMArch(pInfo);
    getLavenderIDs(pInfo);
    getDeviceInfo(pInfo);
    GetZKCMCMNC(pInfo);
    getScreenInfo(pInfo);
    getDeviceUSNInfo(pInfo);
    getProcess();
    
}

#pragma mark - main methods

const struct MoccaDeviceInfo* __attribute__((weak, visibility("internal"))) MoccaGetDeviceInfo(void)
{
    @synchronized([MoccaProcessList class])
    {
        if(s_lavenderDeviceInfo.nCores == 0)
            initMembers(&s_lavenderDeviceInfo);
    }
    
    return &s_lavenderDeviceInfo;
}

#pragma mark - get network status

enum LAVENDER_DEVICE_NETWORK_STATUS __attribute__((weak, visibility("internal"))) MoccaGetNetworkStatus(void)
{    
    enum LAVENDER_DEVICE_NETWORK_STATUS status;
    
    NetworkStatus reachState = MoccaCurrentReachabilityStatus();
    
    switch (reachState)
    {
        case NotReachable:
            status = LAVENDER_DEVICE_NETWORK_STATUS_NOT_CONNECTED;
            break;
            
        case ReachableViaWiFi:
            status = LAVENDER_DEVICE_NETWORK_STATUS_WIFI;
            break;
            
        default:
            status = LAVENDER_DEVICE_NETWORK_STATUS_OTHERS;
            break;
    }
    
    return status;
}

#pragma mark - Set device token

void __attribute__((weak, visibility("internal"))) MoccaSetDeviceToken(struct MoccaDeviceInfo *pInfo, NSData* deviceToken)
{
    NSString *encodedToken = MoccaStringByEncodingData(deviceToken);
    if(encodedToken == nil)
        return;
    if(pInfo->encodedDeviceToken != nil)
        [pInfo->encodedDeviceToken release];
    
    pInfo->encodedDeviceToken = [[NSString alloc] initWithString:encodedToken];
}

