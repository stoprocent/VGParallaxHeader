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

@interface VGParallaxHeader : UIView
@end

@interface UIScrollView (VGParallaxHeader)

@property (nonatomic, strong, readonly) VGParallaxHeader *parallaxHeader;

- (void)setParallaxHeaderView:(UIView *)view
                         mode:(VGParallaxHeaderMode)mode
                       height:(CGFloat)height;

- (void)setParallaxHeaderView:(UIView *)view
                         mode:(VGParallaxHeaderMode)mode
                       height:(CGFloat)height
                       shadow:(BOOL)shadow;

- (void)shouldPositionParallaxHeader;

@end