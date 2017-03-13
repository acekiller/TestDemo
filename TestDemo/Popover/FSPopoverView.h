//
//  FSPopoverView.h
//  TestDemo
//
//  Created by Fantasy on 17/2/8.
//  Copyright © 2017年 fantasy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSPopoverView : UIView

@property (nonatomic, strong) UIColor *popoverColor;
@property (nonatomic, strong, readonly) NSString *showText;
@property (nonatomic, strong, readonly) UIImage *image; //暂不支持
@property (nonatomic, assign) UIEdgeInsets textMargin;
@property (nonatomic, assign) CGSize arrowSize;
@property (nonatomic, assign) UIPopoverArrowDirection arrowDirection;   //默认为UIPopoverArrowDirectionAny,此情况下自动选择，向上或向下。若自己指定方向则使用指定方向。
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *font;

- (instancetype) initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype) initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

- (instancetype) init NS_UNAVAILABLE;

- (instancetype) initWithText:(NSString *)text;

/**
 *  atPoint arrow显示的点
 *  inView  当前popover的父视图
 */
- (void) showAtPoint:(CGPoint)atPoint inView:(UIView *)inView;

/**
 *  atView arrow显示的自动调节基准位置
 *  inView  当前popover的父视图
 */
- (void) showAtView:(UIView *)atView inView:(UIView *)inView;

- (void)hide;

@end
