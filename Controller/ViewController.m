//
//  ViewController.m
//  testpicture
//
//  Created by 中科创奇 on 15/6/10.
//  Copyright (c) 2015年 中科创奇. All rights reserved.
//

#import "ViewController.h"
#import "SmallCollectionViewCell.h"

#import "AddTemplateCollectionViewController.h"


#import "EditManager.h"


// You will also need to set the Prefix Header build setting of one or more of your targets to reference this file.

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width

@interface ViewController () <iCarouselDataSource,iCarouselDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,SmallCollectionViewCellDelegate,AddTemplateCollectionViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,EditManagerDelegate>

@property (nonatomic,strong)iCarousel * icarousel;

@property (nonatomic,strong)NSMutableArray * groupArray;


@property (nonatomic,strong)UIView * downView;
@property (nonatomic,assign)BOOL isUp;
@property (nonatomic,strong)UIView * backgroudView;


@property (nonatomic,strong)UICollectionView * collectionView;
@property (nonatomic,strong)NSIndexPath * oldIndexPath;



/**
 *  圆形View
 */
@property (nonatomic,strong)UIView * playView;
/**
 *  播放
 */
@property (nonatomic,strong)UIImageView * playImageView;

/**
 *  点击播放后的旋转
 */
@property (nonatomic,strong)UIImageView * tureImageVIew;
/**
 *  添加
 */
@property (nonatomic,strong)UIImageView * addImageView;


/**
 *  编辑图片
 */

@property (nonatomic,strong)EditManager * editManager;
@property (nonatomic,strong)UIActivityIndicatorView * activeIV;

@end

@implementation ViewController
- (void)viewDidAppear:(BOOL)animated
{
    _editManager = nil;
    [super viewDidAppear:animated];
    
    /**
     *  默认选中第一个
     */
    self.oldIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    SmallCollectionViewCell * cell = (SmallCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:self.oldIndexPath];
    [cell select];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.view.backgroundColor = [UIColor grayColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    

    self.icarousel.bounces = NO;
    self.downView.hidden = NO;
    

    self.navigationItem.title = @"编辑初页";
    

    /**
     *  右边  导航栏 btn
     */
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"order_btn_normal"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(appearCollectionView:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 30, 30);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    
    
    self.groupArray = [NSMutableArray array];
    
    
    for (int i = 0; i < 30; i ++) {
        [self.groupArray addObject:[NSString stringWithFormat:@"%d.jpg",i]];
        
    }
    
    [self.icarousel reloadData];
    
}

/**
 *  点击 右 导航栏 btn
 *
 *  @param btn
 */
- (void)appearCollectionView:(UIButton *)btn
{
    
    /**
     *  如果 已经 下拉 那么让他 收回
     */
    if (self.isUp) {
        
        self.isUp = NO;
        
        [UIView animateWithDuration:.4 animations:^{
            /**
             *  缩小 下移
             *
             */
            self.icarousel.transform = CGAffineTransformMakeScale(1, 1);
            self.icarousel.center = CGPointMake(self.icarousel.center.x, self.icarousel.center.y -  40.0/480*kScreenHeight);
            
            //按钮 旋转
            self.navigationItem.rightBarButtonItem.customView.transform = CGAffineTransformMakeRotation(0);
            
            //删除 覆盖的 透明视图
            [self.backgroudView removeFromSuperview];
            
            //隐藏 collectionView
            self.collectionView.center = CGPointMake(self.collectionView.center.x, self.collectionView.center.y - ((kScreenHeight - 64)*.1 + 30));

        }];
        
        
        return;
    }
    
    
    [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:self.icarousel.previousItemIndex inSection:0]];
    
    /**
     *  让 collectionView  的偏移量改变
     */
    float x = self.icarousel.previousItemIndex;
    if (x == -1) {
        x = 0;
    }
    if (x >= self.groupArray.count-1) {
        x = (self.collectionView.contentSize.width - kScreenWidth) / 80;
    }
    
    self.collectionView.contentOffset = CGPointMake(80 * x, 0);
    
    
    
    self.isUp = YES;
    [UIView animateWithDuration:.4 animations:^{
        self.icarousel.transform = CGAffineTransformMakeScale(.8, .8);

        self.icarousel.center = CGPointMake(self.icarousel.center.x, self.icarousel.center.y + 40.0/480*kScreenHeight);
        
        self.navigationItem.rightBarButtonItem.customView.transform = CGAffineTransformMakeRotation(M_PI);
        
        [self.view addSubview:self.backgroudView];
        
        self.collectionView.center = CGPointMake(self.collectionView.center.x, self.collectionView.center.y + (kScreenHeight - 64)*.1 + 30);
    }];
    
}



