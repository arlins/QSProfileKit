//
//  QSPerformanceDeclare.h
//  QSProfileKit
//
//  Created by arlin on 2017/8/11.
//  Copyright © 2017年 bls. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface  QSPerformanceMemoryDetail : NSObject

@property (nonatomic, assign) double usage;   // 已用内存(bytes)
@property (nonatomic, assign) double total;   // 总内存(bytes)
@property (nonatomic, assign) double ratio;   // 占用比率

@end

@interface QSPerformanceNetworkDetail : NSObject

@property (nonatomic, assign) double upSpeed; //上行网速(B/s)
@property (nonatomic, assign) double downSpeed; //下行网速(B/s)
@property (nonatomic, assign) unsigned long long upBytes; //上行流量(bytes)
@property (nonatomic, assign) unsigned long long downBytes; //下行流量(bytes)

@end
