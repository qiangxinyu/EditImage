//
//  AddTemplateCollectionViewController.m
//  testpicture
//
//  Created by 中科创奇 on 15/6/12.
//  Copyright (c) 2015年 中科创奇. All rights reserved.
//

#import "AddTemplateCollectionViewController.h"
#import "AddTemplateCollectionViewCell.h"
@interface AddTemplateCollectionViewController () <UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)NSMutableArray * groupArray;
@end

@implementation AddTemplateCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.groupArray = [NSMutableArray array];
    @autoreleasepool {
        
    for (int i = 0 ; i < 10; i ++) {
        if (i == 9) {
            [self.groupArray addObject:@"010.png"];
            break;
        
        }
        
        NSString * imageName = [NSString stringWithFormat:@"00%d",i+1];
        
        UIImage * image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]];
        
        if (!image) {
            [self.groupArray addObject:[imageName stringByAppendingString:@".jpg"]];
        }else
        {
            [self.groupArray addObject:[imageName stringByAppendingString:@".png"]];
        }
        
        
        
    }
    }
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"AddTemplateCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//#warning Incomplete method implementation -- Return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//#warning Incomplete method implementation -- Return the number of items in the section
    return self.groupArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AddTemplateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    cell.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.groupArray[indexPath.row] ofType:@""]];
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenWidth / 3 - 20 ,(kScreenWidth / 3 - 20) * 1.5);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 10, 5, 10);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
     [self dismissViewControllerAnimated:YES completion:nil];
    if ([self.delegatge respondsToSelector:@selector(addTemplateCollectionViewController:selectImageViewAtImageName:)]) {
        [self.delegatge addTemplateCollectionViewController:self selectImageViewAtImageName:self.groupArray[indexPath.row]];
    }
    
   
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
