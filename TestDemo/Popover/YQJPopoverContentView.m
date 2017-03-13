//
//  YQJPopoverContentView.m
//  TestDemo
//
//  Created by Fantasy on 17/2/8.
//  Copyright © 2017年 fantasy. All rights reserved.
//

#import "YQJPopoverContentView.h"

@interface YQJPopoverContentView ()
- (CGFloat) arrowHeight;
@end

@interface YQJPopoverTextContentView : YQJPopoverContentView

- (instancetype) initWithFrame:(CGRect)frame
                      showText:(NSString *)text
                    arrowPoint:(CGPoint)arrowPoint
                     direction:(UIPopoverArrowDirection)direction;

- (CAShapeLayer *)arrowLayer;

@end

@implementation YQJPopoverTextContentView
{
    UILabel *_contentLabel;
    CALayer *_textBackgroundLayer;
    CAShapeLayer *_arrowLayer;
    CALayer *_shadowLayer;
}

- (instancetype) initWithFrame:(CGRect)frame
                      showText:(NSString *)showText
                    arrowPoint:(CGPoint)arrowPoint
                     direction:(UIPopoverArrowDirection)direction
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.layer setMasksToBounds:NO];
        self.showText = showText;
        self.direction = direction;
        self.arrowPoint = arrowPoint;
        self.imageOrigin = YQJPopoverImageOriginNone;
        
        _textBackgroundLayer = [self createBackgroundLayer];
        [self.layer addSublayer:_textBackgroundLayer];
        
        _arrowLayer = [self arrowLayer];
        [self.layer addSublayer:_arrowLayer];
        
        _contentLabel = [self createContentLabel];
        _contentLabel.text = self.showText;
        [self addSubview:_contentLabel];
    }
    return self;
}

- (CALayer *) createShadowLayer {
    CALayer *shadowLayer = [CALayer layer];
    shadowLayer.shadowColor = [UIColor blueColor].CGColor;
    shadowLayer.shadowOffset = CGSizeMake(0.f, 21.f);
    shadowLayer.shadowRadius = 5.f;
    shadowLayer.shadowOpacity = 0.76;
    return shadowLayer;
}

- (CALayer *)createBackgroundLayer {
    CALayer *layer = [CALayer layer];
    layer.cornerRadius = 5.f;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOpacity = 0.24;
    layer.shadowRadius = 3.f;
    layer.shadowOffset = CGSizeMake(0.f, 0.f);
    return layer;
}

- (UILabel *)createContentLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    return label;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    _textBackgroundLayer.backgroundColor = self.popoverColor.CGColor;
    [_textBackgroundLayer setFrame:[self getTextBackgroundRectWithDirection:self.direction]];
    
    _textBackgroundLayer.shadowPath = [self shadowBezierPath:_textBackgroundLayer.frame].CGPath;
    
    [_arrowLayer setFrame:[self getArrowFrame:self.arrowPoint
                                    arrowSize:self.arrowSize
                                    direction:self.direction]];
    _arrowLayer.path = [self arrowBezierPathWithArrowBounds:_arrowLayer.bounds
                                                  direction:self.direction].CGPath;
    _arrowLayer.fillColor = self.popoverColor.CGColor;
    
    _contentLabel.textColor = self.textColor;
    _contentLabel.font = self.font;
    [_contentLabel setFrame:[self getTextRectWithDirection:self.direction]];
}

- (CGRect) getTextBackgroundRectWithDirection:(UIPopoverArrowDirection)direction {
    CGFloat offsetX = 0.f;
    CGFloat offsetY = 0.f;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    switch (direction) {
        case UIPopoverArrowDirectionDown:
        {
            width = self.frame.size.width;
            height = self.frame.size.height - [self arrowHeight];
        }
            break;
        case UIPopoverArrowDirectionLeft:
        {
            offsetX = self.arrowHeight;
            width = self.frame.size.width - [self arrowHeight];
            height = self.frame.size.height;
        }
            break;
        case UIPopoverArrowDirectionRight:
        {
            width = self.frame.size.width - [self arrowHeight];
            height = self.frame.size.height;
        }
            break;
        default:
        {
            offsetY = self.arrowHeight;
            width = self.frame.size.width;
            height = self.frame.size.height - [self arrowHeight];
        }
            break;
    }
    return CGRectMake(offsetX, offsetY, width, height);
}

