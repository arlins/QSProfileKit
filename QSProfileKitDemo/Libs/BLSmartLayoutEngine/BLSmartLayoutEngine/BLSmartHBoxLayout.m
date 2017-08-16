//
//  BLSmartLayout.m
//  BLSmartLayoutEngine
//
//  Created by arlin on 16/5/5.
//  Copyright © 2016年 arlin. All rights reserved.
//

#import "BLSmartHBoxLayout.h"

@implementation BLSmartHBoxLayout

+ (void)bls_layoutViews:(UIView*)superView {
    if ( superView == nil || superView.subviews.count == 0 )
    {
        return;
    }
    
    if ( superView.bls_layoutType != BLSmartLayoutTypeHBox )
    {
        return;
    }
    
    CGRect superViewFrame = superView.bounds;
    CGFloat emptySpacing = 0;
    CGFloat totalFixedWidth = 0;
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
        
        
        if ( subView.bls_fixedWidth >= 0.0 )
        {
            totalFixedWidth += subView.bls_fixedWidth;
        }
        else
        {
            resizeableViewCount ++;
        }
    }
    
    CGFloat leftPosition = superView.bls_margins.left;
    CGFloat topPosition = superView.bls_margins.top;
    CGFloat viewHeight = superViewFrame.size.height + superView.bls_margins.bottom - topPosition;
    
    CGFloat adjustedViewWidth = 0;
    if ( resizeableViewCount > 0 )
    {
        adjustedViewWidth = superViewFrame.size.width;
        adjustedViewWidth = adjustedViewWidth - superView.bls_margins.left;
        adjustedViewWidth = adjustedViewWidth + superView.bls_margins.right;
        adjustedViewWidth = adjustedViewWidth - emptySpacing;
        adjustedViewWidth = adjustedViewWidth - totalFixedWidth;
        
        adjustedViewWidth = adjustedViewWidth/resizeableViewCount;
        adjustedViewWidth = MAX(adjustedViewWidth, 0.0);
    }
    
    for ( int i = 0; i < layoutSubViews.count; i++ )
    {
        UIView* subView = [layoutSubViews objectAtIndex:i];
        if ( subView.bls_fixedWidth >= 0.0 )
        {
            CGRect frame;
            frame.origin.x = leftPosition;
            frame.origin.y = topPosition;
            frame.size.width = subView.bls_fixedWidth;
            frame.size.height = viewHeight;
            
            subView.frame = frame;
            leftPosition += subView.frame.size.width;
            [superView bls_viewDidLayoutSubView:subView];
            
            if ( i != layoutSubViews.count - 1 )
            {
                leftPosition += superView.bls_spacing;
                leftPosition += subView.bls_itemSpacing;
            }
        }
        else
        {
            CGRect frame;
            frame.origin.x = leftPosition;
            frame.origin.y = topPosition;
            frame.size.width = adjustedViewWidth;
            frame.size.height = viewHeight;
            
            subView.frame = frame;
            leftPosition += adjustedViewWidth;
            [superView bls_viewDidLayoutSubView:subView];
            
            if ( i != layoutSubViews.count - 1 )
            {
                leftPosition += superView.bls_spacing;
                leftPosition += subView.bls_itemSpacing;
            }
        }
    }
    
    [superView bls_viewDidLayoutSubViews];
}

@end
