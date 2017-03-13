//
//  PlayController.m
//  TestDemo
//
//  Created by Fantasy on 17/3/10.
//  Copyright © 2017年 fantasy. All rights reserved.
//

#import "PlayController.h"
#import "PlayButton.h"

@interface PlayController ()

@end

@implementation PlayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PlayButton *btn = [PlayButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(50.f, 100.f, 50.f, 50.f)];
    [btn addTarget:self action:@selector(send:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void) send:(PlayButton *)sender {
    sender.isPause = !sender.isPause;
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
