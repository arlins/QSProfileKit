//
//  UIView+BLSmartLayoutEngine+.m
//  BLSmartLayoutEngine
//
//  Created by arlin on 16/5/5.
//  Copyright © 2016年 arlin. All rights reserved.
//

#import "UIView+BLSmartLayoutEngine.h"
#import <objc/runtime.h>
#import "BLSmartHBoxLayout.h"
#import "BLSmartVBoxLayout.h"
#import "BLSmartAnchorLayout.h"
#import "BLSmartLayout.h"

const NSUInteger BLSmartLayoutTypeNone = 0;
const NSUInteger BLSmartLayoutTypeHBox = 1;
const NSUInteger BLSmartLayoutTypeVBox = 2;
const NSUInteger BLSmartLayoutTypeAnchor = 3;
const NSUInteger BLSmartLayoutTypeUser = 100;

static NSMutableDictionary* bls_layoutDictionary = nil;

#pragma mark - BLSmartLayoutAnchorInfo

@implementation BLSmartLayoutAnchorInfo

- (instancetype)init
{
    self = [super init];
    if ( self )
    {
        self.bls_leftAnchor = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        self.bls_topAnchor = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        self.bls_rightAnchor = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        self.bls_bottomAnchor = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    }
    
    return self;
}

@end


#pragma mark - UIView(BLSmartLayoutEngineInternal)

@interface UIView(BLSmartLayoutEngineInternal)

+ (Class)layoutClassByType:(NSUInteger)type;

@end

@implementation UIView(BLSmartLayoutEngineInternal)

+ (Class)layoutClassByType:(NSUInteger)type
{
    if ( bls_layoutDictionary == nil )
    {
        return Nil;
    }
    
    Class layoutClass = [bls_layoutDictionary objectForKey:@(type)];
    return layoutClass;
}

@end

#pragma mark - UIView(BLSmartLayoutEngine)

@implementation UIView(BLSmartLayoutEngine)

+ (void)bls_swizzedInstanceMethod:(SEL) swizzledSelector originalSelector:(SEL)originalSelector
{
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod)
    {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }
    else
    {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = nil;
        SEL swizzledSelector = nil;
        
        originalSelector = @selector(setFrame:);
        swizzledSelector = @selector(bls_setFrame:);
        [UIView bls_swizzedInstanceMethod:swizzledSelector
                         originalSelector:originalSelector];
        
        originalSelector = @selector(init);
        swizzledSelector = @selector(bls_init);
        [UIView bls_swizzedInstanceMethod:swizzledSelector originalSelector:originalSelector];
        
        originalSelector = @selector(initWithFrame:);
        swizzledSelector = @selector(bls_initWithFrame:);
        [UIView bls_swizzedInstanceMethod:swizzledSelector originalSelector:originalSelector];
        
        originalSelector = @selector(initWithCoder:);
        swizzledSelector = @selector(bls_initWithCoder:);
        [UIView bls_swizzedInstanceMethod:swizzledSelector originalSelector:originalSelector];
        
        [UIView bls_registLayoutClass:[BLSmartHBoxLayout class] layoutType:BLSmartLayoutTypeHBox];
        [UIView bls_registLayoutClass:[BLSmartVBoxLayout class] layoutType:BLSmartLayoutTypeVBox];
        [UIView bls_registLayoutClass:[BLSmartAnchorLayout class] layoutType:BLSmartLayoutTypeAnchor];
    });
}

+ (void)bls_registLayoutClass:(Class)layoutClass layoutType:(NSUInteger)type {
    if ( ![layoutClass isSubclassOfClass:[BLSmartLayout class]] )
    {
        NSAssert( NO, @"[error]layoutClass must inherit from BLSmartLayout." );
        return;
    }
    
    Class layoutClassName = [bls_layoutDictionary objectForKey:@(type)];
    if ( layoutClassName != Nil )
    {
        NSString *error = [NSString stringWithFormat:@"[error]layoutClass %@ of type %d alerady exist, use a new type to regist.", NSStringFromClass(layoutClass), (int)type];
        NSAssert( NO, error );
        return;
    }
    
    if ( bls_layoutDictionary == nil )
    {
        bls_layoutDictionary = [[NSMutableDictionary alloc] init];
    }
    
    [bls_layoutDictionary setObject:layoutClass forKey:[NSNumber numberWithUnsignedInteger:type]];
}

- (instancetype)bls_init
{
    [self bls_common_init];
    return [self bls_init];
}

- (instancetype)bls_initWithFrame:(CGRect)frame
{
    [self bls_common_init];
    return [self bls_initWithFrame:frame];
}

