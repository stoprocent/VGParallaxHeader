//
//  UIScrollView+VGParallaxHeader.m
//
//  Created by Marek Serafin on 2014-09-18.
//  Copyright (c) 2013 VG. All rights reserved.
//

#import "UIScrollView+VGParallaxHeader.h"

#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#import <PureLayout.h>

static char UIScrollViewViewVGParallaxHeader;

#pragma mark - VGParallaxHeader (Interface)
@interface VGParallaxHeader ()

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
                       contentView:(UIView *)view
                              mode:(VGParallaxHeaderMode)mode
                            height:(CGFloat)height
                            shadow:(BOOL)shadow;

@property (nonatomic, assign, getter=isInsideTableView) BOOL insideTableView;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *shadowView;

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, assign) VGParallaxHeaderMode headerMode;
@property (nonatomic, readwrite) CGFloat originalTopInset;
@property (nonatomic, readwrite) CGFloat originalHeight;

@property (nonatomic, strong) NSLayoutConstraint *insetAwarePositionConstraint;
@property (nonatomic, strong) NSLayoutConstraint *insetAwareSizeConstraint;

@end

#pragma mark - UIScrollView (Implementation)
@implementation UIScrollView (VGParallaxHeader)


- (void)setParallaxHeaderView:(UIView *)view
                         mode:(VGParallaxHeaderMode)mode
                       height:(CGFloat)height
{
    [self setParallaxHeaderView:view
                           mode:mode
                         height:height
                         shadow:NO];
}

- (void)setParallaxHeaderView:(UIView *)view
                         mode:(VGParallaxHeaderMode)mode
                       height:(CGFloat)height
                       shadow:(BOOL)shadow
{
    self.parallaxHeader = [[VGParallaxHeader alloc] initWithScrollView:self
                                                           contentView:view
                                                                  mode:mode
                                                                height:height
                                                                shadow:shadow];
    [self shouldPositionParallaxHeader];
    
    // If UIScrollView adjust inset
    if (!self.parallaxHeader.isInsideTableView) {
        UIEdgeInsets selfContentInset = self.contentInset;
        selfContentInset.top += height;
        
        self.contentInset = selfContentInset;
        self.contentOffset = CGPointMake(0, -selfContentInset.top);
    }
    
    // Watch for inset changes
    [self addObserver:self.parallaxHeader
           forKeyPath:@"contentInset"
              options:NSKeyValueObservingOptionNew
              context:nil];
}

- (void)shouldPositionParallaxHeader
{
    if(self.parallaxHeader.isInsideTableView) {
        [self positionTableViewParallaxHeader];
    }
    else {
        [self positionScrollViewParallaxHeader];
    }
}

- (void)positionTableViewParallaxHeader
{
    if (self.contentOffset.y < self.parallaxHeader.originalHeight) {
        CGFloat height = self.contentOffset.y * -1 + self.parallaxHeader.originalHeight;
        CGFloat scrollProgress = fminf(1, (self.contentOffset.y/self.parallaxHeader.originalHeight));
        
        self.parallaxHeader.shadowView.alpha = scrollProgress;
        self.parallaxHeader.containerView.frame = CGRectMake(0, self.contentOffset.y, CGRectGetWidth(self.frame), height);
    }
}

- (void)positionScrollViewParallaxHeader
{
    if (self.contentOffset.y < 0) {
        CGFloat yOffset = self.contentOffset.y * -1;
        CGFloat scrollProgress = fminf(1, (yOffset / (self.parallaxHeader.originalHeight + self.parallaxHeader.originalTopInset)));
        
        self.parallaxHeader.shadowView.alpha = (1 - scrollProgress);
        self.parallaxHeader.frame = CGRectMake(0, self.contentOffset.y, CGRectGetWidth(self.frame), yOffset);
    }
}

