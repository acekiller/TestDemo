//
//  AVEditorexporter.h
//  TestDemo
//
//  Created by Fantasy on 16/9/19.
//  Copyright © 2016年 fantasy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AVEditorexporter : NSObject

- (void) exportAssetWithComposition:(AVMutableComposition *)composition
                   videoComposition:(AVMutableVideoComposition *)videoComposition
                    completeHandler:(void (^)(AVAssetExportSessionStatus, NSString *,NSError *))completeHandler;

@end
