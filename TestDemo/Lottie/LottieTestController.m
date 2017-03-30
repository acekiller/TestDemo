//
//  LottieTestController.m
//  TestDemo
//
//  Created by Fantasy on 17/3/30.
//  Copyright © 2017年 fantasy. All rights reserved.
//

#import "LottieTestController.h"
#import <Lottie/Lottie.h>

@interface LottieTestController ()

@end

@implementation LottieTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    LOTAnimationView *animation = [LOTAnimationView animationNamed:@"Lottie"];
    [self.view addSubview:animation];
    [animation playWithCompletion:^(BOOL animationFinished) {
        NSLog(@"playCompletion");
    }];
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

@end
