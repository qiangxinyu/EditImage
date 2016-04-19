//
//  EditManager.h
//  TestImage
//
//  Created by 中科创奇 on 15/6/17.
//  Copyright (c) 2015年 中科创奇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditScrollView.h"
#import "EditSourceImageView.h"
#import "BackView.h"
#import "HUIGCDDispatchAsync.h"
@class EditManager;
@protocol EditManagerDelegate <NSObject>

- (void)EditManager:(EditManager *)EditManager getImage:(UIImage *)image;

@end



@interface EditManager : NSObject

@property (nonatomic,assign)id<EditManagerDelegate> delegate;

/**
 *  编辑页面的viewController
 */
@property (nonatomic,strong)UIViewController * editImageViewController;
/**
 *  相册页面的 navigationController
 */
@property (nonatomic,strong)UINavigationController * editImageNavigationController;






#pragma mark ------------------底层视图-----------------

/**
 *  编辑的原始图片用的 scrollView
 */
@property (nonatomic,strong)EditScrollView * editScrollView;
/**
 *  编辑的原始图片
 */
@property (nonatomic,strong)EditSourceImageView * editSourceImageView;









#pragma mark ------------------顶层视图-----------------


/**
 *  顶部的view  包含 取消 和确定按钮
 */
@property (nonatomic,strong)UIView * topView;


/**
 *  中间的 view 包含 截图框
 */
@property (nonatomic,strong)BackView * middleView;



/**
 *  底部的view  包含  滤镜 调色  背景虚化
 */
@property (nonatomic,strong)UIView * bottomView;


/**
 *  滤镜
 */
@property (nonatomic,strong)UIView * filterView;


/**
 *  调色
 */
@property (nonatomic,strong)UIView * toningView;

/**
 *  背景虚化
 */
@property (nonatomic,strong)UIView * backgroudEmptinessView;





- (void)layoutSubviews;


@end
