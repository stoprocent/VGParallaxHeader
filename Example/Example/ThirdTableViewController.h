//
//  ThirdTableViewController.h
//  Example
//
//  Created by Marek Serafin on 30/11/14.
//  Copyright (c) 2014 Marek Serafin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+VGParallaxHeader.h"

@interface ThirdTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end