- (instancetype)bls_initWithCoder:(NSCoder *)aDecoder
{
    [self bls_common_init];
    return [self bls_initWithCoder:aDecoder];
}

- (void)bls_common_init
{
    self.bls_layoutType = BLSmartLayoutTypeNone;
    self.bls_layoutEnbled = YES;
    self.bls_spacing = 0.0;
    self.bls_itemSpacing = 0.0;
    self.bls_fixedWidth = -1.0;
    self.bls_fixedHeight = -1.0;
    self.bls_margins = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
}

#pragma mark - Swizzied Methods

- (void)bls_setFrame:(CGRect)frame
{
    [self bls_setFrame:frame];
    [self bls_layoutSubViews];
}

#pragma mark - Property

- (NSUInteger)bls_layoutType
{
    return [objc_getAssociatedObject(self, @selector(bls_layoutType)) unsignedIntegerValue];
}

- (void)setBls_layoutType:(NSUInteger)bls_layoutType
{
    objc_setAssociatedObject(self, @selector(bls_layoutType), @(bls_layoutType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)bls_layoutEnbled
{
    return [objc_getAssociatedObject(self, @selector(bls_layoutEnbled)) floatValue];
}

- (void)setBls_layoutEnbled:(BOOL)bls_layoutEnbled
{
    objc_setAssociatedObject(self, @selector(bls_layoutEnbled), @(bls_layoutEnbled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//*
- (CGFloat)bls_fixedHeight
{
    return [objc_getAssociatedObject(self, @selector(bls_fixedHeight)) floatValue];
}

- (void)setBls_fixedHeight:(CGFloat)bls_fixedHeight
{
    objc_setAssociatedObject(self, @selector(bls_fixedHeight), @(bls_fixedHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)bls_fixedWidth
{
    return [objc_getAssociatedObject(self, @selector(bls_fixedWidth)) floatValue];
}

- (void)setBls_fixedWidth:(CGFloat)bls_fixedWidth
{
    objc_setAssociatedObject(self, @selector(bls_fixedWidth), @(bls_fixedWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)bls_margins
{
    NSValue* value = objc_getAssociatedObject(self, @selector(bls_margins));
    return value.UIEdgeInsetsValue;
}

- (void)setBls_margins:(UIEdgeInsets)bls_margins
{
    NSValue* value = [NSValue valueWithUIEdgeInsets:bls_margins];
    objc_setAssociatedObject(self, @selector(bls_margins), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BLSmartLayoutAnchorInfo*)bls_anchorInfo
{
    return objc_getAssociatedObject(self, @selector(bls_anchorInfo));
}

- (void)setBls_anchorInfo:(BLSmartLayoutAnchorInfo *)bls_anchorInfo
{
    objc_setAssociatedObject(self, @selector(bls_anchorInfo), bls_anchorInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)bls_userLayoutInfo
{
    return objc_getAssociatedObject(self, @selector(bls_userLayoutInfo));
}

- (void)setBls_userLayoutInfo:(id)bls_userLayoutInfo
{
    objc_setAssociatedObject(self, @selector(bls_userLayoutInfo), bls_userLayoutInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)bls_spacing
{
    return [objc_getAssociatedObject(self, @selector(bls_spacing)) floatValue];
}

- (void)setBls_spacing:(CGFloat)bls_spacing
{
    objc_setAssociatedObject(self, @selector(bls_spacing), @(bls_spacing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)bls_itemSpacing
{
    return [objc_getAssociatedObject(self, @selector(bls_itemSpacing)) floatValue];
}

- (void)setBls_itemSpacing:(CGFloat)bls_itemSpacing
{
    objc_setAssociatedObject(self, @selector(bls_itemSpacing), @(bls_itemSpacing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)bls_layoutSubViews
{
    if ( self.bls_layoutType == BLSmartLayoutTypeNone )
    {
        return;
    }
    
    Class layoutClass = [UIView layoutClassByType:self.bls_layoutType];
    if ( layoutClass == Nil )
    {
        NSString *error = [NSString stringWithFormat:@"[error]Can not find layoutClass of type %d, regist layoutClass before you use it.", (int)self.bls_layoutType];
        NSAssert( NO, error );
        return;
    }
    
    if ( ![layoutClass isSubclassOfClass:[BLSmartLayout class]] )
    {
        NSString *error = [NSString stringWithFormat:@"[error]layoutClass %@ is not a subclass of BLSmartLayout.", NSStringFromClass(layoutClass)];
        NSAssert( NO, error );
        return;
    }
    
    [layoutClass bls_layoutViews:self];
}

- (void)bls_viewDidLayoutSubView:(UIView *)view
{
    
}

- (void)bls_viewDidLayoutSubViews
{

}

@end
