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

static char UIScrollViewVGParallaxHeader;
static void *VGParallaxHeaderObserverContext = &VGParallaxHeaderObserverContext;

#pragma mark - VGParallaxHeader (Interface)
@interface VGParallaxHeader ()

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
                       contentView:(UIView *)view
                              mode:(VGParallaxHeaderMode)mode
                            height:(CGFloat)height
                   shadowBehaviour:(VGParallaxHeaderShadowBehaviour)shadowBehaviour;

- (void)updateShadowViewWithProgress:(CGFloat)progress;

@property (nonatomic, assign, readwrite, getter=isInsideTableView) BOOL insideTableView;

@property (nonatomic, assign, readwrite) VGParallaxHeaderMode mode;
@property (nonatomic, assign, readwrite) VGParallaxHeaderShadowBehaviour shadowBehaviour;

@property (nonatomic, strong, readwrite) UIView *containerView;
@property (nonatomic, strong, readwrite) UIView *contentView;
@property (nonatomic, strong, readwrite) UIImageView *shadowView;

@property (nonatomic, weak, readwrite) UIScrollView *scrollView;

@property (nonatomic, readwrite) CGFloat originalTopInset;
@property (nonatomic, readwrite) CGFloat originalHeight;

@property (nonatomic, strong, readwrite) NSLayoutConstraint *insetAwarePositionConstraint;
@property (nonatomic, strong, readwrite) NSLayoutConstraint *insetAwareSizeConstraint;

@property (nonatomic, assign, readwrite) CGFloat progress;

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
                shadowBehaviour:VGParallaxHeaderShadowBehaviourHidden];
}

- (void)setParallaxHeaderView:(UIView *)view
                         mode:(VGParallaxHeaderMode)mode
                       height:(CGFloat)height
              shadowBehaviour:(VGParallaxHeaderShadowBehaviour)shadowBehaviour
{
    // New VGParallaxHeader
    self.parallaxHeader = [[VGParallaxHeader alloc] initWithScrollView:self
                                                           contentView:view
                                                                  mode:mode
                                                                height:height
                                                       shadowBehaviour:shadowBehaviour];
    // Calling this to position everything right
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
           forKeyPath:NSStringFromSelector(@selector(contentInset))
              options:NSKeyValueObservingOptionNew
              context:VGParallaxHeaderObserverContext];
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
    CGFloat height = self.contentOffset.y * -1 + self.parallaxHeader.originalHeight;
    CGFloat scaleProgress = fmaxf(0, (1 - ((self.contentOffset.y + self.parallaxHeader.originalTopInset) / self.parallaxHeader.originalHeight)));
    self.parallaxHeader.progress = scaleProgress;
    
    if (self.contentOffset.y < self.parallaxHeader.originalHeight) {
        // Update Shadow View
        [self.parallaxHeader updateShadowViewWithProgress:fminf(1, scaleProgress)];
        // This is where the magic is happening
        self.parallaxHeader.containerView.frame = CGRectMake(0, self.contentOffset.y, CGRectGetWidth(self.frame), height);
    }
}

- (void)positionScrollViewParallaxHeader
{
    CGFloat height = self.contentOffset.y * -1;
    CGFloat scaleProgress = fmaxf(0, (height / (self.parallaxHeader.originalHeight + self.parallaxHeader.originalTopInset)));
    self.parallaxHeader.progress = scaleProgress;
    
    if (self.contentOffset.y < 0) {
        // Update Shadow View
        [self.parallaxHeader updateShadowViewWithProgress:fminf(1, scaleProgress)];
        // This is where the magic is happening
        self.parallaxHeader.frame = CGRectMake(0, self.contentOffset.y, CGRectGetWidth(self.frame), height);
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
    objc_setAssociatedObject(self, &UIScrollViewVGParallaxHeader, parallaxHeader, OBJC_ASSOCIATION_ASSIGN);
}

- (VGParallaxHeader *)parallaxHeader
{
    return objc_getAssociatedObject(self, &UIScrollViewVGParallaxHeader);
}

@end

#pragma mark - VGParallaxHeader (Implementation)
@implementation VGParallaxHeader

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }
    
    // FIXME: Init with storyboards not yet supported

    return self;
}

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
                       contentView:(UIView *)view
                              mode:(VGParallaxHeaderMode)mode
                            height:(CGFloat)height
                   shadowBehaviour:(VGParallaxHeaderShadowBehaviour)shadowBehaviour
{
    self = [super initWithFrame:CGRectMake(0, 0, CGRectGetWidth(scrollView.bounds), height)];
    if (!self) {
        return nil;
    }
    
    self.mode = mode;
    self.shadowBehaviour = shadowBehaviour;
    
    self.scrollView = scrollView;
    
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
    
    [self addShadowView];
    
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

    // Constraints
    [self setupContentViewMode];
}

- (void)setupContentViewMode
{
    switch (self.mode) {
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
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(contentInset))] && context == VGParallaxHeaderObserverContext) {
        UIEdgeInsets edgeInsets = [[change valueForKey:@"new"] UIEdgeInsetsValue];
        
        // If scroll view we need to fix inset (TableView has parallax view in table view header)
        self.originalTopInset = edgeInsets.top - ((!self.isInsideTableView) ? self.originalHeight : 0);
        
        switch (self.mode) {
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

#pragma mark - VGParallaxHeader (Shadow)
- (void)updateShadowViewWithProgress:(CGFloat)progress
{
    switch (self.shadowBehaviour) {
        case VGParallaxHeaderShadowBehaviourAppearing:
            self.shadowView.alpha = 1 - progress;
            break;
        case VGParallaxHeaderShadowBehaviourDisappearing:
            self.shadowView.alpha = progress;
            break;
        case VGParallaxHeaderShadowBehaviourAlways:
        case VGParallaxHeaderShadowBehaviourHidden:
        default:
            self.shadowView.alpha = 1;
            break;
    }
}

- (void)addShadowView
{
    if (self.shadowBehaviour == VGParallaxHeaderShadowBehaviourHidden) {
        return;
    }
    
    CGFloat shadowHeight = 30;
    
    UIImage *shadowImage = [self shadowViewImageWithHeight:shadowHeight];
    UIImageView *shadowView = [[UIImageView alloc] initWithImage:shadowImage];
    
    shadowView.contentMode = UIViewContentModeScaleToFill;
    shadowView.translatesAutoresizingMaskIntoConstraints = NO;
    shadowView.alpha = (self.shadowBehaviour == VGParallaxHeaderShadowBehaviourDisappearing ? 1 : 0);
    
    // Add Shadow
    [self addSubview:shadowView];
    
    // Constraints
    [shadowView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero
                                         excludingEdge:ALEdgeTop];
    
    [shadowView autoSetDimension:ALDimensionHeight
                          toSize:shadowHeight];
    
    // Set property
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
                            forKeyPath:NSStringFromSelector(@selector(contentInset))
                               context:VGParallaxHeaderObserverContext];
    }
}

@end
