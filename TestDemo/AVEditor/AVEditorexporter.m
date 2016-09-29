//
//  AVEditorexporter.m
//  TestDemo
//
//  Created by Fantasy on 16/9/19.
//  Copyright © 2016年 fantasy. All rights reserved.
//

#import "AVEditorexporter.h"

@implementation AVEditorexporter

- (void) exportAssetWithComposition:(AVMutableComposition *)composition
                   videoComposition:(AVMutableVideoComposition *)videoComposition
                    completeHandler:(void (^)(AVAssetExportSessionStatus, NSString *,NSError *))completeHandler  {
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"comp_%@.mp4",[[NSDate date] description]]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager]removeItemAtPath:filePath error:nil];
    }
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:composition
                                                                           presetName:AVAssetExportPresetHighestQuality];
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.outputURL = [NSURL fileURLWithPath:filePath];
    exportSession.shouldOptimizeForNetworkUse = YES;
    exportSession.videoComposition = videoComposition;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        if (completeHandler != nil) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                completeHandler(exportSession.status,filePath,exportSession.error);
            });
        }
    }];
}

@end
