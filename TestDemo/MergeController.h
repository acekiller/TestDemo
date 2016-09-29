//
//  MergeController.h
//  TestDemo
//
//  Created by Fantasy on 16/9/18.
//  Copyright © 2016年 fantasy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MergeController : UIViewController
- (IBAction)LoadAsset1:(id)sender;
- (IBAction)loadAsset2:(id)sender;
- (IBAction)loadAudio:(id)sender;
- (IBAction)mergeAndSave:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@end
