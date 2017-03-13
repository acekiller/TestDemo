//
//  PopoverConvertCalculate.m
//  TestDemo
//
//  Created by Fantasy on 17/2/8.
//  Copyright © 2017年 fantasy. All rights reserved.
//

#import "PopoverConvertCalculate.h"
#define YQJPOPOVERPADDINGX 14.f
#define YQJPOPOVERPADDINGY 14.f

@implementation PopoverConvertCalculate
{
    BOOL _isCalcAtPoint;
    CGPoint _atPoint;
    UIView *_atView;
}

+ (instancetype) createModelAtPoint:(CGPoint)atPoint inView:(UIView *)inView withText:(NSString *)text {
    PopoverConvertCalculate *calculate = [PopoverConvertCalculate factory];
    calculate->_isCalcAtPoint = NO;
    calculate->_atPoint = atPoint;
    calculate.inView = inView;
    calculate.showText = text;
    return calculate;
}

+ (instancetype) createModelAtView:(UIView *)atView inView:(UIView *)inView withText:(NSString *)text {
    PopoverConvertCalculate *calculate = [PopoverConvertCalculate factory];
    calculate->_isCalcAtPoint = YES;
    calculate->_atView = atView;
    calculate.inView = inView;
    calculate.showText = text;
    return calculate;
}

- (void) calculate {
    CGSize textContentSize = [self textContentSize];
    
    self.arrowDirection = [self fixArrowDirectionWithTextContentSize:textContentSize
                                                    defaultDirection:self.arrowDirection];
    [self updateAtPoint:self.arrowDirection];
    self.drawRect = [self drawRectWithTextSize:textContentSize
                                arrowDirection:self.arrowDirection];
    [self updateArrowPoint:self.drawRect
                   atPoint:_atPoint
                 direction:self.arrowDirection];
}

- (void) updateArrowPoint:(CGRect)drawRect
                  atPoint:(CGPoint)atPoint
                direction:(UIPopoverArrowDirection)direction
{
    switch (direction) {
        case UIPopoverArrowDirectionDown:
            self.arrowDrawPoint = CGPointMake(atPoint.x - CGRectGetMinX(drawRect), CGRectGetHeight(drawRect));
            break;
        case UIPopoverArrowDirectionLeft:
            self.arrowDrawPoint = CGPointMake(0.f, atPoint.y - CGRectGetMinY(drawRect));
            break;
        case UIPopoverArrowDirectionRight:
            self.arrowDrawPoint = CGPointMake(CGRectGetWidth(drawRect),atPoint.y - CGRectGetMinY(drawRect));
            break;
        default:
            self.arrowDrawPoint = CGPointMake(atPoint.x - CGRectGetMinX(drawRect), 0);
    }
}

- (CGPoint)getAtPoint:(UIPopoverArrowDirection)direction {
    if (!_isCalcAtPoint) {
        return _atPoint;
    }
    return [self atPointWithDirection:direction
                           withAtView:_atView
                               toView:self.inView];
}

- (void) updateAtPoint:(UIPopoverArrowDirection)direction {
    _atPoint = [self getAtPoint:direction];
}

- (CGPoint) atPointWithDirection:(UIPopoverArrowDirection)direction
                      withAtView:(UIView *)inView
                          toView:(UIView *)toView
{
    CGPoint point = CGPointZero;
    switch (direction) {
        case UIPopoverArrowDirectionDown:
            point = CGPointMake(CGRectGetMidX(inView.frame),CGRectGetMinY(inView.frame));
            break;
        case UIPopoverArrowDirectionLeft:
            point = CGPointMake(CGRectGetMaxX(inView.frame),CGRectGetMidY(inView.frame));
            break;
        case UIPopoverArrowDirectionRight:
            point = CGPointMake(CGRectGetMidX(inView.frame), CGRectGetMidY(inView.frame));
            break;
        default:
            point = CGPointMake(CGRectGetMidX(inView.frame),CGRectGetMaxY(inView.frame));
            break;
    }
    CGPoint atPoint = [inView.superview convertPoint:point toView:toView];
    return atPoint;
}

