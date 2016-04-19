//
//  EditManager.m
//  TestImage
//
//  Created by 中科创奇 on 15/6/17.
//  Copyright (c) 2015年 中科创奇. All rights reserved.
//

#import "EditManager.h"
#import "ImaginaryLineView.h"
#import "CollectionViewController.h"
#import "SureOrCancleView.h"
#import "BlurShapeImageView.h"
#import "UIImage+Utility.h"
#import "CLBlurTool.h"

@interface EditManager () <CollectionViewControllerDelegate>

{
    CIFilter * _colorControlsFilter;
    CIContext * _context;
}

@property (nonatomic,assign)CGPoint imageViewOldCenter;

/**
 *  原始图片
 */
@property (nonatomic,strong)UIImage * image;

/**
 *  遮挡
 */
@property (nonatomic,strong)UIView * keepOutView;

/**
 *  滤镜的 collectionView
 */
@property (nonatomic,strong)CollectionViewController * filterCollectionVC;




/**
 *  色调的值
 */
@property (nonatomic,assign)CGFloat liangDu;
@property (nonatomic,assign)CGFloat duiBiDu;
@property (nonatomic,assign)CGFloat baoHeDu;


/**
 *  模糊
 */

@property (nonatomic,strong)CLBlurTool * blurTool;

@property (nonatomic,assign)CGFloat blurValue;

@property (nonatomic, strong)UIActivityIndicatorView * activeIV;

@property (nonatomic, strong)NSOperationQueue * queue;
@property (nonatomic, strong)NSOperation * operation;
@end




@implementation EditManager

- (void)layoutSubviews
{
    [self.editImageViewController.view addSubview:self.topView];
    [self.editImageViewController.view addSubview:self.middleView];
    [self.editImageViewController.view addSubview:self.bottomView];
  

//    self.keepOutView.hidden = YES;
//    self.filterView.hidden = NO;
//    self.backgroudEmptinessView.hidden = NO;
    
}

#pragma mark -------------------------------------------------------------------------
#pragma mark ---------------------------点击方法--------------------------------------
#pragma mark -------------------------------------------------------------------------

/**
 *  取消 和 确定 按钮
 *
 *  @param UIView
 *
 *  @return
 */
- (void)clickTopBtn:(UIButton *)btn
{
    if ([btn.currentTitle isEqualToString:@"取消"]) {
        [self.editImageNavigationController popViewControllerAnimated:YES];
        return;
    }
    [self.editImageViewController dismissViewControllerAnimated:YES completion:nil];

    
    if ([self.delegate respondsToSelector:@selector(EditManager:getImage:)]) {

        CGFloat ratio = self.editSourceImageView.image.size.height / self.editSourceImageView.frame.size.height;
        
        CGRect rect = CGRectMake(self.editScrollView.contentOffset.x * ratio, self.editScrollView.contentOffset.y * ratio, kWidth * ratio, kHeight * ratio);
        
        UIImage * image = [self.editSourceImageView.image crop:rect];

        
        
        [self.delegate EditManager:self getImage:image];
    }
    
}


/**
 *  点击 底部 图片
 */
