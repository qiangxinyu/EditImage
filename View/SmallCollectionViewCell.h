//
//  SmallCollectionViewCell.h
//  testpicture
//
//  Created by 中科创奇 on 15/6/11.
//  Copyright (c) 2015年 中科创奇. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SmallCollectionViewCell;
@protocol SmallCollectionViewCellDelegate <NSObject>

/**
 *  删除 cell
 *
 *  @param smallCollectionViewCell
 *  @param indexPath
 */
- (void)SmallCollectionViewCell:(SmallCollectionViewCell *)smallCollectionViewCell deleteWithIndexPath:(NSIndexPath *)indexPath;


@end

@interface SmallCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIView *backgroudView;

@property (nonatomic,strong)UIImageView * delegateImageView;

@property (weak, nonatomic) IBOutlet UIView *downView;
@property (weak, nonatomic) IBOutlet UIView *upView;

@property (nonatomic,strong)NSIndexPath * indexPath;


@property (nonatomic,assign)id<SmallCollectionViewCellDelegate> delegate;



/**
 *  选中
 */
- (void)select;

/**
 *  取消选中
 */
- (void)unSelect;

@end
