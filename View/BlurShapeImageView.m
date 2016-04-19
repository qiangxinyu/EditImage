//
//  BlurShapeImageView.m
//  TestImage
//
//  Created by 中科创奇 on 15/6/18.
//  Copyright (c) 2015年 中科创奇. All rights reserved.
//

#import "BlurShapeImageView.h"

@implementation BlurShapeImageView

- (void)addTarget:(id)target action:(SEL)action
{
    self.userInteractionEnabled = YES;
    _target = target;
    _action = action;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [_target performSelector:_action withObject:self];
#pragma clang diagnostic pop
   
}

- (void)unSelect
{
    NSString * imageName = @"normalblur_btn_nor";
    switch (self.tag - 1300) {
        case 1:
        {
            imageName = @"circleblur_btn_nor";
            break;
        }
        case 2:
        {
            imageName = @"lineblur_btn_nor";
            break;
        }
    }
    self.image = [UIImage imageNamed:imageName];
}

- (void)select
{
    NSString * imageName = @"normalblur_btn_high";
    switch (self.tag - 1300) {
        case 1:
        {
            imageName = @"circleblur_btn_high";
            break;
        }
        case 2:
        {
            imageName = @"lineblur_btn_high";
            break;
        }
    }
    self.image = [UIImage imageNamed:imageName];
}
@end
