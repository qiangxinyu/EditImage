//
//  CollectionViewController.m
//  aaaa
//
//  Created by 中科创奇 on 15/6/15.
//  Copyright (c) 2015年 中科创奇. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionViewCell.h"


#import "UIImage+Utility.h"

@interface CollectionViewController () <UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)NSArray * groupArray;
@property (nonatomic,strong)NSArray * nameArray;
@property (nonatomic,strong)NSMutableArray * imageArray;
@property (nonatomic,strong)NSMutableArray * boolArray;
@property (nonatomic,assign)BOOL isFirst;
@end



@implementation CollectionViewController
static NSString * const reuseIdentifier = @"Cell";


- (void)selecet
{
    CollectionViewCell * cell1 = (CollectionViewCell *)[self.collectionView cellForItemAtIndexPath:self.indexPath];
    [cell1 unSelect];
    
    
    
    CollectionViewCell * cell = (CollectionViewCell *)[self.collectionView cellForItemAtIndexPath:self.oldIndexPath];
    [cell select];
    
    
    self.indexPath = self.oldIndexPath;
}


- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout image:(UIImage *)image;
{
    if ([super initWithCollectionViewLayout:layout]) {
        self.image = image;
        self.indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        self.isFirst = YES;
        
        [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
        
        self.smallImage = [self.image aspectFill:CGSizeMake(50, 50)];
        
        self.groupArray = @[@"原图",@"优格",@"暗角",@"淡雅",@"丽日",@"暖调",@"复古",@"明媚",@"日系",@"白露",@"灰调",@"黑白",@"回忆",@"底片"];
        self.imageArray = @[self.image].mutableCopy;
        
        self.nameArray  = @[
                            @"Original",
                            @"CISRGBToneCurveToLinear",
                            @"CIVignetteEffect",
                            @"CIPhotoEffectInstant",
                            @"CIPhotoEffectProcess",
                            @"CIPhotoEffectTransfer",
                            @"CISepiaTone",
                            @"CIPhotoEffectChrome",
                            @"CIPhotoEffectFade",
                            @"CILinearToSRGBToneCurve",
                            @"CIPhotoEffectTonal",
                            @"CIPhotoEffectNoir",
                            @"CIPhotoEffectMono",
                            @"CIColorInvert",
                            ];
        
        self.boolArray = @[].mutableCopy;
        __block NSInteger index = 0;
        for (id objec in self.nameArray) {
            [objec class];
            if (!index) {
                [self.boolArray addObject:@1];
            } else {
                [self.boolArray addObject:@0];
            }
            index ++;
        }
        
        index = 0;
        __block CollectionViewController * weakSelf = self;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            for (NSString * name in weakSelf.nameArray) {
                UIImage *iconImage = [weakSelf.image filteredWithFilterName:name];
                [weakSelf.imageArray addObject:iconImage];
                weakSelf.boolArray[index] = @1;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.collectionView reloadData];
                });
                index ++;
            }
            
        });
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.groupArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    
    cell.label.text = self.groupArray[indexPath.row];
    cell.isEndLoading = [self.boolArray[indexPath.row] boolValue];
    if ((self.isFirst && !indexPath.row) || [self.indexPath isEqual:indexPath]) {
        [cell select];
        self.isFirst = NO;
    } else {
        [cell unSelect];
    }
    
    if (indexPath.row < self.imageArray.count) {
        [cell setImage:self.imageArray[indexPath.row]];
    } else {
        [cell setImage:nil];
    }
   
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(60, 80);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell * cell1 = (CollectionViewCell *)[collectionView cellForItemAtIndexPath:self.indexPath];
    [cell1 unSelect];
    
    cell1 = (CollectionViewCell *)[collectionView cellForItemAtIndexPath:self.oldIndexPath];
    [cell1 unSelect];

    
    
    CollectionViewCell * cell = (CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell select];
    
    
    
    self.indexPath = indexPath;
    
    if ([self.delegate respondsToSelector:@selector(CollectionViewController:image:filteredName:)]) {
        [self.delegate CollectionViewController:self image:self.image filteredName:self.nameArray[indexPath.row]];
    }
   
}



@end
