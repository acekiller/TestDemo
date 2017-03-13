//
//  PopoverConvertCalculate.h
//  TestDemo
//
//  Created by Fantasy on 17/2/8.
//  Copyright © 2017年 fantasy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopoverConvertCalculate : NSObject
@property (nonatomic, assign) UIEdgeInsets textMargin;
@property (nonatomic, assign) UIPopoverArrowDirection arrowDirection;
@property (nonatomic, assign) CGSize arrowSize;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) CGPoint arrowDrawPoint;   //相对于要绘制的视图的point
@property (nonatomic, assign) CGRect drawRect;//相对于inView的Rect
@property (nonatomic, strong) NSString *showText;
@property (nonatomic, strong) UIView *inView;
+ (instancetype) createModelAtPoint:(CGPoint)atPoint inView:(UIView *)inView withText:(NSString *)text;
+ (instancetype) createModelAtView:(UIView *)atView inView:(UIView *)inView withText:(NSString *)text;
- (void) calculate;
@end
