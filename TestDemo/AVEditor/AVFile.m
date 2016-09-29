//
//  AVFile.m
//  TestDemo
//
//  Created by Fantasy on 16/9/18.
//  Copyright © 2016年 fantasy. All rights reserved.
//

#import "AVFile.h"

@implementation AVFile

- (CMTime)atTimeWithPreferredAtTime:(CMTime)preferredAtTime {
    if (CMTIME_IS_INVALID(self.atTime)) {
        return preferredAtTime;
    }
    return self.atTime;
}

- (void) setDataTimeRange:(CMTimeRange)dataTimeRange {
    [self willChangeValueForKey:@"dataTimeRange"];
    if (CMTIMERANGE_IS_INVALID(dataTimeRange)) {
        _dataTimeRange = CMTimeRangeMake(kCMTimeZero, self.asset.duration);
    } else {
        _dataTimeRange = dataTimeRange;
    }
    [self didChangeValueForKey:@"dataTimeRange"];
}

@end
