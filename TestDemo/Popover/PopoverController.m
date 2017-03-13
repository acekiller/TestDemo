//
//  PopoverController.m
//  TestDemo
//
//  Created by Fantasy on 17/2/8.
//  Copyright © 2017年 fantasy. All rights reserved.
//

#import "PopoverController.h"
#import "FSPopoverView.h"

@interface PopoverController ()

@end

@implementation PopoverController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *btn1 = [self createButton];
    [btn1 setFrame:CGRectMake(10.f, 74.f, 100.f, 40.f)];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [self createButton];
    [btn2 setFrame:CGRectMake(self.view.frame.size.width - 110.f, 74.f, 100.f, 40.f)];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [self createButton];
    [btn3 setFrame:CGRectMake((self.view.frame.size.width - 100.f) / 2.f, (self.view.frame.size.height - 40.f) / 2.f, 100.f, 40.f)];
    [self.view addSubview:btn3];
    
    UIButton *btn4 = [self createButton];
    [btn4 setFrame:CGRectMake(10.f, self.view.frame.size.height - 50.f, 100.f, 40.f)];
    [self.view addSubview:btn4];
    
    UIButton *btn5 = [self createButton];
    [btn5 setFrame:CGRectMake(self.view.frame.size.width - 110.f, self.view.frame.size.height - 50.f, 100.f, 40.f)];
    [self.view addSubview:btn5];
    
}

- (UIButton *)createButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Show" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showPopover:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void) showPopover:(UIButton *)btn {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    FSPopoverView *popover = [[FSPopoverView alloc] initWithText:@"测试测试再测试，然后继续测试测试再测试。测试了就够了么？不够不够，真不够！"];
    popover.popoverColor = [UIColor blueColor];
    [popover showAtView:btn inView:self.view];
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
