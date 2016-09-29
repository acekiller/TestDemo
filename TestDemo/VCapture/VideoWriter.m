//
//  VideoWriter.m
//  TestDemo
//
//  Created by Fantasy on 16/9/28.
//  Copyright © 2016年 fantasy. All rights reserved.
//

#import "VideoWriter.h"

@interface VideoWriter ()
@property (nonatomic, strong) AVAssetWriter *writer;
@property (nonatomic, strong) AVAssetWriterInput *writerInput;
@property (nonatomic, strong) AVAssetWriterInputPixelBufferAdaptor *adaptor;
@property (nonatomic, strong) NSURL *outputURL;
@property (nonatomic) CMTime startTime;
@end

@implementation VideoWriter

- (void) start {
    [self setUpWriter];
}

- (void) stop {
    self.isRecording = NO;
    [self.writerInput markAsFinished];
    AVAssetWriterStatus status = self.writer.status;
    while (status == AVAssetWriterStatusUnknown) {
        [NSThread sleepForTimeInterval:0.5f];
        status = self.writer.status;
    }
    @synchronized (self) {
        [self.writer finishWritingWithCompletionHandler:^{
            //
        }];
        [self cleanupWriter];
    }
}

- (void) cleanupWriter {
    self.adaptor = nil;
    self.writerInput = nil;
    self.writer = nil;
    self.startTime = kCMTimeInvalid;
}

- (instancetype) initWithSize:(CGSize)size {
    self = [super init];
    if (self) {
        self.videoSize = size;
    }
    return self;
}

- (void) setUpWriter {
    NSError *error = nil;
    self.writer = [[AVAssetWriter alloc] initWithURL:[self tempFileURL]
                                            fileType:AVFileTypeQuickTimeMovie
                                               error:&error];
    NSDictionary *videoCompressionProps = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:1024.0*1024.0], AVVideoAverageBitRateKey,nil ];
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   AVVideoCodecH264, AVVideoCodecKey,
                                   [NSNumber numberWithInt:self.videoSize.width], AVVideoWidthKey,
                                   [NSNumber numberWithInt:self.videoSize.height], AVVideoHeightKey,
                                   videoCompressionProps, AVVideoCompressionPropertiesKey,
                                   nil];
    
    self.writerInput = [[AVAssetWriterInput alloc] initWithMediaType:AVMediaTypeVideo
                                                      outputSettings:videoSettings];
    self.writerInput.expectsMediaDataInRealTime = YES;
    NSDictionary* bufferAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA], kCVPixelBufferPixelFormatTypeKey, nil];
    self.adaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:self.writerInput
                                                                                    sourcePixelBufferAttributes:bufferAttributes];
    [self.writer addInput:self.writerInput];
    [self.writer startWriting];
    [self.writer startSessionAtSourceTime:CMTimeMake(0, 1000)];
    self.isRecording = YES;
}

- (NSURL*) tempFileURL {
    NSString* videoPath = [[NSString alloc] initWithFormat:@"%@/%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0], @"test.mov"];
    NSURL* videoURL = [[NSURL alloc] initFileURLWithPath:videoPath];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:videoPath]) {
        NSError* error;
        if ([fileManager isDeletableFileAtPath:videoPath]) {
            //delete video if already exit at videoPath
            BOOL success = [[NSFileManager defaultManager] removeItemAtPath:videoPath error:&error];
            if (!success) {
                NSLog(@"Could not delete old recording file at path:  %@", videoPath);
            }
        }
    }
    return videoURL;
}

- (void) writerVideoBuffer:(CMSampleBufferRef)sampBuffer {
    if (![self isRecording]) {
        return;
    }
    CMTime bufferTimer = CMSampleBufferGetPresentationTimeStamp(sampBuffer);
    if (CMTIME_IS_INVALID(self.startTime)) {
        self.startTime = bufferTimer;
    }
    CMTime atTime = CMTimeSubtract(bufferTimer, self.startTime);
    if (![self.writerInput isReadyForMoreMediaData]) {
        NSLog(@"Not ready for video data");
    } else {
        CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampBuffer);
        CVPixelBufferLockBaseAddress( pixelBuffer, 0 );
        BOOL success = [self.adaptor appendPixelBuffer:pixelBuffer withPresentationTime:atTime];
        if (!success)
        {
            NSLog(@"Warning:  Unable to write buffer to video : %@",self.writer.error);
        }
        CVPixelBufferUnlockBaseAddress( pixelBuffer, 0 );
    }
}

- (void) writerAudioBuffer:(CMSampleBufferRef)sampBuffer {
    
}

- (void) appendImage:(UIImage *)sourceImage
      withTimeOffset:(NSTimeInterval)timeOffset {
    CMTime atTime = self.startTime;
    if (CMTIME_IS_INVALID(self.startTime)) {
        self.startTime = CMTimeMakeWithSeconds(timeOffset, 1000);
        atTime = self.startTime;
    } else {
        atTime = CMTimeAdd(self.startTime, CMTimeMakeWithSeconds(timeOffset, 1000));
    }
    if (![self.writerInput isReadyForMoreMediaData]) {
        NSLog(@"Not ready for video data");
    } else {
        UIImage *newFrame = sourceImage;
        CVPixelBufferRef pixelBuffer = NULL;
        CGImageRef cgImage = CGImageCreateCopy([newFrame CGImage]);
        CFDataRef image = CGDataProviderCopyData(CGImageGetDataProvider(cgImage));
        
        int status = CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, self.adaptor.pixelBufferPool, &pixelBuffer);
        if(status != 0){
            NSLog(@"Error creating pixel buffer:  status=%d", status);
        }
        
        CVPixelBufferLockBaseAddress( pixelBuffer, 0 );
        uint8_t* destPixels = CVPixelBufferGetBaseAddress(pixelBuffer);
        CFDataGetBytes(image, CFRangeMake(0, CFDataGetLength(image)), destPixels);
        if(status == 0){
            BOOL success = [self.adaptor appendPixelBuffer:pixelBuffer withPresentationTime:atTime];
            if (!success)
                NSLog(@"Warning:  Unable to write buffer to video");
        }
        
        CVPixelBufferUnlockBaseAddress( pixelBuffer, 0 );
        CVPixelBufferRelease( pixelBuffer );
        CFRelease(image);
        CGImageRelease(cgImage);
    }
}

@end
