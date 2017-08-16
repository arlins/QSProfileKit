//
//  QSPerformanceNetwork.m
//  QSProfileKit
//
//  Created by arlin on 2017/8/16.
//  Copyright © 2017年 bls. All rights reserved.
//

#import "QSPerformanceNetwork.h"
#import "QSPerformanceDeclare.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>

@implementation QSPerformanceNetwork

- (QSPerformanceNetworkDetail *)networkDetail
{
    static NSDate *lastDate = nil;
    static QSPerformanceNetworkDetail *lastDetail = nil;
    
    NSDate *now = [NSDate date];
    QSPerformanceNetworkDetail *detail = [self shotNetworkDetail];
    
    if ( lastDetail != nil && lastDate != nil )
    {
        NSTimeInterval interval = [now timeIntervalSinceDate:lastDate];
        detail.upSpeed = (detail.upBytes - lastDetail.upBytes) / interval;
        detail.downSpeed = (detail.downBytes - lastDetail.downBytes) / interval;
    }
    
    lastDate = now;
    lastDetail = detail;
    
    return lastDetail;
}

- (QSPerformanceNetworkDetail *)shotNetworkDetail
{
    struct ifaddrs *ifa_list = 0, *ifa;
    if (getifaddrs(&ifa_list) == -1)
    {
        return nil;
    }
    
    uint32_t iBytes = 0;
    uint32_t oBytes = 0;
    
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next)
    {
        if (AF_LINK != ifa->ifa_addr->sa_family)
            continue;
        
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
            continue;
        
        if (ifa->ifa_data == 0)
            continue;
        
        /* Not a loopback device. */
        if (strncmp(ifa->ifa_name, "lo", 2))
        {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            
            iBytes += if_data->ifi_ibytes;
            oBytes += if_data->ifi_obytes;
        }
    }
    
    freeifaddrs(ifa_list);
    
    QSPerformanceNetworkDetail *detail = [[QSPerformanceNetworkDetail alloc] init];
    detail.upBytes = oBytes;
    detail.downBytes = iBytes;
    
    return detail;
}

@end
