//
//  PlayButton.m
//  TestDemo
//
//  Created by Fantasy on 17/3/10.
//  Copyright © 2017年 fantasy. All rights reserved.
//

#import "PlayButton.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation PlayButton
{
    CALayer *squarLayer;
    CAShapeLayer *circleLayer;
}

- (void) dealloc {
    [self removeObserver:self forKeyPath:@"isPause"];
}

- (instancetype) init {
    self = [super init];
    [self setUp];
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setUp];
    return self;
}

- (void) setUp {
    self.isPause = YES;
    self.backgroundColor = [UIColor redColor];
    self.layer.masksToBounds = YES;
    
    squarLayer = [self createSquarLayer];
    [self.layer addSublayer:squarLayer];
    
    circleLayer = [self createShapLayer];
    [squarLayer addSublayer:circleLayer];
    
    [self addObserver:self forKeyPath:@"isPause"
              options:NSKeyValueObservingOptionNew
              context:nil];
}

- (CAShapeLayer *)createShapLayer {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor whiteColor].CGColor;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.strokeStart = 0.f;
    layer.strokeEnd = 1.f;
    return layer;
}

- (CALayer *)createSquarLayer {
    CALayer *layer = [CALayer layer];
    layer.cornerRadius = 2.f;
    layer.masksToBounds = YES;
    layer.backgroundColor = [UIColor clearColor].CGColor;
    return layer;
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self configure];
}

- (void) configure {
    self.layer.cornerRadius = self.frame.size.width / 2.f;
    [squarLayer setFrame:UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(self.frame.size.height / 3.f, self.frame.size.width / 3.f, self.frame.size.height / 3.f, self.frame.size.width / 3.f))];
    [circleLayer setFrame:UIEdgeInsetsInsetRect(squarLayer.bounds, UIEdgeInsetsMake(0.5, 0.5, 0.5, 0.5))];
    circleLayer.path = [UIBezierPath bezierPathWithOvalInRect:circleLayer.bounds].CGPath;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"isPause"]) {
        [self changePlayStatus:[change[NSKeyValueChangeNewKey] boolValue]];
    }
}

- (void) changePlayStatus:(BOOL)isPause {
    if (isPause) {
        circleLayer.lineWidth = 0.f;
    } else {
        circleLayer.lineWidth = squarLayer.bounds.size.width;
    }
}

@end
