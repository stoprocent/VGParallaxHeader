//
//  FirstViewController.m
//  Example
//
//  Created by Marek Serafin on 26/09/14.
//  Copyright (c) 2014 Marek Serafin. All rights reserved.
//

#import "FirstViewController.h"
#import "HeaderView.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, 3000)];
    
    HeaderView *headerView = [HeaderView instantiateFromNib];
    
    [self.scrollView setParallaxHeaderView:headerView
                                      mode:VGParallaxHeaderModeCenter
                                    height:200];
    
    UILabel *stickyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    stickyLabel.backgroundColor = [UIColor colorWithRed:1 green:0.749 blue:0.976 alpha:1];
    stickyLabel.textAlignment = NSTextAlignmentCenter;
    stickyLabel.text = @"Say hello to Sticky View :)";
    
    self.scrollView.parallaxHeader.stickyViewPosition = VGParallaxHeaderStickyViewPositionTop;
    [self.scrollView.parallaxHeader setStickyView:stickyLabel
                                      withHeight:40];
    
    self.scrollView.parallaxHeader.backgroundColor = [UIColor lightGrayColor];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.scrollView shouldPositionParallaxHeader];
}

@end
