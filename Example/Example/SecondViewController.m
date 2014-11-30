//
//  SecondViewController.m
//  Example
//
//  Created by Marek Serafin on 26/09/14.
//  Copyright (c) 2014 Marek Serafin. All rights reserved.
//

#import "SecondViewController.h"
#import "HeaderViewWithImage.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    HeaderViewWithImage *headerView = [HeaderViewWithImage instantiateFromNib];
    
    
    [self.scrollView setParallaxHeaderView:headerView
                                      mode:VGParallaxHeaderModeFill
                                    height:230];
    
    
    UILabel *stickyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    stickyLabel.backgroundColor = [UIColor colorWithRed:1 green:0.749 blue:0.976 alpha:1];
    stickyLabel.textAlignment = NSTextAlignmentCenter;
    stickyLabel.text = @"Say hello to Sticky View :)";
    
    self.scrollView.parallaxHeader.stickyViewPosition = VGParallaxHeaderStickyViewPositionBottom;
    [self.scrollView.parallaxHeader setStickyView:stickyLabel
                                      withHeight:40];
    
    
    [self.scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, 3000)];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.scrollView shouldPositionParallaxHeader];

    // This is how you can implement appearing or disappearing of sticky view
    [scrollView.parallaxHeader.stickyView setAlpha:scrollView.parallaxHeader.progress];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}

@end
