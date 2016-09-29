//
//  AVEditor.m
//  TestDemo
//
//  Created by Fantasy on 16/9/18.
//  Copyright © 2016年 fantasy. All rights reserved.
//

#import "AVEditor.h"
#import "AVFile.h"

@interface AVFile (init)

- (instancetype) initWithAsset:(AVAsset *)asset;

@end

@implementation AVFile (init)

- (instancetype) initWithAsset:(AVAsset *)asset
{
    self = [super init];
    if (self) {
        self.asset = asset;
        self.dataTimeRange = CMTimeRangeMake(kCMTimeZero, self.asset.duration);
        self.atTime = kCMTimeInvalid;
    }
    return self;
}

@end

@interface AVEditor ()
{
    AVMutableComposition *_compositon;
    NSMutableArray *_videoCacheAssets;
    NSMutableArray *_audioCacheAssets;
    dispatch_queue_t _workQueue;
}
@end

@implementation AVEditor

- (instancetype) init {
    self = [super init];
    if (self) {
        [self setUpInitizal];
    }
    return self;
}

- (void) setUpInitizal {
    _workQueue = dispatch_queue_create("com.AVEditor.queue", NULL);
    [self reset];
}

- (void) stop {
    [_compositon cancelLoading];
}

//使用完整的asset数据
- (void) insertVideo:(AVAsset *)videoAsset {
    [self insertVideo:videoAsset
       withVideoRange:kCMTimeRangeInvalid];
}

- (void) insertVideo:(AVAsset *)videoAsset
      withVideoRange:(CMTimeRange)videoRange {
    if (videoAsset == nil) {
        return;
    }
    AVFile *file = [[AVFile alloc] initWithAsset:videoAsset];
    file.dataTimeRange = videoRange;
    [_videoCacheAssets addObject:file];
}

- (void) rangeVideo:(AVAsset *)videoAsset {
    
}

- (void) insertAudio:(AVAsset *)audioAsset
      withAudioRange:(CMTimeRange)audioRange
             atTime:(CMTime)atTime {
    if (audioAsset == nil) {
        return;
    }
    AVFile *file = [[AVFile alloc] initWithAsset:audioAsset];
    file.dataTimeRange = audioRange;
    file.atTime = atTime;
    [_audioCacheAssets addObject:file];
}

- (void) removeAudio:(AVAsset *)audioAsset {
    
}

- (void)startAsyncExport {
    [self startAsyncExport:nil];
}

- (void) startAsyncExport:(void (^)(AVAssetExportSessionStatus, NSString *,NSError *))completeHandler {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    dispatch_async(_workQueue, ^{
        __weak typeof(self) weakSelf = self;
        [self combineToComposition:^(AVMutableVideoComposition *videoComposition) {
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf exportAssetWithComposition:_compositon
                                  videoComposition:videoComposition
                                   completeHandler:completeHandler];
        }];
    });
}

- (void) combineToComposition:(void(^)(AVMutableVideoComposition *))complete {
    AVMutableCompositionTrack *audioTrack = [_compositon addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    CMTime atTime = kCMTimeZero;
    NSMutableArray *layerInstructions = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < [_videoCacheAssets count]; i++) {
        AVFile *file = _videoCacheAssets[i];
        AVMutableVideoCompositionLayerInstruction *layerInstruction = [self combineVideo:file
                                                                         preferredAtTime:atTime
                                                                       isEndVideo:(i == [_videoCacheAssets count] -1)];
        
        
        [audioTrack insertTimeRange:file.dataTimeRange
                            ofTrack:[file.asset tracksWithMediaType:AVMediaTypeAudio][0]
                             atTime:[file atTimeWithPreferredAtTime:atTime]
                              error:nil];
        
        atTime = CMTimeAdd(atTime, file.dataTimeRange.duration);
        [layerInstructions addObject:layerInstruction];
    }
    AVMutableVideoCompositionInstruction *layersInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    layersInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, atTime);
    layersInstruction.layerInstructions = layerInstructions;
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    mainCompositionInst.instructions = @[layersInstruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);
    mainCompositionInst.renderSize = CGSizeMake(640.f, 320.f);
    
    [self combineReplaceAudio:audioTrack];
    complete(mainCompositionInst);
}

