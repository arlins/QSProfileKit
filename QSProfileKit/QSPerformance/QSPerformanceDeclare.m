//
//  QSPerformanceDeclare.m
//  QSProfileKit
//
//  Created by arlin on 2017/8/11.
//  Copyright © 2017年 bls. All rights reserved.
//

#import "QSPerformanceDeclare.h"

@implementation QSPerformanceMemoryDetail

- (NSString *)description
{
    return [NSString stringWithFormat:@"usage = %lf total = %lf ratio = %lf", self.usage, self.total, self.ratio];
}

@end

@implementation QSPerformanceNetworkDetail

- (NSString *)description
{
    return [NSString stringWithFormat:@"upSpeed = %lf downSpeed = %lf upBytes = %llu downBytes = %llu", self.upSpeed, self.downSpeed, self.upBytes, self.downBytes];
}

@end
