//
//  AppearanceButton.m
//  TestDemo
//
//  Created by Fantasy on 16/10/19.
//  Copyright © 2016年 fantasy. All rights reserved.
//

#import "AppearanceButton.h"

@implementation AppearanceButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) setBorderColor:(UIColor *)borderColor {
    self.layer.borderWidth = 1.f;
    self.layer.borderColor = borderColor.CGColor;
}

@end
