//
//  MergeController.m
//  TestDemo
//
//  Created by Fantasy on 16/9/18.
//  Copyright © 2016年 fantasy. All rights reserved.
//

#import "MergeController.h"
#import "AVEditor.h"

@interface MergeController ()
@property (nonatomic, strong) AVAsset *firstAsset;
@property (nonatomic, strong) AVAsset *secondAsset;
@property (nonatomic, strong) AVAsset *audioAsset;

@property (nonatomic, strong) AVEditor *editor;

@end

@implementation MergeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)LoadAsset1:(id)sender {
    NSURL *file = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"One" ofType:@"m4v"]];
    self.firstAsset = [AVURLAsset assetWithURL:file];
    if (file && self.firstAsset) {
        NSLog(@"success one");
    } else {
        NSLog(@"failed one");
    }
}

- (IBAction)loadAsset2:(id)sender {
    NSURL *file = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Two" ofType:@"mp4"]];
    self.secondAsset = [AVURLAsset assetWithURL:file];
    if (file && self.secondAsset) {
        NSLog(@"success two");
    } else {
        NSLog(@"failed two");
    }
}

- (IBAction)loadAudio:(id)sender {
    NSURL *file = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"liunian" ofType:@"mp3"]];
    self.audioAsset = [AVURLAsset assetWithURL:file];
    if (file && self.audioAsset) {
        NSLog(@"success audio");
    } else {
        NSLog(@"failed audio");
    }
}

- (IBAction)mergeAndSave:(id)sender {
    if (self.firstAsset == nil || self.secondAsset == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"error" message:@"先load视频文件吧！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    [self.activity startAnimating];
    
    self.editor = [[AVEditor alloc] init];
    [self.editor insertVideo:self.firstAsset];
    [self.editor insertVideo:self.secondAsset];
    [self.editor insertAudio:self.audioAsset
              withAudioRange:CMTimeRangeMake(CMTimeMakeWithSeconds(3, 1), CMTimeMakeWithSeconds(6, 1)) atTime:self.firstAsset.duration];
    
    [self.editor startAsyncExport:^(AVAssetExportSessionStatus status, NSString *filePath,NSError *error) {
        switch (status) {
            case AVAssetExportSessionStatusUnknown:
                NSLog(@"exporter Unknow");
                [self.activity stopAnimating];
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"exporter Canceled");
                [self.activity stopAnimating];
                break;
            case AVAssetExportSessionStatusFailed:
                NSLog(@"exporter Failed");
                [self.activity stopAnimating];
                break;
            case AVAssetExportSessionStatusWaiting:
                NSLog(@"exporter Waiting");
                break;
            case AVAssetExportSessionStatusExporting:
                NSLog(@"exporter Exporting");
                break;
            case AVAssetExportSessionStatusCompleted:
                NSLog(@"exporter Completed");
                [self.activity stopAnimating];
                break;
        }
    }];
    
    
//    [self.activity startAnimating];
    
//    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
//    
//    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
//    NSError *error = nil;
//    //混合视频
//    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, self.firstAsset.duration) ofTrack:[self.firstAsset tracksWithMediaType:AVMediaTypeVideo][0] atTime:kCMTimeZero error:&error];
//    if (error) {
//        NSLog(@"second : %@",error);
//    }
//    
//    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, self.secondAsset.duration) ofTrack:[self.secondAsset tracksWithMediaType:AVMediaTypeVideo][0] atTime:CMTimeMakeWithSeconds(CMTimeGetSeconds(self.firstAsset.duration), 1) error:&error];
//    if (error) {
//        NSLog(@"second : %@",error);
//    }
//    
//    //如果只混合视频会导致声音消失，所以需要把声音插入道混淆器中。
//    //添加音频
//    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
//    //混合视频
//    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, self.firstAsset.duration) ofTrack:[self.firstAsset tracksWithMediaType:AVMediaTypeAudio][0] atTime:kCMTimeZero error:&error];
//    if (error) {
//        NSLog(@"second : %@",error);
//    }
//    
//    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, self.secondAsset.duration) ofTrack:[self.secondAsset tracksWithMediaType:AVMediaTypeAudio][0] atTime:CMTimeMakeWithSeconds(CMTimeGetSeconds(self.firstAsset.duration), 1) error:&error];
//    if (error) {
//        NSLog(@"second : %@",error);
//    }
//    CMTimeRange range = CMTimeRangeMake(CMTimeMakeWithSeconds(CMTimeGetSeconds(self.firstAsset.duration) - 3, 1), CMTimeMakeWithSeconds(3, 1));
//    [audioTrack removeTimeRange:range];
//    AVAssetTrack *t_track = [self.audioAsset tracksWithMediaType:AVMediaTypeAudio][0];
//    [audioTrack insertTimeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(4, 1), range.duration) ofTrack:t_track atTime:range.start error:&error];
//    if (error) {
//        NSLog(@"audio : %@",error);
//    }
//    
//    
//    AVMutableCompositionTrack *textTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeText preferredTrackID:kCMPersistentTrackID_Invalid];
//    //混合视频
//    [textTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, self.firstAsset.duration) ofTrack:[self.firstAsset tracksWithMediaType:AVMediaTypeVideo][0] atTime:kCMTimeZero error:&error];
//    if (error) {
//        NSLog(@"second : %@",error);
//    }
//    
//    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *filePath = [cachePath stringByAppendingPathComponent:@"comp.mp4"];
//    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
//        [[NSFileManager defaultManager]removeItemAtPath:filePath error:nil];
//    }
//    AVAssetExportSession *exporterSession = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
//    exporterSession.outputFileType = AVFileTypeMPEG4;
//    exporterSession.outputURL = [NSURL fileURLWithPath:filePath];
//    exporterSession.shouldOptimizeForNetworkUse = YES;//用于互联网传输
//    [exporterSession exportAsynchronouslyWithCompletionHandler:^{
//        switch (exporterSession.status) {
//            case AVAssetExportSessionStatusUnknown:
//                NSLog(@"exporter Unknow");
//                [self.activity stopAnimating];
//                break;
//            case AVAssetExportSessionStatusCancelled:
//                NSLog(@"exporter Canceled");
//                [self.activity stopAnimating];
//                break;
//            case AVAssetExportSessionStatusFailed:
//                NSLog(@"exporter Failed");
//                [self.activity stopAnimating];
//                break;
//            case AVAssetExportSessionStatusWaiting:
//                NSLog(@"exporter Waiting");
//                break;
//            case AVAssetExportSessionStatusExporting:
//                NSLog(@"exporter Exporting");
//                break;
//            case AVAssetExportSessionStatusCompleted:
//                NSLog(@"exporter Completed");
//                [self.activity stopAnimating];
//                break;
//        }
//    }];
    
}
@end
