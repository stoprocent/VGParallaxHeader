//
//  HeaderViewWithImage.m
//  Example
//
//  Created by Marek Serafin on 13/10/14.
//  Copyright (c) 2014 Marek Serafin. All rights reserved.
//

#import "HeaderViewWithImage.h"

@implementation HeaderViewWithImage

+ (instancetype)instantiateFromNib
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"%@", [self class]] owner:nil options:nil];
    return [views firstObject];
}

@end