- (void)clcikBottomBtn:(UIButton *)btn
{
    
    self.middleView.hidden = YES;
    self.topView.hidden = YES;
    
    self.keepOutView.hidden = NO;
    
    self.editScrollView.contentOffset = CGPointMake(0, 0);
    self.editSourceImageView.center = CGPointMake(self.editScrollView.frame.size.width/2, self.editScrollView.frame.size.height/2-50.0/480*kScreenHeight);
    
    [UIView animateWithDuration:.5 animations:^{
        self.bottomView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 70);
    } completion:^(BOOL finished) {
        
        switch (btn.tag - 1000) {
            case 0:
            {

                self.filterCollectionVC.oldIndexPath = _filterCollectionVC.indexPath;

                [UIView animateWithDuration:.5 animations:^{
                    self.filterView.frame = CGRectMake(0, kScreenHeight-160, kScreenWidth, 160);
                }];

                break;
            }
            case 1:
            {

                _context = nil;
                _context=[CIContext contextWithOptions:nil];
                _colorControlsFilter = nil;
                _colorControlsFilter=[CIFilter filterWithName:@"CIColorControls"];
                [_colorControlsFilter setValue:[CIImage imageWithCGImage:self.editSourceImageView.image.CGImage] forKey:@"inputImage"];//设置滤镜的输入图片
                
                self.toningView.hidden = NO;
                [UIView animateWithDuration:.5 animations:^{
                    self.toningView.frame = CGRectMake(0, kScreenHeight-160, kScreenWidth, 160);
                }];
                break;
            }case 2:
            {
                self.backgroudEmptinessView.hidden = NO;
                [UIView animateWithDuration:.5 animations:^{
                    self.backgroudEmptinessView.frame = CGRectMake(0, kScreenHeight-160, kScreenWidth, 160);
                }];
                
                self.blurTool.scrollView.hidden = NO;
                break;
            }
                
        }
        
   
        
    }];
    
    
}


/**
 *  点击  X 号
 *
 *  @param btn
 */
- (void)clickBottomCancleBtn:(UIButton *)btn
{
    NSString * text = [(SureOrCancleView *)btn.superview nameLabel].text;
    
    self.editSourceImageView.image = self.image;
    
    if ([text isEqualToString:@"滤镜"]) {
        //返回 原来 选中的
        [_filterCollectionVC selecet];
    }
    
    if ([text isEqualToString:@"色调"]) {
        for (int i = 0; i < 3 ; i ++) {
            UISlider * slider = (UISlider *)[self.toningView viewWithTag:1200 + i];
            if (i == 0) {
                slider.value = self.baoHeDu;
            }
            if (i == 1) {
                slider.value = self.liangDu;
            }
            if (i == 2) {
                slider.value = self.duiBiDu;
            }
        }
    }
    if ([text isEqualToString:@"背景虚化"]) {
        UISlider * slider = (UISlider *)[self.backgroudEmptinessView viewWithTag:1350];
        slider.value = self.blurValue;
    }
    [self hiddenWithText:text];
    
}

/**
 *  点击 √ 号
 *
 *  @param btn
 */
- (void)clickBottomSureBtn:(UIButton *)btn
{
    NSString * text = [(SureOrCancleView *)btn.superview nameLabel].text;
    self.image = self.editSourceImageView.image;

    if ([text isEqualToString:@"滤镜"]) {
    
    }
    if ([text isEqualToString:@"色调"]) {
        for (int i = 0; i < 3 ; i ++) {
            UISlider * slider = (UISlider *)[self.toningView viewWithTag:1200 + i];
            if (i == 0) {
                self.baoHeDu = slider.value;
            }
            if (i == 1) {
                self.liangDu = slider.value;
            }
            if (i == 2) {
                self.duiBiDu = slider.value;
            }
        }
    }
    if ([text isEqualToString:@"背景虚化"]) {
        
        UISlider * slider = (UISlider *)[self.backgroudEmptinessView viewWithTag:1350];
        self.blurValue = slider.value;

    }
    [self hiddenWithText:text];
}

/**
 *  显示 顶部和中间 的view  隐藏  遮挡 和调节的 view
 *
 *  @param text
 */
- (void)hiddenWithText:(NSString *)text
{
    self.topView.hidden = NO;
    self.middleView.hidden = NO;
    self.keepOutView.hidden = YES;
    self.editSourceImageView.center = self.imageViewOldCenter;
    
    
    [UIView animateWithDuration:.5 animations:^{
        if ([text isEqualToString:@"滤镜"]) {
            
            self.filterView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 160);
        }
        
        if ([text isEqualToString:@"色调"]) {
            
            self.toningView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 160);
        }
        
        if ([text isEqualToString:@"背景虚化"]) {
            
            self.backgroudEmptinessView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 160);
            self.blurTool.scrollView.hidden = YES;    
        }
    } completion:^(BOOL finished) {
        [self appearBottomView];
    }];
    
}

