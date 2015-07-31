//
//  Frind.m
//  UITableView2
//
//  Created by qianfeng on 15-1-30.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "Frind.h"

@implementation Frind
-(void)dealloc
{
    [_imageName release];
    [_name release];
    [super dealloc];
}
@end
