//
//  QSPerformanceService.m
//  QSProfileKit
//
//  Created by arlin on 2017/8/10.
//  Copyright © 2017年 bls. All rights reserved.
//

#import "QSPerformanceService.h"
#import "QSPerformanceFPS.h"
#import "QSPerformanceCPU.h"
#import "QSPerformanceMemory.h"
#import "QSPerformanceNetwork.h"

#define QSDeclareLazyCreator(instance,class) \
- (class *)instance \
{ \
    if ( _##instance == nil ) \
    { \
        _##instance = [[class alloc] init]; \
    } \
    \
    return _##instance; \
}

@interface QSPerformanceService ()

@property (nonatomic, strong) QSPerformanceFPS *fpsPerformance;
@property (nonatomic, strong) QSPerformanceCPU *cpuPerformance;
@property (nonatomic, strong) QSPerformanceMemory *memoryPerformance;
@property (nonatomic, strong) QSPerformanceNetwork *networkPerformance;

@end

@implementation QSPerformanceService

QSDeclareLazyCreator(cpuPerformance, QSPerformanceCPU);
QSDeclareLazyCreator(fpsPerformance, QSPerformanceFPS);
QSDeclareLazyCreator(memoryPerformance, QSPerformanceMemory);
QSDeclareLazyCreator(networkPerformance, QSPerformanceNetwork);

+ (instancetype)sharedService
{
    static id s_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_instance = [[[self class] alloc] init];
    });
    
    return s_instance;
}

- (int)fps
{
    return [self.fpsPerformance fps];
}

- (float)cpuUsage
{
    return [self.cpuPerformance cpuUsage];
}

- (QSPerformanceMemoryDetail *)memoryDetail
{
    return [self.memoryPerformance memoryDetail];
}

- (void)startService
{
    [self networkDetail];
}

- (QSPerformanceNetworkDetail *)networkDetail
{
    return [self.networkPerformance networkDetail];
}

- (void)stopService
{
    self.fpsPerformance = nil;
    self.cpuPerformance = nil;
    self.memoryPerformance = nil;
    self.networkPerformance = nil;
}

@end