#pragma mark -------------------------------------------------------------------------
#pragma mark ---------------------------主视图delegate--------------------------------------
#pragma mark -------------------------------------------------------------------------


- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.groupArray.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    @autoreleasepool {
        
   
        UIImage * image = nil;
        if ([self.groupArray[index] isKindOfClass:[UIImage class]]) {
            image = self.groupArray[index];
        }else
        {
            image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.groupArray[index] ofType:@""]];
    
        }
    
   
        UIImageView *   view = [[UIImageView alloc] initWithFrame: CGRectMake(70, 80, kScreenWidth- 100, kScreenHeight - 200)];
        view.image = image;
        view.contentMode = UIViewContentModeScaleAspectFit;
        view.backgroundColor = [UIColor grayColor];
    

        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(view.frame.size.width - 30, 5, 25, 25)];
        imageView.image = [UIImage imageNamed:@"changepic_btn"];
        [view addSubview:imageView];
    
    
        imageView.userInteractionEnabled = YES;
    
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickChangeImageView:)];
        [imageView addGestureRecognizer:tap];
    
    
        return view;
        
    }
}
- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
    return 0;
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    return 3;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return self.view.frame.size.width - 20;
}

- (CATransform3D)carousel:(iCarousel *)_carousel transformForItemView:(UIView *)view withOffset:(CGFloat)offset
{
   
    view.alpha = 1.0 - fminf(fmaxf(offset, 0.0), 1.0);
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = self.icarousel.perspective;
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0, 1.0, 0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * self.icarousel.itemWidth);
}


#pragma mark -------------------------------------------------------------------------
#pragma mark ---------------------------collection--------------------------------------
#pragma mark -------------------------------------------------------------------------


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.groupArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SmallCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"a" forIndexPath:indexPath];
    UIImage * image = nil;
    if ([self.groupArray[indexPath.row] isKindOfClass:[UIImage class]]) {
        image = self.groupArray[indexPath.row];
    }else
    {
        image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.groupArray[indexPath.row] ofType:@""]];
        
    }
    cell.imageView.image = image;
    cell.delegate = self;
    [cell unSelect];
    cell.indexPath = indexPath;
    
    if ([self.oldIndexPath isEqual:indexPath]) {
        [cell select];
    }
 
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(60.0/85.0 * 85.0/667*kScreenHeight, 85.0/667*kScreenHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 5, 5, 5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.oldIndexPath isEqual:indexPath]) {
        return;
    }
    
 
    
    SmallCollectionViewCell * cell = (SmallCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    [cell select];
    
    SmallCollectionViewCell * cell1 = (SmallCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:self.oldIndexPath];
    
    [cell1 unSelect];
    
    
    self.oldIndexPath = indexPath;
    
    [self.icarousel scrollToItemAtIndex:indexPath.row animated:YES];
    
}


#pragma mark -------------------------------------------------------------------------
#pragma mark ---------------------------长按  移动--------------------------------------
#pragma mark -------------------------------------------------------------------------
- (void)longPressGestureRecognized:(id)sender
{
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    
    // More coming soon...
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshotFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.collectionView addSubview:snapshot];
                
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 1;
                    
                } completion:nil];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            
            snapshot.center = location;
            
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                
                // ... update data source.
                [self.groupArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                
                // ... move the rows.
                [self.collectionView moveItemAtIndexPath:sourceIndexPath toIndexPath:indexPath];

                SmallCollectionViewCell * cell1 = (SmallCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:sourceIndexPath];
                [cell1 unSelect];
                cell1.indexPath = sourceIndexPath;
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            break;
        }
        default:{
            
            // Clean up.
            SmallCollectionViewCell * cell1 = (SmallCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:self.oldIndexPath];
            [cell1 unSelect];
            
            SmallCollectionViewCell *cell = (SmallCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            
            [cell select];
            cell.indexPath = indexPath;
            
            self.oldIndexPath = sourceIndexPath;
            
            
            NSInteger index = sourceIndexPath.row;
            
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                
                
            } completion:^(BOOL finished) {
                
                [self.icarousel reloadData];
                [self.icarousel scrollToItemAtIndex:index animated:YES];
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];
            
            sourceIndexPath = nil;
            break;
        }
            // More coming soon...
    }
}

