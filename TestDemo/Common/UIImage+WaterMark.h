//
//  UIImage+WaterMark.h
//  WaterMark
//
//  Created by Fantasy on 17/2/14.
//  Copyright © 2017年 fantasy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaterMarkAttribute : NSObject
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGRect drawRect;
@property (nonatomic, assign) CGPoint offset;   //从右下角往左上脚的偏移度
@end

@interface UIImage (WaterMark)
@property (nonatomic, strong, readonly) WaterMarkAttribute *waterMarkAttribute;

/*
 *  此方法不支持方向变换
 */
- (UIImage *) watermarkImageWithText:(NSString *)text;

- (UIImage *) maskImageWithText:(NSString *)text;

-(UIImage *)addTextImage:(UIImage *)logo;

- (UIImage *)watermarkImageWithName:(NSString *)name;

@end
