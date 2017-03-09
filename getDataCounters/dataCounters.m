//
//  dataCounters.m
//  getDataCounters
//
//  Created by 刘佳男 on 14/10/29.
//  Copyright (c) 2014年 liujianan. All rights reserved.
//

#import "dataCounters.h"
#import <ifaddrs.h>
#import <sys/socket.h>
#import <net/if.h>

@implementation dataCounters

- (double)getDataCounters
{
    BOOL   success;
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    const struct if_data *networkStatisc;
    
    double WiFiSent = 0;
    double WiFiReceived = 0;
    double WWANSent = 0;
    double WWANReceived = 0;
    
    success = getifaddrs(&addrs) == 0;
    if (success)
    {
        cursor = addrs;
        while (cursor != NULL)
        {
            
            NSString * name=[NSString stringWithFormat:@"%s",cursor->ifa_name];
            // names of interfaces: en0 is WiFi ,pdp_ip0 is WWAN
            
            if (cursor->ifa_addr->sa_family == AF_LINK)
            {
                if ([name hasPrefix:@"en"])
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WiFiSent+=networkStatisc->ifi_obytes;
                    WiFiReceived+=networkStatisc->ifi_ibytes;
                }
                
                if ([name hasPrefix:@"pdp_ip"])
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WWANSent+=networkStatisc->ifi_obytes;
                    WWANReceived+=networkStatisc->ifi_ibytes;
                    
                }
            }
            
            cursor = cursor->ifa_next;
        }
        
        freeifaddrs(addrs);
    }
    
    double current = WWANSent+WWANReceived;
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSNumber *cache = [def objectForKey:@"cache"];
    if (!cache) {
        cache = [NSNumber numberWithDouble:current];
        [def setValue:cache forKey:@"cache"];
    }
    else if (current < [cache doubleValue]) {
        cache = @0;
        [def setValue:cache forKey:@"cache"];
    }
    else
    {
        [def setValue:[NSNumber numberWithDouble:current] forKey:@"cache"];
    }
    
    return (current - [cache doubleValue]);
}



-(dataCounters *)initTotal:(double)total withUsing:(double)using withDate:(NSDate *)clearDate
{
    self = [super init];
    if (self) {
        _totalCounters = total;
        _usingCounters = using;
        _currentCounters = 0;
        _nextClearDate = [[NSDate alloc] initWithTimeInterval:0.0f sinceDate:clearDate];
    }
    return self;
}

-(dataCounters *)initWithDataCounters:(dataCounters *)dataCounters
{
    return [self initTotal:dataCounters.totalCounters withUsing:dataCounters.usingCounters withDate:dataCounters.nextClearDate];
}

-(void)showAllCount
{
    NSLog(@"\ntotal is %f,\nusing is %f,\nnext clear date is %@,\n",_totalCounters,_usingCounters,_nextClearDate);
}

-(void)startDataCounters
{
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(timerDataCounters:) userInfo:nil repeats:YES];
    NSTimer *timer1 = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(checkClearDate:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] addTimer:timer1 forMode:NSDefaultRunLoopMode];
}
-(void)timerDataCounters:(NSTimer *)timer
{
    self.currentCounters = [self getDataCounters];
    self.usingCounters += self.currentCounters;
}
-(void)checkClearDate:(NSTimer *)timer
{
    NSDate *now= [NSDate date];
    if ([now compare:self.nextClearDate] == NSOrderedDescending)  // now > nextClearDate
    {
        //更新已用流量
        self.usingCounters = 0;
        //更新日期
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:self.nextClearDate];
        NSInteger month= [components month]+1;
        NSInteger year= [components year];
        
        if (month > 12) {
            month = 1;
            year++;
        }
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        self.nextClearDate = [formatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 00:00:00",year,month,1]];
        [formatter release];
        
    }
}
@end