- (UIView *)customSnapshotFromView:(UIView *)inputView
{
    
    UIView *snapshot = [inputView snapshotViewAfterScreenUpdates:YES];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}


#pragma mark -------------------------------------------------------------------------
#pragma mark ---------------------------SmallDelegate--------------------------------------
#pragma mark -------------------------------------------------------------------------

- (void)SmallCollectionViewCell:(SmallCollectionViewCell *)smallCollectionViewCell deleteWithIndexPath:(NSIndexPath *)indexPath
{
    [self.groupArray removeObjectAtIndex:indexPath.row];
    
    [self.collectionView reloadData];
    [self.icarousel reloadData];
    
}


#pragma mark -------------------------------------------------------------------------
#pragma mark ---------------------------addTemplatDelegate--------------------------------------
#pragma mark -------------------------------------------------------------------------

- (void)addTemplateCollectionViewController:(AddTemplateCollectionViewController *)addTemplateCollectionViewController selectImageViewAtImageName:(NSString *)imageName
{
    [self.groupArray insertObject:imageName atIndex:self.icarousel.previousItemIndex+1];
    
    [self.icarousel reloadData];
    [self.collectionView reloadData];
   
    
    
}

- (void)EditManager:(EditManager *)EditManager getImage:(UIImage *)image
{
    [self.groupArray insertObject:image atIndex:self.icarousel.previousItemIndex+1];

    
    [self.icarousel reloadData];
    [self.collectionView reloadData];
    
    [self.icarousel scrollToItemAtIndex:self.icarousel.previousItemIndex+1 animated:NO];


}

#pragma mark -------------------------------------------------------------------------
#pragma mark ---------------------------imagePickerDelegate--------------------------------------
#pragma mark -------------------------------------------------------------------------



- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    switch ([navigationController.viewControllers indexOfObject:viewController]) {
            case 2:{
          
            int i = 0;
                
                UIImage * image = nil;
                
                self.editManager = [[EditManager alloc]init];
                _editManager.delegate = self;
                _editManager.editImageViewController = viewController;
                _editManager.editImageNavigationController = navigationController;
                
                
                
            for (UIView * view in viewController.view.subviews) {
                if (i == 0) {
                    viewController.automaticallyAdjustsScrollViewInsets = NO;
                    UIImageView * imageView = [[view.subviews[0] subviews][0] subviews][0];
                    image = imageView.image;
                    [view removeFromSuperview];
                    _editManager.editScrollView = [[EditScrollView alloc]init];
                    _editManager.editSourceImageView = [[EditSourceImageView alloc]initWithImage:image];

                }
                if (i == 1) {
                    /**
                     *  删除 截图  取消和确定
                     */
                    [view removeFromSuperview];

                }
                i ++;
            }
               
                [_editManager layoutSubviews];
                
                
                [self.activeIV removeFromSuperview];
            break;
        }
    }
    
    
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    switch ([navigationController.viewControllers indexOfObject:viewController]) {
        case 0:{
            viewController.navigationItem.rightBarButtonItem.tintColor = [UIColor redColor];
            break;
        }
        case 1:{
            navigationController.navigationBar.tintColor=[UIColor redColor];
            viewController.navigationItem.rightBarButtonItem.tintColor = [UIColor redColor];
            break;
        }
        case 2:{
            [viewController.view addSubview:self.activeIV];
            break;
        }
            
    }

}


#pragma mark -------------------------------------------------------------------------
#pragma mark ---------------------------手势--------------------------------------
#pragma mark -------------------------------------------------------------------------

- (void)clickChangeImageView:(UITapGestureRecognizer *)tap
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //资源类型为图片库
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;

    [self presentViewController:picker animated:YES completion:nil];

}


- (void)clickAddImageView:(UITapGestureRecognizer *)tap
{
    UICollectionViewFlowLayout * fayout = [[UICollectionViewFlowLayout alloc]init];
    AddTemplateCollectionViewController * add = [[AddTemplateCollectionViewController alloc]initWithCollectionViewLayout:fayout];
    add.delegatge = self;
    [self presentViewController:add animated:YES completion:nil];
    
}

- (void)clickPlayImageView:(UITapGestureRecognizer *)tap
{
    [self.view addSubview:self.tureImageVIew];
    
    [self aaaa:0.08];
}

- (void)aaaa:(CGFloat)turn
{
    [UIView animateWithDuration:0.01 animations:^{
        
        self.tureImageVIew.transform = CGAffineTransformMakeRotation(turn);
        
    } completion:^(BOOL finished) {

        [self aaaa:turn+0.08];
    }];
}




