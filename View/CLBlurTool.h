//
//  CLBlurTool.h
//
//  Created by sho yakushiji on 2013/10/19.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import "CLImageToolBase.h"

typedef NS_ENUM(NSUInteger, CLBlurType)
{
    kCLBlurTypeNormal = 0,
    kCLBlurTypeCircle,
    kCLBlurTypeBand,
};

@interface CLBlurTool : CLImageToolBase
@property (nonatomic,assign) CGFloat blurSliderValue;
@property (nonatomic,strong)UIImageView * imageView;
@property (nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic,assign)CLBlurType blurType;

- (void)setup;
- (void)sliderDidChange:(UISlider*)slider;

- (void)tappedBlurMenu:(UITapGestureRecognizer*)sender;
@end
