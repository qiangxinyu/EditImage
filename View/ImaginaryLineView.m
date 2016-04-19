//
//  ImaginaryLineView.m
//  testpicture
//
//  Created by 中科创奇 on 15/6/13.
//  Copyright (c) 2015年 中科创奇. All rights reserved.
//

#import "ImaginaryLineView.h"

@implementation ImaginaryLineView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    
    
    CGFloat dashPattern[]= {3.0, 2};
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    context =UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
    // And draw with a blue fill color
//    CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0);
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, 4.0);
    CGContextSetLineDash(context, 0.0, dashPattern, 2);
    
    CGContextAddRect(context, self.bounds);
    
    CGContextStrokePath(context);
    
    
//    // Close the path
//    CGContextClosePath(context);
//    // Fill & stroke the path
//    CGContextDrawPath(context, kCGPathFillStroke);
   
}
@end
