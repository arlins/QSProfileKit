//
//  QSPerformanceCPU.m
//  QSProfileKit
//
//  Created by arlin on 2017/8/11.
//  Copyright © 2017年 bls. All rights reserved.
//

#import "QSPerformanceCPU.h"
#import <mach/task.h>
#import <mach/vm_map.h>
#import <mach/mach_init.h>
#import <mach/thread_act.h>
#import <mach/thread_info.h>

@implementation QSPerformanceCPU

- (float)cpuUsage
{
    float usageRatio = 0;
    thread_info_data_t thinfo;
    thread_act_array_t threads;
    thread_basic_info_t basic_info_t;
    mach_msg_type_number_t count = 0;
    mach_msg_type_number_t thread_info_count = THREAD_INFO_MAX;
    
    if (task_threads(mach_task_self(), &threads, &count) == KERN_SUCCESS)
    {
        for (int idx = 0; idx < count; idx++)
        {
            if (thread_info(threads[idx], THREAD_BASIC_INFO, (thread_info_t)thinfo, &thread_info_count) == KERN_SUCCESS)
            {
                basic_info_t = (thread_basic_info_t)thinfo;
                if (!(basic_info_t->flags & TH_FLAGS_IDLE))
                {
                    usageRatio += basic_info_t->cpu_usage / (double)TH_USAGE_SCALE;
                }
            }
        }
        
        vm_deallocate(mach_task_self(), (vm_address_t)threads, count * sizeof(thread_t));
    }
    
    return usageRatio * 100.0;
}

@end
