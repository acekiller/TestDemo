//
//  UIImage+SampleBuffer.h
//  TestDemo
//
//  Created by Fantasy on 16/9/27.
//  Copyright © 2016年 fantasy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface UIImage (SampleBuffer)
+ (UIImage *) imageFromSampleBuffer:(CVImageBufferRef) buffer;
@end
