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
                                    height:200
                           shadowBehaviour:VGParallaxHeaderShadowBehaviourDisappearing];
    
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