/**
 *  显示 底部 view
 */
- (void)appearBottomView
{
    [UIView animateWithDuration:.5 animations:^{
        self.bottomView.frame = CGRectMake(0, kScreenHeight-self.bottomView.frame.size.height, kScreenWidth, self.bottomView.frame.size.height);
    }];
}


/**
 *  点击 模糊 形状
 *
 *  @param imageView
 */
- (void)clickBlurShapeImageView:(BlurShapeImageView *)imageView
{
    for (int i = 0 ; i < 3 ; i ++) {
        BlurShapeImageView * blur = (BlurShapeImageView *)[imageView.superview viewWithTag:1300 + i];
        [blur unSelect];
    }
    [imageView select];
    
    
    self.blurTool.blurType =  imageView.tag - 1300;
    [self.blurTool tappedBlurMenu:nil];

}



#pragma mark -------------------------------------------------------------------------
#pragma mark ---------------------------sliderChangeValue--------------------------------------
#pragma mark -------------------------------------------------------------------------
/**
 *  调整 色调
 *
 *  @param slider
 */
-(void)changeValue:(UISlider *)slider
{
    if (!self.queue) {
        self.queue = [[NSOperationQueue alloc] init];
        
    }
    WeakSelf(weakSelf);

    [self.operation cancel];
    self.operation = [[NSOperation alloc] init];
    [self.operation setCompletionBlock:^{
        UIImage *image = [weakSelf filteredImage:weakSelf.image];
        [weakSelf.editSourceImageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
    }];
    
    [self.queue addOperation:self.operation];
    
//    [self.queue addOperationWithBlock:^{
//       
//    }];
}


/**
 *  改变 模糊度
 *
 *  @return
 */

- (void)changeBlurValue:(UISlider *)slider
{
    self.blurTool.blurSliderValue = slider.value;
    [self.blurTool sliderDidChange:slider];
}

#pragma mark -------------------------------------------------------------------------
#pragma mark ---------------------------collectionDelegate--------------------------------------
#pragma mark -------------------------------------------------------------------------

- (void)CollectionViewController:(CollectionViewController *)CollectionViewController image:(UIImage *)image filteredName:(NSString *)filteredName
{
    WeakSelf(weakSelf);
    [self.activeIV startAnimating];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage * filteredImage = [image filteredWithFilterName:filteredName];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.activeIV stopAnimating];
            weakSelf.editSourceImageView.image = filteredImage;
        });
    });
}

#pragma mark -------------------------------------------------------------------------
#pragma mark ---------------------------懒加载--------------------------------------
#pragma mark -------------------------------------------------------------------------
/**
 *  顶部的view  包含 取消 和确定按钮
 */
- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)];
        _topView.backgroundColor = [UIColor blackColor];
        
        NSArray * array = @[@"取消",@"确定"];
     
        for (int i = 0 ; i < 2 ; i ++) {
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
            [btn setTitle:array[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.frame = CGRectMake(10 + (kScreenWidth - 60)*i, 25, 40, 20);
            [btn addTarget:self action:@selector(clickTopBtn:) forControlEvents:UIControlEventTouchUpInside];
            [_topView addSubview:btn];
        }
    }
    return _topView;
}

/**
 *  中间的 view 包含 截图框
 */
