//
//  FMGradientView.m
//  TestDemo
//
//  Created by Fantasy on 2017/5/26.
//  Copyright © 2017年 fantasy. All rights reserved.
//

#import "FMGradientView.h"

@implementation FMGradientView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGFloat colors[] = {1,1,0,.5,0,1,1,1,1,0,1,.5};
    CGFloat locations[3]={0,0.3,1};
    CGGradientRef gradientRef = CGGradientCreateWithColorComponents(colorSpaceRef, colors, locations, 3);
    CGContextDrawLinearGradient(contextRef,
                                gradientRef,
                                CGPointMake(30.f, 100.f),
                                CGPointMake(self.frame.size.width - 30.f, 100.f),
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    CGColorSpaceRelease(colorSpaceRef);
    CGGradientRelease(gradientRef);
}

@end