- (CGRect)drawRectWithTextSize:(CGSize)textSize
                arrowDirection:(UIPopoverArrowDirection)direction
{
    CGFloat arrowX = 0.f;
    CGFloat arrowY = 0.f;
    arrowY = (direction == UIPopoverArrowDirectionUp || direction == UIPopoverArrowDirectionDown) ? self.arrowSize.height : 0.f;
    arrowX = (direction == UIPopoverArrowDirectionLeft || direction == UIPopoverArrowDirectionRight) ? self.arrowSize.height : 0.f;
    CGFloat width = textSize.width + self.textMargin.left + self.textMargin.right + arrowX;
    CGFloat height = textSize.height + self.textMargin.top + self.textMargin.bottom + arrowY;
    CGFloat offsetX = 0.f;
    CGFloat offsetY = 0.f;
    switch (direction) {
        case UIPopoverArrowDirectionDown:
        {
            offsetY = _atPoint.y - height;
            offsetX = [self offsetXAtPoint:_atPoint width:width];
        }
            break;
        case UIPopoverArrowDirectionLeft:
        {
            offsetX = _atPoint.x;
            offsetY = [self offsetYAtPoint:_atPoint height:height];
        }
            break;
        case UIPopoverArrowDirectionRight:
        {
            offsetX = _atPoint.x - width;
            offsetY = [self offsetYAtPoint:_atPoint height:height];
        }
            break;
        default:
        {
            offsetY = _atPoint.y;
            offsetX = [self offsetXAtPoint:_atPoint width:width];
        }
            break;
    }
    
    return CGRectMake(offsetX, offsetY, width, height);
    
}

- (CGFloat) offsetXAtPoint:(CGPoint)atPoint
                     width:(CGFloat)width {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat offsetX = _atPoint.x - width / 2.f;
    if (offsetX < YQJPOPOVERPADDINGX + self.arrowSize.height / 2.f) {
        offsetX = YQJPOPOVERPADDINGX + self.arrowSize.height / 2.f;
    } else if (offsetX + width > screenWidth - (YQJPOPOVERPADDINGX + self.arrowSize.height / 2.f))  {
        offsetX = screenWidth - (YQJPOPOVERPADDINGX + self.arrowSize.height / 2.f) - width;
    }
    return offsetX;
}

- (CGFloat) offsetYAtPoint:(CGPoint)atPoint
                    height:(CGFloat)height {
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat offsetY = _atPoint.x - height / 2.f;
    if (offsetY < YQJPOPOVERPADDINGY + self.arrowSize.height / 2.f) {
        offsetY = YQJPOPOVERPADDINGY + self.arrowSize.height / 2.f;
    } else if (offsetY + height > screenHeight - (YQJPOPOVERPADDINGY + self.arrowSize.height / 2.f))  {
        offsetY = screenHeight - (YQJPOPOVERPADDINGY + self.arrowSize.height / 2.f) - height;
    }
    return offsetY;
}


- (CGPoint) calculateArrowDrawPoint:(CGPoint)textContentSize {
    return CGPointZero;
}

- (UIPopoverArrowDirection)fixArrowDirectionWithTextContentSize:(CGSize)textSize
                                               defaultDirection:(UIPopoverArrowDirection)defaultDirection
{
    if (defaultDirection != UIPopoverArrowDirectionAny) {
        return defaultDirection;
    }
    return [self arrowUpIsOverflowScreen:textSize
                                  inView:self.inView] ? UIPopoverArrowDirectionDown : UIPopoverArrowDirectionUp;
}

- (BOOL) arrowUpIsOverflowScreen:(CGSize)textSize
                          inView:(UIView *)inView {
    CGFloat height = textSize.height + self.textMargin.top + self.textMargin.bottom + self.arrowSize.height;
    CGPoint atPoint = [self getAtPoint:UIPopoverArrowDirectionUp];
    CGPoint checkPoint = CGPointMake(atPoint.x, atPoint.y + height);
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGPoint convertPoint = [inView convertPoint:checkPoint toView:keyWindow];
    return convertPoint.y > [UIScreen mainScreen].bounds.size.height;
}

- (CGSize) textContentSize {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = self.font;
    label.text = self.showText;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    return [label sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width - self.arrowSize.height - self.textMargin.left - self.textMargin.right - YQJPOPOVERPADDINGX * 2,
                                          CGFLOAT_MAX)];
}

+ (instancetype) factory {
    PopoverConvertCalculate *calculate = [[PopoverConvertCalculate alloc] init];
    return calculate;
}

@end
