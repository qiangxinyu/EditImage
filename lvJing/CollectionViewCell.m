//
//  CollectionViewCell.m
//  aaaa
//
//  Created by 中科创奇 on 15/6/15.
//  Copyright (c) 2015年 中科创奇. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)select
{
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor orangeColor].CGColor;
    self.layer.borderWidth = 1;
    
}

- (void)unSelect
{
    self.layer.borderWidth = 0;
}
- (void)setImage:(UIImage *)image
{
    if (image) {
        self.isEndLoading = YES;
    }
    self.imageView.image = image;
}

- (void)setIsEndLoading:(BOOL)isEndLoading
{
    _isEndLoading = isEndLoading;
    self.activeIV.hidden = isEndLoading;
}


@end
