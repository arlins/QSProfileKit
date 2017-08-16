//
//  QSPerformanceMemory.m
//  QSProfileKit
//
//  Created by arlin on 2017/8/11.
//  Copyright © 2017年 bls. All rights reserved.
//

#import "QSPerformanceMemory.h"
#import <mach/mach.h>
#import <mach/task_info.h>
#import "QSPerformanceService.h"

@implementation QSPerformanceMemory

- (QSPerformanceMemoryDetail *)memoryDetail
{
    QSPerformanceMemoryDetail *detail = [[QSPerformanceMemoryDetail alloc] init];
    struct mach_task_basic_info info;
    mach_msg_type_number_t count = sizeof(info) / sizeof(integer_t);
    
    if (task_info(mach_task_self(), MACH_TASK_BASIC_INFO, (task_info_t)&info, &count) == KERN_SUCCESS)
    {
        detail.usage = info.resident_size;
        detail.total = [NSProcessInfo processInfo].physicalMemory;
        detail.ratio = info.virtual_size / [NSProcessInfo processInfo].physicalMemory;
    }
    
    return detail;
}

@end
