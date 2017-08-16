//
//  QSWebImageView+UIImageView.m
//  QSProfileKitDemo
//
//  Created by arlin on 2017/8/16.
//  Copyright © 2017年 bls. All rights reserved.
//

#import "QSWebImageView+UIImageView.h"
#import <objc/runtime.h>

#define qs_dispatch_async_safe(queue,block)\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(queue)) == 0) {\
block();\
} else {\
dispatch_async(queue, block);\
}

@interface UIImageView (QSWebImageViewInternal)

@property (nonatomic, strong) NSURLSessionTask *qsDownloadtask;

@end

@implementation UIImageView (QSWebImageViewInternal)

@dynamic qsDownloadtask;

- (void)setQsDownloadtask:(NSURLSessionTask *)qsDownloadtask
{
    objc_setAssociatedObject(self, @selector(qsDownloadtask), qsDownloadtask, OBJC_ASSOCIATION_RETAIN);
}

- (NSURLSessionTask *)qsDownloadtask
{
    return objc_getAssociatedObject(self, @selector(qsDownloadtask));
}

@end

@implementation UIImageView (QSWebImageView)

- (void)qs_setImageURL:(NSString *)URL
{
    [self qs_cancelDownload];
    
    NSURL *nsURL = [NSURL URLWithString:URL];
    
    self.qsDownloadtask = [[NSURLSession sharedSession] downloadTaskWithURL:nsURL completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // Always download the remote file
        NSData *data = [NSData dataWithContentsOfURL:location];
        UIImage *image = [UIImage imageWithData:data];
        if ( image )
        {
            qs_dispatch_async_safe(dispatch_get_main_queue(), ^{
                self.image = image;
            });
        }
        
    }];
    
    [self.qsDownloadtask resume];
}

- (void)qs_cancelDownload
{
    if ( self.qsDownloadtask )
    {
        [self.qsDownloadtask cancel];
        self.qsDownloadtask = nil;
    }
}

@end