- (BackView *)middleView
{
    if (!_middleView) {
        _middleView = [[BackView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), kScreenWidth , kScreenHeight - 70 - 70)];
        
        ImaginaryLineView * redView = [[ImaginaryLineView alloc]initWithFrame:CGRectMake(0, 0,kWidth, kHeight)];
        redView.backgroundColor = [UIColor clearColor];
        redView.center = CGPointMake(kScreenWidth/2, self.middleView.frame.size.height/2);
        [_middleView addSubview:redView];
        
        /**
         *  上下2个红色的框
         */
        for (int i = 0 ; i < 2 ; i ++) {
            UIView * view = [[ImaginaryLineView alloc]initWithFrame:CGRectMake(0, (redView.frame.size.height-40) * i, redView.frame.size.width, 40)];
            view.backgroundColor = [UIColor clearColor];
            [redView addSubview:view];
            
            
            UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
            view1.backgroundColor = [UIColor redColor];
            view1.alpha = .4;
            [view addSubview:view1];
            
        }
        
        /**
         *  上下的黑色半透明
         */
        for (int i = 0 ; i < 2 ; i ++) {
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                                    (_middleView.frame.size.height-(_middleView.frame.size.height - redView.frame.size.height)/2) * i,
                                                                    kScreenWidth,
                                                                    (_middleView.frame.size.height - redView.frame.size.height)/2)];
            
            view.backgroundColor = [UIColor blackColor];
            view.alpha = .7;
            [self.middleView addSubview:view];
        }
        
        /**
         *  左右的黑色半透明
         */
        for (int i = 0 ; i < 2 ; i ++) {
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake((_middleView.frame.size.width-(_middleView.frame.size.width - redView.frame.size.width)/2) * i,
                                                                    (_middleView.frame.size.height - redView.frame.size.height)/2,
                                                                    
                                                                    (_middleView.frame.size.width - redView.frame.size.width)/2,
                                                                    
                                                                    _middleView.frame.size.height-(_middleView.frame.size.height - redView.frame.size.height))];
            
            view.backgroundColor = [UIColor blackColor];
            view.alpha = .7;
            [self.middleView addSubview:view];
        }
        
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 168.5, 57)];
        imageView.image = [UIImage imageNamed:@"cropImagTips-568"];
        imageView.center = CGPointMake(_middleView.frame.size.width/2, 20);
        [_middleView addSubview:imageView];
    }
    return _middleView;
}

/**
 *  底部的view  包含  滤镜 调色  背景虚化
 */
- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 70, kScreenWidth, 70)];
        _bottomView.backgroundColor = [UIColor blackColor];
        
        
        NSArray * imageArray = @[@"filter_btn",@"adjustment_btn",@"blur_btn"];
        
        for (int i = 0 ; i < 3 ; i ++) {
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, 38, 42);
            btn.center =  CGPointMake(kScreenWidth/2 * i + (kScreenWidth/10 * (1-i)), 40);
            
            [btn setBackgroundImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
            btn.tag = 1000+i;
            [btn addTarget:self action:@selector(clcikBottomBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.bottomView addSubview:btn];
            
        }
    }
    return _bottomView;
}

/**
 *  遮挡
 *
 *  @return
 */

- (UIView *)keepOutView
{
    if (!_keepOutView) {
        
        _keepOutView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 80)];
        _keepOutView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2- 50.0/480*kScreenHeight);
        _keepOutView.hidden = YES;
        
        for (int i = 0 ; i < 2 ; i ++) {
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0,( _keepOutView.frame.size.height - 120) * i, kScreenWidth, 120)];
            view.backgroundColor = [UIColor blackColor];
            [_keepOutView addSubview:view];
        }
        
        [self.editImageViewController.view addSubview:_keepOutView];
        
    }
    return _keepOutView;
}

/**
 *  滤镜
 *
 *  @return
 */
- (UIView *)filterView
{
    if (!_filterView) {
        
        _filterView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 160)];
        _filterView.backgroundColor = [UIColor blackColor];
        [self.editImageViewController.view addSubview:_filterView];
        
        
        SureOrCancleView * sureOrCalale = [[SureOrCancleView alloc]initWithFrame:CGRectMake(0, 120, kScreenWidth, 40)];
        sureOrCalale.nameLabel.text = @"滤镜";
        [sureOrCalale.cancleBtn addTarget:self action:@selector(clickBottomCancleBtn:) forControlEvents:UIControlEventTouchUpInside];
        [sureOrCalale.sureBtn addTarget:self action:@selector(clickBottomSureBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [_filterView addSubview:sureOrCalale];
        [_filterView addSubview:self.filterCollectionVC.collectionView];

        
    }
    return _filterView;
}



