//
//  SecondTableViewController.m
//  Example
//
//  Created by Marek Serafin on 26/09/14.
//  Copyright (c) 2014 Marek Serafin. All rights reserved.
//

#import "SecondTableViewController.h"
#import "HeaderView.h"
#import "UIColor+CrossFade.h"

@interface SecondTableViewController ()
@property (nonatomic, strong) HeaderView *headerView;
@end

@implementation SecondTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headerView = [HeaderView instantiateFromNib];
    self.headerView.backgroundColor = [UIColor colorWithRed:0.59 green:0.85 blue:0.27 alpha:1];
    
    [self.tableView setParallaxHeaderView:self.headerView
                                     mode:VGParallaxHeaderModeTopFill
                                   height:200
                          shadowBehaviour:VGParallaxHeaderShadowBehaviourHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableView shouldPositionParallaxHeader];
    
    CGFloat ratio = fmaxf(0, scrollView.parallaxHeader.progress - 1);
    self.headerView.backgroundColor = [UIColor colorForFadeBetweenFirstColor:[UIColor colorWithRed:0.59 green:0.85 blue:0.27 alpha:1]
                                                                 secondColor:[UIColor colorWithRed:0.86 green:0.09 blue:0.13 alpha:1]
                                                                     atRatio:ratio];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"Row %@", @(indexPath.row)];
    
    return cell;
}

@end