- (void)setParallaxHeader:(VGParallaxHeader *)parallaxHeader
{
    // Remove All Subviews
    if([self.subviews count] > 0) {
        [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if([obj isMemberOfClass:[VGParallaxHeader class]]) {
                [obj removeFromSuperview];
            }
        }];
    }
    
    parallaxHeader.insideTableView = [self isKindOfClass:[UITableView class]];
    
    // Add Parallax Header
    if(parallaxHeader.isInsideTableView) {
        [(UITableView*)self setTableHeaderView:parallaxHeader];
    }
    else {
        [self addSubview:parallaxHeader];
    }
    
    // Set Associated Object
    objc_setAssociatedObject(self, &UIScrollViewViewVGParallaxHeader, parallaxHeader, OBJC_ASSOCIATION_ASSIGN);
}

- (VGParallaxHeader *)parallaxHeader
{
    return objc_getAssociatedObject(self, &UIScrollViewViewVGParallaxHeader);
}

@end

#pragma mark - VGParallaxHeader (Implementation)
@implementation VGParallaxHeader

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
                       contentView:(UIView *)view
                              mode:(VGParallaxHeaderMode)mode
                            height:(CGFloat)height
                            shadow:(BOOL)shadow
{
    self = [super initWithFrame:CGRectMake(0, 0, CGRectGetWidth(scrollView.bounds), height)];
    if (!self) {
        return nil;
    }
    
    self.scrollView = scrollView;
    
    self.headerMode = mode;
    self.originalHeight = height;
    self.originalTopInset = scrollView.contentInset.top;
    
    self.containerView = [[UIView alloc] initWithFrame:self.bounds];
    self.containerView.clipsToBounds = YES;
    
    if (!self.isInsideTableView) {
        self.containerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    
    [self addSubview:self.containerView];
    
    self.contentView = view;
    
    if (shadow) {
        [self addShadowView];
    }
    
    return self;
}

- (void)setContentView:(UIView *)contentView
{
    if(_contentView != nil) {
        [_containerView autoRemoveConstraintsAffectingView];
        [_contentView removeFromSuperview];
    }
    
    _contentView = contentView;
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.containerView addSubview:_contentView];
    
    [self setupContentViewMode];
}

- (void)setupContentViewMode
{
    switch (self.headerMode) {
        case VGParallaxHeaderModeFill:
            [self addContentViewModeFillConstraints];
            break;
        case VGParallaxHeaderModeTop:
            [self addContentViewModeTopConstraints];
            break;
        case VGParallaxHeaderModeTopFill:
            [self addContentViewModeTopFillConstraints];
            break;
        case VGParallaxHeaderModeCenter:
        default:
            [self addContentViewModeCenterConstraints];
            break;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"contentInset"]) {
        UIEdgeInsets edgeInsets = [[change valueForKey:@"new"] UIEdgeInsetsValue];
        
        // If scroll view we need to fix inset (TableView has parallax view in table view header)
        self.originalTopInset = edgeInsets.top - ((!self.isInsideTableView) ? self.originalHeight : 0);
        
        switch (self.headerMode) {
            case VGParallaxHeaderModeFill:
                self.insetAwarePositionConstraint.constant = self.originalTopInset / 2;
                self.insetAwareSizeConstraint.constant = -self.originalTopInset;
                break;
            case VGParallaxHeaderModeTop:
                self.insetAwarePositionConstraint.constant = self.originalTopInset;
                break;
            case VGParallaxHeaderModeTopFill:
                self.insetAwarePositionConstraint.constant = self.originalTopInset;
                self.insetAwareSizeConstraint.constant = -self.originalTopInset;
                break;
            case VGParallaxHeaderModeCenter:
            default:
                self.insetAwarePositionConstraint.constant = self.originalTopInset / 2;
                break;
        }
        
        if(!self.isInsideTableView) {
            self.scrollView.contentOffset = CGPointMake(0, -self.scrollView.contentInset.top);
        }
    }
}

- (void)addContentViewModeFillConstraints
{
    [self.contentView autoPinEdgeToSuperviewEdge:ALEdgeLeft
                                       withInset:0];
    [self.contentView autoPinEdgeToSuperviewEdge:ALEdgeRight
                                       withInset:0];
    
    self.insetAwarePositionConstraint = [self.contentView autoAlignAxis:ALAxisHorizontal
                                                       toSameAxisOfView:self.containerView
                                                             withOffset:self.originalTopInset/2];
    
    NSLayoutConstraint *constraint = [self.contentView autoSetDimension:ALDimensionHeight
                                                                 toSize:self.originalHeight
                                                               relation:NSLayoutRelationGreaterThanOrEqual];
    constraint.priority = UILayoutPriorityRequired;
    
    self.insetAwareSizeConstraint = [self.contentView autoMatchDimension:ALDimensionHeight
                                                             toDimension:ALDimensionHeight
                                                                  ofView:self.containerView
                                                              withOffset:-self.originalTopInset];
    self.insetAwareSizeConstraint.priority = UILayoutPriorityDefaultHigh;
}