/**
 *  滤镜的 collectionView
 *
 *  @return
 */
- (CollectionViewController *)filterCollectionVC
{
    if (!_filterCollectionVC) {
        
   
        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _filterCollectionVC = [[CollectionViewController alloc]initWithCollectionViewLayout:layout image:self.image];
        _filterCollectionVC.collectionView.frame = CGRectMake(0, 0, kScreenWidth, 120);
        _filterCollectionVC.delegate =self;
        
    }
    return _filterCollectionVC;
}

/**
 *  调色
 */
- (UIView *)toningView
{
    if (!_toningView) {
        
        _toningView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 160)];
        _toningView.backgroundColor = [UIColor blackColor];
        [self.editImageViewController.view addSubview:_toningView];
        
        
        
        NSArray * array = @[@"饱和度",@"亮度",@"对比度"];
        
        for (int i = 0 ; i < 3 ; i ++) {
            
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(20, 20 + 33 * i, 40, 30)];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:10];
            label.text = array[i];
            [_toningView addSubview:label];
            
            
            UISlider * slider = [[UISlider alloc]initWithFrame:CGRectMake(70, 20 + 33 * i, kScreenWidth - 40 - 50, 30)];
            slider.tag = 1200 + i;
            [slider addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
            if (i == 0) {
                slider.minimumValue = 0;
                slider.maximumValue = 2;
                slider.value = 1;
                self.baoHeDu = slider.value;
                
            }
            if (i == 2) {
                slider.minimumValue = .5;
                slider.maximumValue = 1.5;
                slider.value = 1;
          
                self.duiBiDu = slider.value;
            }
            if (i == 1) {
                slider.minimumValue = -1;
                slider.maximumValue = 1;
                slider.value = 0;
                self.liangDu = slider.value;
            }
            
            
            [_toningView addSubview:slider];
        }
        
        SureOrCancleView * sureOrCalale = [[SureOrCancleView alloc]initWithFrame:CGRectMake(0, 120, kScreenWidth, 40)];
        sureOrCalale.nameLabel.text = @"色调";
        [sureOrCalale.cancleBtn addTarget:self action:@selector(clickBottomCancleBtn:) forControlEvents:UIControlEventTouchUpInside];
        [sureOrCalale.sureBtn addTarget:self action:@selector(clickBottomSureBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [_toningView addSubview:sureOrCalale];
        
    }
    return _toningView;
}

/**
 *  背景虚化
 */

