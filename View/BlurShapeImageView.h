//
//  BlurShapeImageView.h
//  TestImage
//
//  Created by 中科创奇 on 15/6/18.
//  Copyright (c) 2015年 中科创奇. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  模糊 的形状
 */
@interface BlurShapeImageView : UIImageView

{
    id _target;
    SEL _action;
}

- (void)addTarget:(id)target action:(SEL)action;

- (void)unSelect;
- (void)select;
@end