- (void)addContentViewModeTopConstraints
{
    NSArray *array = [self.contentView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(self.originalTopInset, 0, 0, 0)
                                                                excludingEdge:ALEdgeBottom];
    self.insetAwarePositionConstraint = [array firstObject];
    
    [self.contentView autoSetDimension:ALDimensionHeight
                                toSize:self.originalHeight];
}

- (void)addContentViewModeTopFillConstraints
{
    NSArray *array = [self.contentView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(self.originalTopInset, 0, 0, 0)
                                                                excludingEdge:ALEdgeBottom];
    self.insetAwarePositionConstraint = [array firstObject];
    
    NSLayoutConstraint *constraint = [self.contentView autoSetDimension:ALDimensionHeight
                                                                 toSize:self.originalHeight
                                                               relation:NSLayoutRelationGreaterThanOrEqual];
    constraint.priority = UILayoutPriorityRequired;
    
    self.insetAwareSizeConstraint = [self.contentView autoMatchDimension:ALDimensionHeight
                                                             toDimension:ALDimensionHeight
                                                                  ofView:self.containerView
                                                              withOffset:-self.originalTopInset];
    self.insetAwareSizeConstraint.priority = UILayoutPriorityDefaultHigh;
}

- (void)addContentViewModeCenterConstraints
{
    [self.contentView autoPinEdgeToSuperviewEdge:ALEdgeLeft
                                       withInset:0];
    [self.contentView autoPinEdgeToSuperviewEdge:ALEdgeRight
                                       withInset:0];
    [self.contentView autoSetDimension:ALDimensionHeight
                                toSize:self.originalHeight];
    
    self.insetAwarePositionConstraint = [self.contentView autoAlignAxis:ALAxisHorizontal
                                                       toSameAxisOfView:self.containerView
                                                             withOffset:self.originalTopInset/2];
}

- (void)addShadowView
{
    CGFloat shadowHeight = 30;
    
    UIImage *shadowImage = [self shadowViewImageWithHeight:shadowHeight];
    UIImageView *shadowView = [[UIImageView alloc] initWithImage:shadowImage];
    
    shadowView.contentMode = UIViewContentModeScaleToFill;
    shadowView.translatesAutoresizingMaskIntoConstraints = NO;
    shadowView.alpha = 0;
    
    
    [self addSubview:shadowView];
    
    [shadowView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero
                                         excludingEdge:ALEdgeTop];
    [shadowView autoSetDimension:ALDimensionHeight
                          toSize:shadowHeight];
    
    self.shadowView = shadowView;
}

- (UIImage*)shadowViewImageWithHeight:(CGFloat)height
{
    CGSize size = CGSizeMake(CGRectGetWidth(self.bounds), height);
    // Begin Context
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    //// Gradient Declarations
    NSArray* gradient3Colors = [NSArray arrayWithObjects:
                                (id)[UIColor colorWithWhite:0 alpha:0.3].CGColor,
                                (id)[UIColor clearColor].CGColor, nil];
    CGFloat gradient3Locations[] = {0, 1};
    CGGradientRef gradient3 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradient3Colors, gradient3Locations);
    
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: (CGRect) {CGPointZero, size} ];
    CGContextSaveGState(context);
    [rectanglePath addClip];
    CGContextDrawLinearGradient(context, gradient3, CGPointMake(0, size.height), CGPointMake(0, 0), 0);
    CGContextRestoreGState(context);
    
    //// Cleanup
    CGGradientRelease(gradient3);
    CGColorSpaceRelease(colorSpace);
    
    UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return gradientImage;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (self.superview && newSuperview == nil) {
        [self.superview removeObserver:self
                            forKeyPath:@"contentInset"];
    }
}

@end
