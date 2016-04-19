//
//  SureOrCancleView.m
//  TestImage
//
//  Created by 中科创奇 on 15/6/18.
//  Copyright (c) 2015年 中科创奇. All rights reserved.
//

#import "SureOrCancleView.h"

@implementation SureOrCancleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        self.cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancleBtn.frame = CGRectMake(15, 5, 30, 22.5);
        [_cancleBtn setBackgroundImage:[UIImage imageNamed:@"cancel_btn_nor"] forState:UIControlStateNormal];
        [self addSubview:_cancleBtn];
        
        
        self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.frame = CGRectMake(frame.size.width - 45, 5, 30, 22.5);
        [_sureBtn setBackgroundImage:[UIImage imageNamed:@"save_btn_nor"] forState:UIControlStateNormal];
        [self addSubview:_sureBtn];
        
        
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        _nameLabel.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor whiteColor];
        [self addSubview:_nameLabel];
        
    }
    return self;
}

@end
