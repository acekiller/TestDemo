//
//  TextFieldTestController.m
//  TestDemo
//
//  Created by Fantasy on 16/9/8.
//  Copyright © 2016年 fantasy. All rights reserved.
//

#import "TextFieldTestController.h"
#import "TDTextField.h"

@interface TextFieldTestController ()
<
    UITextFieldDelegate
>
@property (weak, nonatomic) IBOutlet UISegmentedControl *alignmentSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *securitySegment;
- (IBAction)alignmentValueChanged:(UISegmentedControl *)sender;
- (IBAction)securityValueChanged:(UISegmentedControl *)sender;
@property (weak, nonatomic) IBOutlet UITextField *alignmentField;
@property (weak, nonatomic) IBOutlet UITextField *securityField;
@property (weak, nonatomic) IBOutlet TDTextField *maxLengthField;
@end

@implementation TextFieldTestController

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

- (IBAction)alignmentValueChanged:(UISegmentedControl *)sender {
    NSTextAlignment alignment;
    if (sender.selectedSegmentIndex == 0) {
        alignment = NSTextAlignmentLeft;
    } else if (sender.selectedSegmentIndex == 1) {
        alignment = NSTextAlignmentCenter;
    } else {
        alignment = NSTextAlignmentRight;
    }
    [self.alignmentField setTextAlignment:alignment];
}

- (IBAction)securityValueChanged:(UISegmentedControl *)sender {
    BOOL isSecurity = !(sender.selectedSegmentIndex == 0);
    
    NSString *text = self.securityField.text;
    [self.securityField setSecureTextEntry:isSecurity];
    self.securityField.text = @"";
    self.securityField.text = text;
    
//    [self.securityField setSecureTextEntry:isSecurity];
//    self.securityField.font = [UIFont systemFontOfSize:12.f];
//    self.securityField.font = [UIFont systemFontOfSize:17.f];
//    self.securityField.attributedText = [[NSAttributedString alloc] initWithString:self.securityField.text];
}

//- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    
//}

@end