- (UIView *)backgroudEmptinessView
{
    if (!_backgroudEmptinessView) {
        _backgroudEmptinessView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 160)];
        _backgroudEmptinessView.backgroundColor = [UIColor blackColor];
        [self.editImageViewController.view addSubview:_backgroudEmptinessView];
        
        
        
        
        UISlider * slider = [[UISlider alloc]initWithFrame:CGRectMake(30, 5, kScreenWidth - 60, 30)];
        [slider addTarget:self action:@selector(changeBlurValue:) forControlEvents:UIControlEventValueChanged];
        slider.value = 0;
        slider.minimumValue = 0;
        slider.maximumValue = 1;
        slider.tag = 1350;
        [_backgroudEmptinessView addSubview:slider];
        
        
        NSArray * imageNames = @[@"normalblur_btn_high",@"circleblur_btn_nor",@"lineblur_btn_nor"];
        for (int i = 0 ; i < 3 ; i ++) {
            BlurShapeImageView * blurShapeImageView = [[BlurShapeImageView alloc]initWithFrame:CGRectMake(0, 0, 52, 16)];
            blurShapeImageView.center = CGPointMake(kScreenWidth/6 * (i * 2 + 1) , 75);
            blurShapeImageView.tag = 1300 + i;
            blurShapeImageView.image = [UIImage imageNamed:imageNames[i]];
            
            [blurShapeImageView addTarget:self action:@selector(clickBlurShapeImageView:)];
            [_backgroudEmptinessView addSubview:blurShapeImageView];
        }
        
        
        
        
        SureOrCancleView * sureOrCalale = [[SureOrCancleView alloc]initWithFrame:CGRectMake(0, 120, kScreenWidth, 40)];
        sureOrCalale.nameLabel.text = @"背景虚化";
        [sureOrCalale.cancleBtn addTarget:self action:@selector(clickBottomCancleBtn:) forControlEvents:UIControlEventTouchUpInside];
        [sureOrCalale.sureBtn addTarget:self action:@selector(clickBottomSureBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [_backgroudEmptinessView addSubview:sureOrCalale];
        
        
        self.blurTool = [[CLBlurTool alloc]init];
        _blurTool.imageView = self.editSourceImageView;
        _blurTool.scrollView = [[UIScrollView alloc]initWithFrame:self.editSourceImageView.frame];
        
        _blurTool.scrollView.center = CGPointMake(self.keepOutView.frame.size.width/2, self.keepOutView.frame.size.height/2);
        
        [self.keepOutView addSubview:_blurTool.scrollView];
        [self.blurTool setup];
        
        
    }
    return _backgroudEmptinessView;
}
#pragma mark -------------------------------------------------------------------------
#pragma mark ---------------------------getter--------------------------------------
#pragma mark -------------------------------------------------------------------------
/**
 *  编辑的原始 图片
 *
 *  @param editSourceImageView 
 */
- (void)setEditSourceImageView:(EditSourceImageView *)editSourceImageView
{
    _editSourceImageView = editSourceImageView;
    self.imageViewOldCenter = editSourceImageView.center;

    self.image = editSourceImageView.image;
    
    [self.editImageViewController.view addSubview:_editScrollView];
    self.editScrollView.contentSize = CGSizeMake(self.editSourceImageView.frame.size.width+.1, self.editSourceImageView.frame.size.height+.5);
    
    [self.editScrollView addSubview:self.editSourceImageView];
    
}



#pragma mark -------------------------------------------------------------------------
#pragma mark ---------------------------处理图片--------------------------------------
#pragma mark -------------------------------------------------------------------------

/**
 *  色调
 *
 *  @param image
 *
 *  @return
 */
- (UIImage*)filteredImage:(UIImage*)image
{
    
    UISlider * baoHeDuSlider = (UISlider *)[self.toningView viewWithTag:1200];
    UISlider * liangDuSlider = (UISlider *)[self.toningView viewWithTag:1201];
    UISlider * duiBiDuSlider = (UISlider *)[self.toningView viewWithTag:1202];
    
    
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, ciImage, nil];
    
    [filter setDefaults];
    [filter setValue:[NSNumber numberWithFloat:baoHeDuSlider.value] forKey:@"inputSaturation"];
    
    filter = [CIFilter filterWithName:@"CIExposureAdjust" keysAndValues:kCIInputImageKey, [filter outputImage], nil];
    [filter setDefaults];
    CGFloat brightness = 2 * liangDuSlider.value;
    [filter setValue:[NSNumber numberWithFloat:brightness] forKey:@"inputEV"];
    
    filter = [CIFilter filterWithName:@"CIGammaAdjust" keysAndValues:kCIInputImageKey, [filter outputImage], nil];
    [filter setDefaults];
    CGFloat contrast   = duiBiDuSlider.value * duiBiDuSlider.value;
    [filter setValue:[NSNumber numberWithFloat:contrast] forKey:@"inputPower"];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}

- (UIActivityIndicatorView *)activeIV
{
    if (!_activeIV) {
        _activeIV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activeIV.frame = CGRectMake(0, 0, 60, 60);
        _activeIV.layer.cornerRadius = 5;
        _activeIV.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2 - 50);
        _activeIV.backgroundColor = [UIColor blackColor];
        [[UIApplication sharedApplication].keyWindow addSubview:_activeIV];
        [_activeIV startAnimating];
    }
    return _activeIV;
}


@end
