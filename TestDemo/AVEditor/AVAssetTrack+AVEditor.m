//
//  AVAssetTrack+AVEditor.m
//  TestDemo
//
//  Created by Fantasy on 16/9/19.
//  Copyright © 2016年 fantasy. All rights reserved.
//

#import "AVAssetTrack+AVEditor.h"
#import <UIKit/UIKit.h>

#define CDPRadians( degrees ) (M_PI * ( degrees ) / 180.0 )

@implementation AVAssetTrack (AVEditor)

//根据videoTrack获得视频方向
- (UIImageOrientation)fixedOrientation
{
    CGAffineTransform transform=self.preferredTransform;
    
    if (transform.a == 0 && transform.b == 1.0 && transform.c == -1.0 && transform.d == 0) {
        //UIImageOrientationLeft
        return UIImageOrientationLeft;
    }
    else if (transform.a == 0 && transform.b == -1.0 && transform.c == 1.0 && transform.d == 0) {
        //UIImageOrientationRight
        return UIImageOrientationRight;
    }
    else if (transform.a == 1.0 && transform.b == 0 && transform.c == 0 && transform.d == 1.0) {
        //UIImageOrientationUp
        return UIImageOrientationUp;
    }
    else if (transform.a == -1.0 && transform.b == 0 && transform.c == 0 && transform.d == -1.0) {
        //UIImageOrientationDown
        return UIImageOrientationDown;
    }
    else{
        return UIImageOrientationUp;
    }
}
//根据AVAssetTrack等参数获得视频正确的transform
- (CGAffineTransform)fixedTransform {
    UIImageOrientation orientation = [self fixedOrientation];
    CGAffineTransform transform=self.preferredTransform;
    
    if (orientation==UIImageOrientationLeft) {
        CGAffineTransform t = CGAffineTransformMakeTranslation(self.naturalSize.height,0.0);
        transform = CGAffineTransformRotate(t,CDPRadians(90.0));
    }
    else if (orientation==UIImageOrientationRight) {
        CGAffineTransform t = CGAffineTransformMakeTranslation(-self.naturalSize.height,0.0);
        transform = CGAffineTransformRotate(t,CDPRadians(270.0));
    }
    else if (orientation==UIImageOrientationUp) {
    }
    else if (orientation==UIImageOrientationDown) {
        CGAffineTransform t = CGAffineTransformMakeTranslation(self.naturalSize.width,self.naturalSize.height);
        transform = CGAffineTransformRotate(t,CDPRadians(180.0));
    }
    
    return transform;
}

@end
