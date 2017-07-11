//
//  UIColor+Contrast.m
//  ThreadTest
//
//  Created by Fantasy on 2017/5/25.
//  Copyright © 2017年 fantasy. All rights reserved.
//

#import "UIColor+Contrast.h"

@implementation UIColor (Contrast)

/*
 灰度图就是将RGB分量映射到RGB立方体的对角线上，由此而得出公式:
 gray = 0.299 * r + 0.587 * g + 0.114 * b
 */
- (UIColor *) grayScaleColor {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char pixel[4];
    CGContextRef contextRef = CGBitmapContextCreate(pixel,
                                                    1,
                                                    1,
                                                    8,
                                                    4,
                                                    colorSpace,
                                                    (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CGContextSetFillColorWithColor(contextRef, self.CGColor);
    CGContextFillRect(contextRef, CGRectMake(0, 0, 1, 1));
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    unsigned char r = pixel[0], g = pixel[1], b = pixel[2], a = pixel[3];
    unsigned char gray = (unsigned char)MAX(MIN(0.299 * r + 0.587 * g + 0.114 * b, 255), 0);
    UIColor *contrastColor = [UIColor colorWithRed:(gray^0xff) / 255.f green:(gray^0xff) / 255.f blue:(gray^0xff) / 255.f alpha:a / 255.f];
    return contrastColor;
}

- (UIColor *) contrastColor {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char pixel[4];
    CGContextRef contextRef = CGBitmapContextCreate(pixel,
                                                    1,
                                                    1,
                                                    8,
                                                    4,
                                                    colorSpace,
                                                    (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CGContextSetFillColorWithColor(contextRef, self.CGColor);
    CGContextFillRect(contextRef, CGRectMake(0, 0, 1, 1));
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    unsigned char contrastValue = 0xff;
    unsigned char r = MIN(pixel[0] ^ contrastValue, contrastValue);
    unsigned char g = MIN(pixel[1] ^ contrastValue, contrastValue);
    unsigned char b = MIN(pixel[2] ^ contrastValue, contrastValue);
    unsigned char a = pixel[3];
    UIColor *contrastColor = [UIColor colorWithRed:r / 255.f green:g / 255.f blue:b / 255.f alpha:a / 255.f];
    return contrastColor;
}

- (UIColor *) grayScaleContrastColor {
    return [[self grayScaleColor] contrastColor];
}

- (UIColor *)blackAndWhiteContrastColor {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char pixel[4];
    CGContextRef contextRef = CGBitmapContextCreate(pixel,
                                                    1,
                                                    1,
                                                    8,
                                                    4,
                                                    colorSpace,
                                                    (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CGContextSetFillColorWithColor(contextRef, self.CGColor);
    CGContextFillRect(contextRef, CGRectMake(0, 0, 1, 1));
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    unsigned char r = pixel[0] ^ 255, g = pixel[1] ^ 255, b = pixel[2] ^ 255, a = pixel[3];
    unsigned char gray = (((unsigned char)(0.299 * r + 0.587 * g + 0.114 * b) ^ 255) > 127 ? 0 : 255);
    UIColor *contrastColor = [UIColor colorWithRed:gray / 255.f green:gray / 255.f blue:gray / 255.f alpha:a / 255.f];
    return contrastColor;
}

@end
