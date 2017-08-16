//
//  QSWeakProxy.h
//  QSProfileKit
//
//  Created by arlin on 2017/8/10.
//  Copyright © 2017年 bls. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QSWeakProxy : NSProxy

@property (nullable, nonatomic, weak, readonly) id target;

- (instancetype _Nonnull)initWithTarget:(id _Nullable )target;

+ (instancetype _Nonnull )proxyWithTarget:(id _Nullable )target;

@end
