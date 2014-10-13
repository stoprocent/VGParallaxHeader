//
//  UIScrollView+VKParallaxHeader.m
//
//  Created by Marek Serafin on 2014-09-18.
//  Copyright (c) 2013 VG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, VGParallaxHeaderMode) {
    VGParallaxHeaderModeCenter = 0,
    VGParallaxHeaderModeFill,
    VGParallaxHeaderModeTop,
    VGParallaxHeaderModeTopFill,
};

typedef NS_ENUM(NSInteger, VGParallaxHeaderShadowBehaviour) {
    VGParallaxHeaderShadowBehaviourHidden = 0,
    VGParallaxHeaderShadowBehaviourAppearing,
    VGParallaxHeaderShadowBehaviourDisappearing,
    VGParallaxHeaderShadowBehaviourAlways,
};

@interface VGParallaxHeader : UIView
@property (nonatomic, assign, readonly) VGParallaxHeaderMode mode;
@property (nonatomic, assign, readonly) VGParallaxHeaderShadowBehaviour shadowBehaviour;
@property (nonatomic, assign, readonly, getter=isInsideTableView) BOOL insideTableView;
@property (nonatomic, assign, readonly) CGFloat progress;
@end

@interface UIScrollView (VGParallaxHeader)

@property (nonatomic, strong, readonly) VGParallaxHeader *parallaxHeader;

- (void)setParallaxHeaderView:(UIView *)view
                         mode:(VGParallaxHeaderMode)mode
                       height:(CGFloat)height;

- (void)setParallaxHeaderView:(UIView *)view
                         mode:(VGParallaxHeaderMode)mode
                       height:(CGFloat)height
              shadowBehaviour:(VGParallaxHeaderShadowBehaviour)shadowBehaviour;

- (void)shouldPositionParallaxHeader;

@end