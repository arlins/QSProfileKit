//
//  QSPerformanceNetwork.h
//  QSProfileKit
//
//  Created by arlin on 2017/8/16.
//  Copyright © 2017年 bls. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QSPerformanceNetworkDetail;

@interface QSPerformanceNetwork : NSObject

// Speeds in detail are always invaild when first call this method
- (QSPerformanceNetworkDetail *)networkDetail;

@end