- (CGRect) getTextRectWithDirection:(UIPopoverArrowDirection)direction {
    CGFloat offsetX = 0.f;
    CGFloat offsetY = 0.f;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    switch (direction) {
        case UIPopoverArrowDirectionDown:
        {
            offsetY = self.textMargin.top;
            offsetX = self.textMargin.left;
            width = self.frame.size.width - self.textMargin.left - self.textMargin.right;
            height = self.frame.size.height - self.textMargin.top - self.textMargin.bottom - self.arrowHeight;
        }
            break;
        case UIPopoverArrowDirectionLeft:
        {
            offsetX = self.arrowHeight + self.textMargin.left;
            offsetY = self.textMargin.top;
            width = self.frame.size.width - self.textMargin.left - self.textMargin.right - self.arrowHeight;
            height = self.frame.size.height - self.textMargin.top - self.textMargin.bottom;
        }
            break;
        case UIPopoverArrowDirectionRight:
        {
            offsetX = self.textMargin.left;
            offsetY = self.textMargin.top;
            width = self.frame.size.width - self.textMargin.left - self.textMargin.right - self.arrowHeight;
            height = self.frame.size.height - self.textMargin.top - self.textMargin.bottom;
        }
            break;
        default:
        {
            offsetY = self.arrowHeight + self.textMargin.top;
            offsetX = self.textMargin.left;
            width = self.frame.size.width - self.textMargin.left - self.textMargin.right;
            height = self.frame.size.height - self.textMargin.top - self.textMargin.bottom - self.arrowHeight;
        }
            break;
    }
    return CGRectMake(offsetX, offsetY, width, height);
}

- (UIBezierPath *)arrowBezierPathWithArrowBounds:(CGRect)bounds
                                       direction:(UIPopoverArrowDirection)direction
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    CGFloat width = bounds.size.width;
    CGFloat height = bounds.size.height;
    switch (direction) {
        case UIPopoverArrowDirectionDown:
        {
            [bezierPath moveToPoint:CGPointMake(width / 2.f, height)];
            [bezierPath addLineToPoint:CGPointMake(0.f, 0.f)];
            [bezierPath addLineToPoint:CGPointMake(width, 0.f)];
        }
            break;
        case UIPopoverArrowDirectionLeft:
        {
            [bezierPath moveToPoint:CGPointMake(0.f, height / 2.f)];
            [bezierPath addLineToPoint:CGPointMake(width, 0.f)];
            [bezierPath addLineToPoint:CGPointMake(width, height)];
        }
            break;
        case UIPopoverArrowDirectionRight:
        {
            [bezierPath moveToPoint:CGPointMake(width, height / 2.f)];
            [bezierPath addLineToPoint:CGPointMake(0.f, height)];
            [bezierPath addLineToPoint:CGPointMake(0.f, 0.f)];
        }
            break;
        default:
        {
            [bezierPath moveToPoint:CGPointMake(width / 2.f, 0.f)];
            [bezierPath addLineToPoint:CGPointMake(width, height)];
            [bezierPath addLineToPoint:CGPointMake(0.f, height)];
        }
            break;
    }
    [bezierPath closePath];
    return bezierPath;
}

- (UIBezierPath *)shadowBezierPath:(CGRect)boundsRect {
    
    CGFloat width = boundsRect.size.width;
    CGFloat height = boundsRect.size.height;
    
    UIBezierPath *ovalRect = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0.f, height - 5.f, width, 10.f)];
    
    return ovalRect;
}

- (CAShapeLayer *)arrowLayer {
    CAShapeLayer *layer = [CAShapeLayer layer];
    return layer;
}

- (CGRect)getArrowFrame:(CGPoint)arrowPoint
              arrowSize:(CGSize)arrowSize
              direction:(UIPopoverArrowDirection)direction
{
    switch (direction) {
        case UIPopoverArrowDirectionDown:
            return CGRectMake(arrowPoint.x - arrowSize.width / 2.f, arrowPoint.y - arrowSize.height, arrowSize.width, arrowSize.height);
        case UIPopoverArrowDirectionLeft:
            return CGRectMake(arrowPoint.x, arrowPoint.y - arrowSize.width / 2.f, arrowSize.height, arrowSize.width);
        case UIPopoverArrowDirectionRight:
            return CGRectMake(arrowPoint.x - arrowSize.height, arrowPoint.y - arrowSize.width / 2.f, arrowSize.height, arrowSize.width);
        default:
            return CGRectMake(arrowPoint.x - arrowSize.width / 2.f, arrowPoint.y, arrowSize.width, arrowSize.height);
    }
}

@end

@implementation YQJPopoverContentView

- (instancetype) initWithFrame:(CGRect)frame
                      showText:(NSString *)showText
                    arrowPoint:(CGPoint)arrowPoint
                     direction:(UIPopoverArrowDirection)direction
{
    return [[YQJPopoverTextContentView alloc] initWithFrame:frame
                                                   showText:showText
                                                 arrowPoint:arrowPoint
                                                  direction:direction];
}

- (instancetype) initWithFrame:(CGRect)frame
                      showText:(NSString *)showText
                         image:(UIImage *)image
                   imageOrigin:(YQJPopoverImageOrigin)imageOrigin
                    arrowPoint:(CGPoint)arrowPoint
                     direction:(UIPopoverArrowDirection)direction
{
    if (image == nil) {
        return [self initWithFrame:frame
                          showText:showText
                        arrowPoint:arrowPoint
                         direction:direction];
    }
    
    YQJPopoverContentView *contentView = [super initWithFrame:frame];
    contentView.showText = showText;
    contentView.direction = direction;
    contentView.arrowPoint = arrowPoint;
    contentView.image = image;
    contentView.imageOrigin = imageOrigin;
    return contentView;
}

- (CGFloat) arrowHeight {
    return self.arrowSize.height;
}

@end
