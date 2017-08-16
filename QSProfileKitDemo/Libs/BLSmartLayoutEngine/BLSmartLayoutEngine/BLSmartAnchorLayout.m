//
//  BLSmartAnchorLayout.m
//  BLSmartLayoutEngine
//
//  Created by arlin on 16/5/5.
//  Copyright © 2016年 arlin. All rights reserved.
//

#import "BLSmartAnchorLayout.h"

@interface BLSmartAnchorLayout()

@end

@implementation BLSmartAnchorLayout

+ (void)bls_layoutViews:(UIView*)superView {
    if ( superView == nil || superView.subviews.count == 0 )
    {
        return;
    }
    
    if ( superView.bls_layoutType != BLSmartLayoutTypeAnchor )
    {
        return;
    }
    
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
    
    CGRect superViewFrame = superView.bounds;
    CGFloat contentLeft = superView.bls_margins.left;
    CGFloat contentTop = superView.bls_margins.top;
    CGFloat contentRight = superViewFrame.size.width + superView.bls_margins.right;
    CGFloat contentBottom = superViewFrame.size.height + + superView.bls_margins.bottom;
    
    for ( int i = 0; i < layoutSubViews.count; i++ )
    {
        UIView* subView = [layoutSubViews objectAtIndex:i];
        if ( subView.bls_anchorInfo == nil )
        {
            continue;
        }
        
        CGRect frame = CGRectZero;
        CGFloat leftPosition = contentLeft;
        CGFloat topPosition = contentTop;
        CGFloat rightPosition = contentRight;
        CGFloat bottomPosition = contentBottom;
        BLSmartLayoutAnchorInfo* anchorInfo = subView.bls_anchorInfo;
        
        //left anchor
        if ( anchorInfo.bls_leftAnchor.left > 0.0 )
        {
            leftPosition = contentLeft + anchorInfo.bls_leftAnchor.left;
        }
        else if ( anchorInfo.bls_leftAnchor.right > 0.0 )
        {
            leftPosition = contentRight - anchorInfo.bls_leftAnchor.right;
        }
        
        //top anchor
        if ( anchorInfo.bls_topAnchor.top > 0.0 )
        {
            topPosition = contentTop + anchorInfo.bls_topAnchor.top;
        }
        else if ( anchorInfo.bls_topAnchor.bottom > 0.0 )
        {
            topPosition = contentBottom - anchorInfo.bls_topAnchor.bottom;
        }
        
        //right anchor
        if ( anchorInfo.bls_rightAnchor.left > 0.0 )
        {
            rightPosition = contentLeft + anchorInfo.bls_rightAnchor.left;
        }
        else if ( anchorInfo.bls_rightAnchor.right > 0.0 )
        {
            rightPosition = contentRight - anchorInfo.bls_rightAnchor.right;
        }
        
        //bottom anchor
        if ( anchorInfo.bls_bottomAnchor.top > 0.0 )
        {
            bottomPosition = contentTop + anchorInfo.bls_bottomAnchor.top;
        }
        else if ( anchorInfo.bls_bottomAnchor.bottom > 0.0 )
        {
            bottomPosition = contentBottom - anchorInfo.bls_bottomAnchor.bottom;
        }
        
        frame.origin.x = leftPosition;
        frame.origin.y = topPosition;
        frame.size.width = rightPosition- leftPosition;
        frame.size.height = bottomPosition - topPosition;
        
        subView.frame = frame;
        [superView bls_viewDidLayoutSubView:subView];
    }
    
    [superView bls_viewDidLayoutSubViews];
}

@end
