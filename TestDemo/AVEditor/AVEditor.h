//
//  AVEditor.h
//  TestDemo
//
//  Created by Fantasy on 16/9/18.
//  Copyright © 2016年 fantasy. All rights reserved.
//

#import "AVEditorexporter.h"

@interface AVEditor : AVEditorexporter

@property (nonatomic) BOOL isClearOriginAudio;  //是否使用原始音频
@property (nonatomic) CGSize renderSize;
//使用完整的asset数据
- (void) insertVideo:(AVAsset *)videoAsset;

- (void) insertVideo:(AVAsset *)videoAsset
      withVideoRange:(CMTimeRange)videoRange;

- (void) rangeVideo:(AVAsset *)videoAsset;

- (void) insertAudio:(AVAsset *)audioAsset
      withAudioRange:(CMTimeRange)audioRange
             atTime:(CMTime)atTime;

- (void) removeAudio:(AVAsset *)audioAsset;

- (void)startAsyncExport;

- (void)startAsyncExport:(void (^)(AVAssetExportSessionStatus, NSString *,NSError *))completeHandler;

- (void) clearAll;

- (NSArray *)audoCaches;

- (NSArray *)videoCaches;

- (void) saveCache;

@end
