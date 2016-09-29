//
//  AVFile.h
//  TestDemo
//
//  Created by Fantasy on 16/9/18.
//  Copyright © 2016年 fantasy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVAssetTrack+AVEditor.h"

@interface AVFile : NSObject
- (instancetype) init NS_UNAVAILABLE;
@property (nonatomic) NSInteger mediaType;
@property (nonatomic, strong) AVAsset *asset;
@property (nonatomic, assign) CMTimeRange dataTimeRange;
@property (nonatomic, assign) CMTime atTime;
- (CMTime)atTimeWithPreferredAtTime:(CMTime)preferredAtTime;
@end
