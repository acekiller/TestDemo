//
//  ImageFiltersController.m
//  TestDemo
//
//  Created by Fantasy on 2017/5/26.
//  Copyright © 2017年 fantasy. All rights reserved.
//

#import "ImageFiltersController.h"
#import "FMGradientView.h"

@interface ImageFiltersController ()

@end

@implementation ImageFiltersController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self testView];
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

- (void) testView {
    FMGradientView *v = [[FMGradientView alloc] initWithFrame:UIEdgeInsetsInsetRect(self.view.bounds, UIEdgeInsetsMake(70.f, 10.f, 40.f, 10.f))];
    [self.view addSubview:v];
}

@end
