//
//  QSPerformanceService.h
//  QSProfileKit
//
//  Created by arlin on 2017/8/10.
//  Copyright © 2017年 bls. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QSPerformanceDeclare.h"

@interface QSPerformanceService : NSObject

@property (nonatomic, readonly, assign) int fps;
@property (nonatomic, readonly, assign) float cpuUsage;    
@property (nonatomic, readonly, strong) QSPerformanceMemoryDetail *memoryDetail;
@property (nonatomic, readonly, strong) QSPerformanceNetworkDetail *networkDetail;

+ (instancetype)sharedService;

- (void)startService;

- (void)stopService;

@end
