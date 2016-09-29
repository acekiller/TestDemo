//
//  VideoWriter.h
//  TestDemo
//
//  Created by Fantasy on 16/9/28.
//  Copyright © 2016年 fantasy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface VideoWriter : NSObject
- (instancetype) initWithSize:(CGSize)size;
@property (nonatomic) BOOL isRecording;
- (void) start;
- (void) stop;
@property (nonatomic) CGSize videoSize;
- (void) writerVideoBuffer:(CMSampleBufferRef)sampBuffer;
- (void) writerAudioBuffer:(CMSampleBufferRef)sampBuffer;

- (void) appendImage:(UIImage *)sourceImage
      withTimeOffset:(NSTimeInterval)timeOffset;
@end
