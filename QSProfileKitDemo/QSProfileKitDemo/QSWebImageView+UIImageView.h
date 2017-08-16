//
//  QSWebImageView+UIImageView.h
//  QSProfileKitDemo
//
//  Created by arlin on 2017/8/16.
//  Copyright © 2017年 bls. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView(QSWebImageView)

- (void)qs_setImageURL:(NSString *)URL;

- (void)qs_cancelDownload;

@end
