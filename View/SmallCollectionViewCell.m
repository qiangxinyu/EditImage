//
//  SmallCollectionViewCell.m
//  testpicture
//
//  Created by 中科创奇 on 15/6/11.
//  Copyright (c) 2015年 中科创奇. All rights reserved.
//

#import "SmallCollectionViewCell.h"


@interface SmallCollectionViewCell () 

@property (nonatomic,strong)UIView * clickDeleteView;
@end



@implementation SmallCollectionViewCell

- (void)awakeFromNib {
     [self shakeWithRotation:M_PI/100];
}
- (void)shakeWithRotation:(CGFloat)rotation
{
    [UIView animateWithDuration:.1 animations:^{
        self.downView.transform = CGAffineTransformMakeRotation(rotation);
    } completion:^(BOOL finished) {
        [self shakeWithRotation:-rotation];
        
    }];
}
- (void)delegateCell:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(SmallCollectionViewCell:deleteWithIndexPath:)]) {
        [self.delegate SmallCollectionViewCell:self deleteWithIndexPath:self.indexPath];
    }
}





#pragma mark -------------------------------------------------------------------------
#pragma mark ---------------------------选中和取消选中--------------------------------------
#pragma mark -------------------------------------------------------------------------
- (void)select
{
    
    
    self.backgroudView.backgroundColor = [UIColor orangeColor];

    [self.downView addSubview:self.delegateImageView];
    
    [self.upView addSubview:self.clickDeleteView];
    
}
- (void)unSelect
{
    self.backgroudView.backgroundColor = [UIColor clearColor];
    [_delegateImageView removeFromSuperview];
    [_clickDeleteView removeFromSuperview];
}




#pragma mark -------------------------------------------------------------------------
#pragma mark ---------------------------懒加载--------------------------------------
#pragma mark -------------------------------------------------------------------------
- (UIImageView *)delegateImageView
{
    if (!_delegateImageView) {
        _delegateImageView= [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 15, 15)];
        _delegateImageView.center = CGPointMake(10, 10);
        _delegateImageView.image = [UIImage imageNamed:@"changepage_delete_btn"];

    }

    return _delegateImageView;
}


- (UIView *)clickDeleteView
{
    if (!_clickDeleteView) {
        _clickDeleteView = [[UIView alloc]initWithFrame:self.delegateImageView.frame];
        _clickDeleteView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(delegateCell:)];
        [_clickDeleteView addGestureRecognizer:tap];
    
    }
    return _clickDeleteView;
}

@end
