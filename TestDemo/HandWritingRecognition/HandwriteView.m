//
//  HandwriteView.m
//  TestDemo
//
//  Created by Fantasy on 17/3/16.
//  Copyright © 2017年 fantasy. All rights reserved.
//

#import "HandwriteView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface HandwriteView ()
@property (nonatomic, strong) NSMutableArray *strokes;
@property (nonatomic, assign) NSInteger strokeCount;
@property (nonatomic, strong) NSMutableArray *strokeStartPoints;
@property (nonatomic, strong) NSMutableArray *strokeEndPoints;
@property (nonatomic, strong) NSMutableArray *inputPointGrids;
@property (nonatomic, strong) NSMutableString *pointsString;
@end

@implementation HandwriteView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.strokes = [[NSMutableArray alloc] init];
        self.strokeStartPoints = [[NSMutableArray alloc] init];
        self.strokeEndPoints = [[NSMutableArray alloc] init];
        self.pointsString = [[NSMutableString alloc] init];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        NSMutableArray *newStackOfPoints = [NSMutableArray array];
        [newStackOfPoints addObject:[NSValue valueWithCGPoint:[touch locationInView:self]]];
        [self.strokes addObject:newStackOfPoints];
    }
}

- (void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        [[self.strokes lastObject] addObject:[NSValue valueWithCGPoint:[touch locationInView:self]]];
    }
}

- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch* touch in touches) {
        [[self.strokes lastObject] addObject:[NSValue valueWithCGPoint:[touch locationInView:self]]];
    }
}

- (void) touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

// 取相对坐标
- (void)turnToGrids {
    [self.strokeStartPoints removeAllObjects];
    [self.strokeEndPoints removeAllObjects];
    [self.inputPointGrids removeAllObjects];
    self.strokeCount = self.strokes.count;
    // 格子宽度
    float gridWidth = kScreenWidth/10;
    for (int k=0; k<self.strokes.count; k++) {
        // 存储一个笔画的所有点到一个数组
        NSMutableArray *strokPointGrids = [NSMutableArray array];
        NSArray *inputStrokesArray = self.strokes[k];
        for (int l = 0; l<inputStrokesArray.count; l++) {
            NSValue *value = inputStrokesArray[l];
            if (l == 0) {
                [self.strokeStartPoints addObject:value];
            }
            if (l == self.strokeStartPoints.count - 1) {
                [self.strokeEndPoints addObject:value];
            }
            CGPoint point = [value CGPointValue];
            CGPoint grid = CGPointMake(ceil(point.x/gridWidth), ceil(point.y/gridWidth));
            BOOL shouldAdd = NO;
            if (strokPointGrids.count == 0) {
                shouldAdd = YES;
            } else {
                NSValue *lastValue = strokPointGrids.lastObject;
                CGPoint lastGrid = [lastValue CGPointValue];
                if (lastGrid.x != grid.x || lastGrid.y != grid.y) {
                    shouldAdd = YES;
                }
            }
            if (shouldAdd) {
                [strokPointGrids addObject:[NSValue valueWithCGPoint:grid]];
                if (![self.pointsString isEqualToString: @""] && ![self.pointsString hasSuffix:@"*"]) {
                    [self.pointsString appendString:[NSString stringWithFormat:@"|"]];
                }
                [self.pointsString appendString:[NSString stringWithFormat:@"%d,%d", (int)grid.x, (int)grid.y]];
            }
        }
        if (k != self.strokes.count-1) {
            [self.pointsString appendString:@"*"];
        }
        [self.inputPointGrids addObject:strokPointGrids];
    }
}

@end
