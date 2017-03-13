//
//  YQJPopoverContentView.h
//  TestDemo
//
//  Created by Fantasy on 17/2/8.
//  Copyright © 2017年 fantasy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,YQJPopoverImageOrigin) {
    YQJPopoverImageOriginNone = 0,
    YQJPopoverImageOriginUp = 1,
    YQJPopoverImageOriginDown = 2,
    YQJPopoverImageOriginLeft = 3,
    YQJPopoverImageOriginRight = 4,
};

@interface YQJPopoverContentView : UIView
@property (nonatomic, strong) UIColor *popoverColor;
@property (nonatomic, strong) NSString *showText;
@property (nonatomic, assign) CGPoint arrowPoint;
@property (nonatomic, assign) CGSize arrowSize;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) UIPopoverArrowDirection direction;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) YQJPopoverImageOrigin imageOrigin;
@property (nonatomic, assign) UIEdgeInsets textMargin;

- (instancetype) initWithFrame:(CGRect)frame
                      showText:(NSString *)showText
                    arrowPoint:(CGPoint)arrowPoint
                     direction:(UIPopoverArrowDirection)direction;

- (instancetype) initWithFrame:(CGRect)frame
                      showText:(NSString *)showText
                         image:(UIImage *)image
                   imageOrigin:(YQJPopoverImageOrigin)imageOrigin
                    arrowPoint:(CGPoint)arrowPoint
                     direction:(UIPopoverArrowDirection)direction;

@end
