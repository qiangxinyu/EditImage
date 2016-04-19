//
//  EditScrollView.m
//  TestImage
//
//  Created by 中科创奇 on 15/6/17.
//  Copyright (c) 2015年 中科创奇. All rights reserved.
//

#import "EditScrollView.h"

@implementation EditScrollView

- (instancetype)init
{
    if([super init])
    {
        self.frame = CGRectMake(0, 0, kWidth, kHeight);
        self.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        self.layer.masksToBounds = NO;

    }
    return self;
}
@end
