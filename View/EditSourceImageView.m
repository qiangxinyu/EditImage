//
//  EditSourceImageView.m
//  TestImage
//
//  Created by 中科创奇 on 15/6/17.
//  Copyright (c) 2015年 中科创奇. All rights reserved.
//

#import "EditSourceImageView.h"

@implementation EditSourceImageView

- (instancetype)initWithImage:(UIImage *)image
{
    if ([super initWithImage:image]) {
        
        self.contentMode = UIViewContentModeScaleAspectFit;
        
        if (image.size.width /image.size.height < kWidth/kHeight) {
            self.frame = CGRectMake(0, 0,  kWidth, image.size.height / (image.size.width / kWidth));
        }else{
            self.frame = CGRectMake(0, 0, image.size.width / (image.size.height / kHeight), kHeight);
        }
    
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

@end
