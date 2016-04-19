//
//  CollectionViewCell.h
//  aaaa
//
//  Created by 中科创奇 on 15/6/15.
//  Copyright (c) 2015年 中科创奇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activeIV;

@property (nonatomic, assign)BOOL isEndLoading;
- (void)select;
- (void)unSelect;

- (void)setImage:(UIImage *)image;
@end
