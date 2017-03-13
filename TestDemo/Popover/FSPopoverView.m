//
//  FSPopoverView.m
//  TestDemo
//
//  Created by Fantasy on 17/2/8.
//  Copyright © 2017年 fantasy. All rights reserved.
//

#import "FSPopoverView.h"
#import "PopoverConvertCalculate.h"
#import "YQJPopoverContentView.h"

#define YQJPOPOVERMARGINX 8.f
#define YQJPOPOVERMARGINY 8.f
#define YQJPOPOVERARROWSIZE 8.f

@interface FSPopoverView ()

@end

@implementation FSPopoverView

- (instancetype) initWithText:(NSString *)text {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupDefaultParams];
        _showText = [text copy];
    }
    return self;
}

//主体背景色始终保持透明
- (void) setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:[UIColor clearColor]];
}

- (void) setupDefaultParams {
    [self.layer setMasksToBounds:NO];
    self.arrowSize = CGSizeMake(YQJPOPOVERARROWSIZE * 2, YQJPOPOVERARROWSIZE);
    self.popoverColor = [UIColor darkGrayColor];
    self.textMargin = UIEdgeInsetsMake(YQJPOPOVERMARGINY, YQJPOPOVERMARGINX, YQJPOPOVERMARGINY, YQJPOPOVERMARGINX);
    self.arrowDirection = UIPopoverArrowDirectionAny;
    self.textColor = [UIColor whiteColor];
    self.font = [UIFont systemFontOfSize:16.f];
}

- (void) showAtView:(UIView *)atView inView:(UIView *)inView {
    PopoverConvertCalculate *calculate = [PopoverConvertCalculate createModelAtView:atView
                                                                             inView:inView
                                                                           withText:_showText];
    [self appendParamsWithCalculate:calculate];
    [calculate calculate];
    [self showWithCalculate:calculate];
    
}

- (void) showAtPoint:(CGPoint)atPoint inView:(UIView *)inView {
    PopoverConvertCalculate *calculate = [PopoverConvertCalculate createModelAtPoint:atPoint
                                                                              inView:inView
                                                                            withText:_showText];
    [self appendParamsWithCalculate:calculate];
    [calculate calculate];
    [self showWithCalculate:calculate];
}

- (void) appendParamsWithCalculate:(PopoverConvertCalculate *)calculate {
    calculate.textMargin = self.textMargin;
    calculate.arrowDirection = self.arrowDirection;
    calculate.arrowSize = self.arrowSize;
    calculate.textColor = self.textColor;
    calculate.font = self.font;
}

- (void) showWithCalculate:(PopoverConvertCalculate *)calculate {
    self.alpha = 0.f;
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self addSubview:[self createContentViewWithCalculate:calculate]];
    [self setFrame:calculate.drawRect];
    [calculate.inView addSubview:self];
    //执行显示动画。
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.alpha = 1.f;
                     }];
}

- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hide];
}

- (void) hide {
    //执行隐藏动画，并从superview移除
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.alpha = 0.f;
                     } completion:^(BOOL finished) {
                         if (finished) {
                             [self removeFromSuperview];
                         }
                     }];
}

- (UIView *) createContentViewWithCalculate:(PopoverConvertCalculate *)calculate {
    YQJPopoverContentView *v = [[YQJPopoverContentView alloc] initWithFrame:CGRectMake(0.f, 0.f, calculate.drawRect.size.width, calculate.drawRect.size.height)
                                                                   showText:calculate.showText
                                                                 arrowPoint:calculate.arrowDrawPoint
                                                                  direction:calculate.arrowDirection];
    v.textMargin = calculate.textMargin;
    v.popoverColor = self.popoverColor;
    v.arrowSize = calculate.arrowSize;
    v.font = calculate.font;
    v.textColor = calculate.textColor;
    return v;
}

@end
