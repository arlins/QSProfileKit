//
//  QSPerformanceFPS.m
//  QSProfileKit
//
//  Created by arlin on 2017/8/10.
//  Copyright © 2017年 bls. All rights reserved.
//

#import "QSPerformanceFPS.h"
#import "QSWeakProxy.h"
#import <UIKit/UIKit.h>

@interface QSPerformanceFPS ()

@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, assign) NSTimeInterval lastTime;
@property (nonatomic, assign) int fps;
@property (nonatomic, assign) int count;

@end

@implementation QSPerformanceFPS

- (instancetype)init
{
    self = [super init];
    if ( self )
    {
        _link = [CADisplayLink displayLinkWithTarget:[QSWeakProxy proxyWithTarget:self] selector:@selector(tick:)];
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    
    return self;
}

- (void)dealloc
{
    [_link invalidate];
}

- (void)tick:(CADisplayLink *)link
{
    if ( self.lastTime == 0 )
    {
        self.lastTime = self.link.timestamp;
        return;
    }
    
    self.count ++;
    
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1.0)
    {
        return;
    }
    
    self.lastTime = link.timestamp;
    self.fps = round(self.count / delta);
    self.count = 0;
}

@end
