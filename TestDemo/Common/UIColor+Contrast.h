//
//  UIColor+Contrast.h
//  ThreadTest
//
//  Created by Fantasy on 2017/5/25.
//  Copyright © 2017年 fantasy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Contrast)

- (UIColor *) contrastColor;

- (UIColor *) grayScaleColor;

- (UIColor *)grayScaleContrastColor;

- (UIColor *)blackAndWhiteContrastColor;

@end
