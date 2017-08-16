//
//  UIView+BLSmartLayoutEngine.h
//  BLSmartLayoutEngine
//
//  Created by arlin on 16/5/5.
//  Copyright © 2016年 arlin. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const NSUInteger BLSmartLayoutTypeNone;      //没有布局
extern const NSUInteger BLSmartLayoutTypeHBox;      //HBox布局
extern const NSUInteger BLSmartLayoutTypeVBox;      //VBox布局
extern const NSUInteger BLSmartLayoutTypeAnchor;    //Anchor布局
extern const NSUInteger BLSmartLayoutTypeUser;      //扩展类型


#pragma mark - BLSmartLayoutAnchorInfo

@interface BLSmartLayoutAnchorInfo : NSObject

@property (nonatomic, assign) UIEdgeInsets bls_leftAnchor;      //左边距与父View左/右的距离，只能设置一个有效值
@property (nonatomic, assign) UIEdgeInsets bls_topAnchor;       //上边距与父View上/下的距离，只能设置一个有效值
@property (nonatomic, assign) UIEdgeInsets bls_rightAnchor;     //右边距与父View左/右的距离，只能设置一个有效值
@property (nonatomic, assign) UIEdgeInsets bls_bottomAnchor;    //下边距与父View上/下的距离，只能设置一个有效值

@end


#pragma mark UIView(BLSmartLayoutEngine)

@interface UIView(BLSmartLayoutEngine)

@property (nonatomic, assign) NSUInteger bls_layoutType;    //布局类型，目前有HBox，VBox，Anchor，默认为None
@property (nonatomic, assign) BOOL bls_layoutEnbled;        //是否参与布局

@property (nonatomic, assign) CGFloat bls_fixedHeight;      //固定高度
@property (nonatomic, assign) CGFloat bls_fixedWidth;       //固定宽度
@property (nonatomic, assign) CGFloat bls_spacing;          //子View之间的间距
@property (nonatomic, assign) CGFloat bls_itemSpacing;      //距离下兄弟View之间的间距
@property (nonatomic, assign) UIEdgeInsets bls_margins;     //布局空间四个边距的缩进
@property (nonatomic, strong) BLSmartLayoutAnchorInfo* bls_anchorInfo;  //Anchor布局锚点信息
@property (nonatomic, strong) id bls_userLayoutInfo;        //自定义布局类型信息

/**
 *  @brief  注册布局类，需要扩展新的布局时使用使用该方法进行布局类以及类型的注册
 *  @param  layoutClass  继承BLSmartLayout实现的子类
 *  @param  type         布局类型
 */
+ (void)bls_registLayoutClass:(Class)layoutClass layoutType:(NSUInteger)type;

/**
 *  @brief  初始化View，新UIView类如果不使用常规的初始化方式（init,initWithFrame,initWithCoder），则需要在自己实现的初始化方法
 *  里面调用这个方法做初始化
 */
- (void)bls_common_init;

/**
 *  @brief  自动布局子view
 */
- (void)bls_layoutSubViews;

/**
 *  @brief  view已完成子View的自动布局
 *  @param  view 已完成布局的子View
 */
- (void)bls_viewDidLayoutSubView:(UIView*)view;

/**
 *  @brief  View已完成所有子View的布局
 */
- (void)bls_viewDidLayoutSubViews;

@end
