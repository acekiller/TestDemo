//
//  VCapture.h
//  TestDemo
//
//  Created by Fantasy on 16/9/27.
//  Copyright © 2016年 fantasy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol VCaptureDelegate;

@interface VCapture : NSObject
@property (nonatomic, assign) id <VCaptureDelegate> delegate;
@property (nonatomic, strong, readonly) AVCaptureSession *session;
@property (nonatomic, copy)void (^effectBufferHandler)(CVImageBufferRef buffer);
- (void) updateOrientation:(UIInterfaceOrientation)orientation;
- (void) startRecording;
- (void) stopRecording;
- (void) startRunning;
- (void) stopRunning;
@end

@protocol VCaptureDelegate <NSObject>

- (void) captureImage:(UIImage *)image;

@end