- (AVMutableVideoCompositionLayerInstruction *) combineVideo:(AVFile *)file
                                             preferredAtTime:(CMTime)preferredAtTime
                                                  isEndVideo:(BOOL)isEndVideo
{
    NSError *error;
    AVAssetTrack *videoTrack = [file.asset tracksWithMediaType:AVMediaTypeVideo][0];
    AVMutableCompositionTrack *track = [_compositon addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVMutableVideoCompositionLayerInstruction *layerInStruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:track];
    
    CMTime atTime = [file atTimeWithPreferredAtTime:preferredAtTime];
    
    [track insertTimeRange:file.dataTimeRange
                   ofTrack:videoTrack
                    atTime:atTime
                     error:&error];
    
    [layerInStruction setTransform:videoTrack.fixedTransform
                            atTime:atTime];
    
    if (!isEndVideo) {
        [layerInStruction setOpacity:0.0 atTime:CMTimeAdd(atTime, file.dataTimeRange.duration)];
    }
    
    if (error) {
        NSLog(@"error : %@",error);
    }
    
    return layerInStruction;
}

- (void) combineAssetTrackWithFile:(AVFile *)file
                   preferredAtTime:(CMTime)preferredAtTime
                      toVideoTrack:(AVMutableCompositionTrack *)toVideoTrack
                      toAudioTrack:(AVMutableCompositionTrack *)toAudioTrack
{
    CMTime atTime = [file atTimeWithPreferredAtTime:preferredAtTime];
    NSError *error = nil;
    [toVideoTrack insertTimeRange:file.dataTimeRange
                          ofTrack:[file.asset tracksWithMediaType:AVMediaTypeVideo][0]
                           atTime:atTime
                            error:&error];
    if (error) {
        NSLog(@"error : %@",error);
    }
    
    if ([self isClearOriginAudio]) {
        return;
    }
    
    [toAudioTrack insertTimeRange:file.dataTimeRange
                          ofTrack:[file.asset tracksWithMediaType:AVMediaTypeAudio][0]
                           atTime:atTime
                            error:&error];
    
    if (error) {
        NSLog(@"error : %@",error);
    }
}

- (void) combineReplaceAudio:(AVMutableCompositionTrack *)toAudioTrack {
    NSLog(@"%@",_audioCacheAssets);
    for (AVFile *file in _audioCacheAssets) {
        [self replaceAudio:file toAudioTrack:toAudioTrack];
    }
}

- (void) replaceAudio:(AVFile *)file
         toAudioTrack:(AVMutableCompositionTrack *)toAudioTrack {
    [toAudioTrack removeTimeRange:CMTimeRangeMake(file.atTime, file.dataTimeRange.duration)];
    [toAudioTrack insertTimeRange:file.dataTimeRange
                        ofTrack:[file.asset tracksWithMediaType:AVMediaTypeAudio][0]
                         atTime:file.atTime
                          error:nil];
}

- (void) clearAll {
    [self reset];
}

- (void)reset {
    _compositon = [AVMutableComposition composition];
    _videoCacheAssets = [[NSMutableArray alloc] init];
    _audioCacheAssets = [[NSMutableArray alloc] init];
    self.renderSize = CGSizeMake(640.f, 480.f);
}

- (NSArray *)audoCaches {
    return _audioCacheAssets;
}

- (NSArray *)videoCaches {
    return _videoCacheAssets;
}

- (void) saveCache {
    
}

- (CMTime) fileDuration {
    CMTime duration = kCMTimeZero;
    for (AVFile *file in _videoCacheAssets) {
        duration = CMTimeAdd(duration, file.dataTimeRange.duration);
    }
    return duration;
}

@end
