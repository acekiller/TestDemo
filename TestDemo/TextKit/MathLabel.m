//
//  MathLabel.m
//  TestDemo
//
//  Created by Fantasy on 2017/7/10.
//  Copyright © 2017年 fantasy. All rights reserved.
//

#import "MathLabel.h"

@implementation MathLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIImage *)convertViewToImage {
    NSLog(@"Begin");
    [self sizeToFit];
    CGSize s = self.bounds.size;
    UIGraphicsBeginImageContextWithOptions(s, NO, self.layer.contentsScale);
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, self.bounds.size.height);
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"End");
    return image;
}


@end
