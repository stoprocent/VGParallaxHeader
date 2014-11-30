//
//  ThirdTableViewController.m
//  Example
//
//  Created by Marek Serafin on 30/11/14.
//  Copyright (c) 2014 Marek Serafin. All rights reserved.
//

#import "ThirdTableViewController.h"
#import "HeaderView.h"

@interface ThirdTableViewController ()
@property (nonatomic, strong) HeaderView *headerView;
@end

@implementation ThirdTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.headerView = [HeaderView instantiateFromNib];
    self.headerView.backgroundColor = [UIColor colorWithRed:0.59 green:0.85 blue:0.27 alpha:1];
    
    [self.tableView setParallaxHeaderView:self.headerView
                                     mode:VGParallaxHeaderModeTopFill
                                   height:200];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableView shouldPositionParallaxHeader];
    
    // Log Parallax Progress
    //NSLog(@"Progress: %f", scrollView.parallaxHeader.progress);
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
