//
//  AddTemplateCollectionViewController.h
//  testpicture
//
//  Created by 中科创奇 on 15/6/12.
//  Copyright (c) 2015年 中科创奇. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddTemplateCollectionViewController;
@protocol AddTemplateCollectionViewControllerDelegate <NSObject>

- (void)addTemplateCollectionViewController:(AddTemplateCollectionViewController *)addTemplateCollectionViewController selectImageViewAtImageName:(NSString *)imageName;

@end



@interface AddTemplateCollectionViewController : UICollectionViewController

@property (nonatomic,assign)id<AddTemplateCollectionViewControllerDelegate> delegatge;
@end
