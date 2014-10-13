//
//  FirstTableViewController.m
//  Example
//
//  Created by Marek Serafin on 26/09/14.
//  Copyright (c) 2014 Marek Serafin. All rights reserved.
//

#import "FirstTableViewController.h"
#import "HeaderView.h"

@interface FirstTableViewController ()

@end

@implementation FirstTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    HeaderView *headerView = [HeaderView instantiateFromNib];
    
    [self.tableView setParallaxHeaderView:headerView
                                     mode:VGParallaxHeaderModeFill
                                   height:200
                          shadowBehaviour:VGParallaxHeaderShadowBehaviourAppearing];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableView shouldPositionParallaxHeader];
    // 
    NSLog(@"Progress: %f", scrollView.parallaxHeader.progress);
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
     return [NSString stringWithFormat:@"Section %@", @(section)];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"Row %@", @(indexPath.row)];
    
    return cell;
}

@end
