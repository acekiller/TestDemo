//
//  VCapture.m
//  TestDemo
//
//  Created by Fantasy on 16/9/27.
//  Copyright © 2016年 fantasy. All rights reserved.
//

#import "VCapture.h"
#import "UIImage+SampleBuffer.h"
#import "VideoWriter.h"

@interface VCapture ()
<
    AVCaptureVideoDataOutputSampleBufferDelegate,
    AVCaptureAudioDataOutputSampleBufferDelegate,
    AVCaptureFileOutputRecordingDelegate
>
@property (nonatomic, strong, readonly) AVCaptureDeviceInput *videoInput;
@property (nonatomic, strong, readonly) AVCaptureDeviceInput *audioInput;
@property (nonatomic, strong, readonly) AVCaptureVideoDataOutput *videoOutput;
@property (nonatomic, strong, readonly) AVCaptureAudioDataOutput *audioOutput;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVAssetWriterInput *audioWriterInput;
@property (nonatomic, strong) AVCaptureConnection *videoConnection;

@property (nonatomic, strong) VideoWriter *videoWriter;

@end

@implementation VCapture
{
    AVCaptureDeviceInput *_videoInput;
    AVCaptureDeviceInput *_audioInput;
    AVCaptureVideoDataOutput *_videoOutput;
    AVCaptureAudioDataOutput *_audioOutput;
    NSString *_cacheVideoPath;
    BOOL isRecording;
    
    dispatch_queue_t videoQueue;
    dispatch_queue_t audioQueue;
}

- (void) dealloc {
    if ([_session isRunning]) {
        [_session stopRunning];
    }
}

- (instancetype) init {
    self = [super init];
    if (self) {
        if (![self setupConfig]) {
            return nil;
        }
    }
    return self;
}

- (BOOL) setupConfig {
    
    videoQueue = dispatch_queue_create("com.vcapture.video", NULL);
    audioQueue = dispatch_queue_create("com.vcapture.audio", NULL);
    
    _session = [[AVCaptureSession alloc] init];
    
    AVCaptureDeviceInput *videoInput = self.videoInput;
    AVCaptureDeviceInput *audioInput = self.audioInput;
    if (videoInput == nil || audioInput == nil) {
        return NO;
    }
    
    [_session beginConfiguration];
    [_session setSessionPreset:AVCaptureSessionPreset1280x720];
    [_session addInput:videoInput];
    [_session addInput:audioInput];
    [_session addOutput:self.videoOutput];
    [_session addOutput:self.audioOutput];
    [_session commitConfiguration];
    self.videoConnection = [self.videoOutput connectionWithMediaType:AVMediaTypeVideo];
    self.videoConnection.videoOrientation = (AVCaptureVideoOrientation)[[UIDevice currentDevice] orientation];
    self.videoWriter = [[VideoWriter alloc] initWithSize:CGSizeMake(1280, 720)];
    return YES;
}

- (AVCaptureDeviceInput *)videoInput {
    if (_videoInput == nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error = nil;
        _videoInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        if (error) {
            return nil;
        }
    }
    return _videoInput;
}

- (AVCaptureDeviceInput *)audioInput {
    if (_audioInput == nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
        NSError *error = nil;
        _audioInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        if (error) {
            return nil;
        }
    }
    return _audioInput;
}

- (AVCaptureVideoDataOutput *)videoOutput {
    if (_videoOutput == nil) {
        _videoOutput = [[AVCaptureVideoDataOutput alloc] init];
        
        [_videoOutput setAlwaysDiscardsLateVideoFrames:YES];
        
        [_videoOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
        
        [_videoOutput setSampleBufferDelegate:self queue:videoQueue];
    }
    return _videoOutput;
}

- (AVCaptureAudioDataOutput *)audioOutput {
    if (_audioOutput == nil) {
        _audioOutput = [[AVCaptureAudioDataOutput alloc] init];
        [_audioOutput setSampleBufferDelegate:self queue:audioQueue];
    }
    return _audioOutput;
}

- (void) updateOrientation:(UIInterfaceOrientation)orientation {
    self.videoConnection.videoOrientation = (AVCaptureVideoOrientation)orientation;
}

- (void) startRecording {
    isRecording = YES;
}

- (void) stopRecording {
    isRecording = NO;
//    [self.videoWriter stop];
}

- (void) startRunning {
    [self.session startRunning];
    [self.videoWriter start];
}

- (void) stopRunning {
    [self.session stopRunning];
    [self.videoWriter stop];
}

- (void) captureOutput:(AVCaptureOutput *)captureOutput
 didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
        fromConnection:(AVCaptureConnection *)connection
{
    if (captureOutput == _videoOutput) {
        [self videoCaputureOutput:captureOutput
            didOutputSampleBuffer:sampleBuffer
                   fromConnection:connection];
        [self.videoWriter writerBuffer:sampleBuffer];
    }
//    [self writerToFile:sampleBuffer
//        fromConnection:connection
//            withOutput:captureOutput];
}

- (void) videoCaputureOutput:(AVCaptureOutput *)captureOutput
       didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
              fromConnection:(AVCaptureConnection *)connection
{
    CVImageBufferRef buffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(buffer, 0);
    if (self.effectBufferHandler) {
        self.effectBufferHandler(buffer);
    }
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(captureImage:)]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.delegate captureImage:[UIImage imageFromSampleBuffer:buffer]];
        });
    }
    CVPixelBufferUnlockBaseAddress(buffer, 0);
}

@end
