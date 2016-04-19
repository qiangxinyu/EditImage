//
//  CollectionViewController.h
//  aaaa
//
//  Created by 中科创奇 on 15/6/15.
//  Copyright (c) 2015年 中科创奇. All rights reserved.
//
#import <UIKit/UIKit.h>
@class CollectionViewController;
@protocol CollectionViewControllerDelegate <NSObject>

- (void)CollectionViewController:(CollectionViewController *)CollectionViewController
                           image:(UIImage *)image
                    filteredName:(NSString *)filteredName;

@end

@interface CollectionViewController : UICollectionViewController
@property (nonatomic,strong)UIImage * image;
@property (nonatomic,strong)UIImage * smallImage;
@property (nonatomic,strong)NSIndexPath * indexPath;
@property (nonatomic,strong)NSIndexPath * oldIndexPath;

@property (nonatomic,assign)id<CollectionViewControllerDelegate> delegate;

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout image:(UIImage *)image;
- (void)selecet;
@end