#pragma mark -------------------------------------------------------------------------
#pragma mark ---------------------------懒加载--------------------------------------
#pragma mark -------------------------------------------------------------------------

/**
 *  上不 collectionView 出现的时候 遮挡
 *
 *  @return <#return value description#>
 */
- (UIView *)backgroudView
{
    if (!_backgroudView) {
        _backgroudView = [[UIView alloc]initWithFrame:CGRectMake(0,  self.collectionView.frame.size.height, kScreenWidth, kScreenHeight - 64)];
        _backgroudView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(appearCollectionView:)];
        [_backgroudView addGestureRecognizer:tap];
    }
    return _backgroudView;
}

/**
 *  播放的图片
 *
 *  @return <#return value description#>
 */
- (UIImageView *)playImageView
{
    if (!_playImageView) {
        _playImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        _playImageView.image = [UIImage imageNamed:@"preview_btn_normal"];
        _playImageView.center = CGPointMake(kScreenWidth/2, kScreenHeight - 40 - 64);
        _playImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickPlayImageView:)];
        [_playImageView addGestureRecognizer:tap];
    }
    return _playImageView;
}

/**
 *  添加
 *
 *  @return <#return value description#>
 */
- (UIImageView *)addImageView
{
    if (!_addImageView) {
        _addImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 40, 10, 30, 30)];
        _addImageView.image = [UIImage imageNamed:@"add_btn_red_normal"];
        
        _addImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAddImageView:)];
        [_addImageView addGestureRecognizer:tap];
        
    }
    return _addImageView;
}


/**
 *  播放
 *
 *  @return <#return value description#>
 */
- (UIView *)playView
{
    if (!_playView) {
        _playView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        _playView.center = CGPointMake(kScreenWidth/2, kScreenHeight - 40 - 64);
        _playView.backgroundColor = [UIColor whiteColor];
        _playView.layer.cornerRadius = 40;
    }
    return _playView;
    
}


/**
 *  转圈
 *
 *  @return
 */
- (UIImageView *)tureImageVIew
{
    if (!_tureImageVIew) {
        _tureImageVIew = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 75, 75)];
        _tureImageVIew.image = [UIImage imageNamed:@"spinner-large"];
        _tureImageVIew.center = CGPointMake(kScreenWidth/2, kScreenHeight - 40 - 64);
    }
    return _tureImageVIew;
}


- (UIActivityIndicatorView *)activeIV
{
    if (!_activeIV) {
        _activeIV = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activeIV.backgroundColor = [UIColor grayColor];
        _activeIV.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight);
        _activeIV.layer.cornerRadius = 5;
        [_activeIV startAnimating];
    }
    return _activeIV;
}


- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        /**
         collectionView
         */
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 20;
        
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, - ((kScreenHeight - 64)*.1 + 30), kScreenWidth, (kScreenHeight - 64)*.1 + 30) collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = self.view.backgroundColor;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        [_collectionView registerNib:[UINib nibWithNibName:@"SmallCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"a"];
        [self.view addSubview:_collectionView];
        
        
        
        
        /**
         collectionView的长按  可以 拖动 事件
         
         :param: longPressGestureRecognized
         
         :returns:
         */
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                                   initWithTarget:self action:@selector(longPressGestureRecognized:)];
        [_collectionView addGestureRecognizer:longPress];
    }
    return _collectionView;
}


/**
 *  主视图
 */
- (iCarousel *)icarousel
{
    if (!_icarousel) {
        
        
        /**
         主视图
         */
        _icarousel = [[iCarousel alloc]initWithFrame:CGRectMake(-60, 0, kScreenWidth+120, kScreenHeight - 64 - 49)];
        
        _icarousel.delegate =self;
        _icarousel.dataSource = self;
        _icarousel.type = iCarouselTypeCoverFlow;
        _icarousel.backgroundColor = [UIColor lightGrayColor];
        
        [self.view addSubview:_icarousel];
    }
    return _icarousel;
}




- (UIView *)downView
{
    if (!_downView) {
        
        
        /**
         下边的功能栏
         */
        _downView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 49 - 64, kScreenWidth, 49)];
        _downView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_downView];
        
        
        
        [_downView addSubview:self.addImageView];
        
        [self.view addSubview:self.playView];
        [self.view addSubview:self.playImageView];
    }
    return _downView;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
