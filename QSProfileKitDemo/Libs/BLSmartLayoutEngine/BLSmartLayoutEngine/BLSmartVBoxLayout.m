//
//  BLSmartLayout.m
//  BLSmartLayoutEngine
//
//  Created by arlin on 16/5/5.
//  Copyright © 2016年 arlin. All rights reserved.
//

#import "BLSmartVBoxLayout.h"

@implementation BLSmartVBoxLayout

+ (void)bls_layoutViews:(UIView*)superView {
    if ( superView == nil || superView.subviews.count == 0 )
    {
        return;
    }
    
    if ( superView.bls_layoutType != BLSmartLayoutTypeVBox )
    {
        return;
    }
    
    CGRect superViewFrame = superView.bounds;
    CGFloat emptySpacing = 0;
    CGFloat totalFixedHeight = 0;
    NSUInteger resizeableViewCount = 0;
    NSArray* layoutSubViews = [superView.subviews filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        UIView* subView = (UIView*)evaluatedObject;
        if ( subView.bls_layoutEnbled ) {
            return YES;
        } else {
            return NO;
        }
    }]];
    
    if ( layoutSubViews.count == 0 )
    {
        return;
    }
    
    for ( int i = 0; i < layoutSubViews.count; i++ )
    {
        UIView* subView = [layoutSubViews objectAtIndex:i];
        if ( i != layoutSubViews.count - 1 )
        {
            emptySpacing += superView.bls_spacing;
            emptySpacing += subView.bls_itemSpacing;
        }
        
        
        if ( subView.bls_fixedHeight >= 0.0 )
        {
            totalFixedHeight += subView.bls_fixedHeight;
        }
        else
        {
            resizeableViewCount ++;
        }
    }
    
    CGFloat leftPosition = superView.bls_margins.left;
    CGFloat topPosition = superView.bls_margins.top;
    CGFloat viewWidth = superViewFrame.size.width + superView.bls_margins.right - leftPosition;
    
    CGFloat adjustedViewHeight = 0;
    if ( resizeableViewCount > 0 )
    {
        adjustedViewHeight = superViewFrame.size.height;
        adjustedViewHeight = adjustedViewHeight - superView.bls_margins.top;
        adjustedViewHeight = adjustedViewHeight + superView.bls_margins.bottom;
        adjustedViewHeight = adjustedViewHeight - emptySpacing;
        adjustedViewHeight = adjustedViewHeight - totalFixedHeight;
        
        adjustedViewHeight = adjustedViewHeight/resizeableViewCount;
        adjustedViewHeight = MAX(adjustedViewHeight, 0.0);
    }
    
    for ( int i = 0; i < layoutSubViews.count; i++ )
    {
        UIView* subView = [layoutSubViews objectAtIndex:i];
        if ( subView.bls_fixedHeight >= 0.0 )
        {
            CGRect frame;
            frame.origin.x = leftPosition;
            frame.origin.y = topPosition;
            frame.size.width = viewWidth;
            frame.size.height = subView.bls_fixedHeight;
            
            subView.frame = frame;
            topPosition += subView.frame.size.height;
            [superView bls_viewDidLayoutSubView:subView];
            
            if ( i != layoutSubViews.count - 1 )
            {
                topPosition += superView.bls_spacing;
                topPosition += subView.bls_itemSpacing;
            }
        }
        else
        {
            CGRect frame;
            frame.origin.x = leftPosition;
            frame.origin.y = topPosition;
            frame.size.width = viewWidth;
            frame.size.height = adjustedViewHeight;
            
            subView.frame = frame;
            topPosition += adjustedViewHeight;
            [superView bls_viewDidLayoutSubView:subView];
            
            if ( i != layoutSubViews.count - 1 )
            {
                topPosition += superView.bls_spacing;
                topPosition += subView.bls_itemSpacing;
            }
        }
    }
    
    [superView bls_viewDidLayoutSubViews];
}

@end
