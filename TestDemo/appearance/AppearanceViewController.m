//
//  AppearanceViewController.m
//  TestDemo
//
//  Created by Fantasy on 16/10/19.
//  Copyright © 2016年 fantasy. All rights reserved.
//

#import "AppearanceViewController.h"
#import "AppearanceButton.h"

@interface AppearanceViewController ()

@end

@implementation AppearanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppearanceButton *btn = [AppearanceButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(30.f, 100.f, 100.f, 40.f)];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitle:@"Appearance" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(changeBorderColor:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void) changeBorderColor:(AppearanceButton *)sender {
//    [[AppearanceButton appearance] setBorderColor:[UIColor blueColor]];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"Copy" action:@selector(test:)];
    [menu setMenuItems:@[copyItem]];
    [menu setTargetRect:sender.bounds inView:self.view];
    [menu setMenuVisible:YES animated:YES];
}

- (BOOL) canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(test:)) {
        return YES;
    }
    return [super canPerformAction:action withSender:sender];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)test:(id)test {
    NSLog(@"%@",[[test class] description]);
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
