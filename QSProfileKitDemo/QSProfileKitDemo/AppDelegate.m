//
//  AppDelegate.m
//  QSProfileKitDemo
//
//  Created by arlin on 2017/8/10.
//  Copyright © 2017年 bls. All rights reserved.
//

#import "AppDelegate.h"
#import "QSProfileKit.h"
#import "QSPerformanceDetailsView.h"
#import "TableViewTestViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self initQSPerformanceService];
    [self initWindow];
    
    return YES;
}

- (void)initQSPerformanceService
{
    [[QSPerformanceService sharedService] startService];
}

- (void)initWindow
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[TableViewTestViewController alloc] init];
    [self.window makeKeyAndVisible];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [QSPerformanceDetailsView show];
    });
}

@end
