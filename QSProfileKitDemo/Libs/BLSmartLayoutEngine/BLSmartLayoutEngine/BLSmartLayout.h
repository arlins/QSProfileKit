//
//  BLSmartLayout.h
//  BLSmartLayoutEngine
//
//  Created by arlin on 16/5/5.
//  Copyright © 2016年 arlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIView+BLSmartLayoutEngine.h"

@interface BLSmartLayout : NSObject

/**
 *  @brief  自动布局superView的所有子view，新增BLSmartLayout类型需要继承该类并重写这个函数在里面做相应的子view布局
 *  @param  superView 父view
 */
+ (void)bls_layoutViews:(UIView*)superView;

@end
