//
//  TextKitController.m
//  TestDemo
//
//  Created by Fantasy on 2017/7/10.
//  Copyright © 2017年 fantasy. All rights reserved.
//

#import "TextKitController.h"
#import "MathLabel.h"

@interface MathAttachement : NSTextAttachment

@end

@implementation MathAttachement

- (CGRect) attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex {
    if (self.image.size.width > textContainer.size.width) {
        return CGRectMake(0, 0, textContainer.size.width, self.image.size.height * (textContainer.size.width / self.image.size.width));
    }
    return CGRectMake(0, 0, self.image.size.width, self.image.size.height);
}

@end

@interface TextKitController ()
@property (nonatomic, strong) UITextView *textView;
@end

@implementation TextKitController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(20.f, 80.f, self.view.frame.size.width - 40.f, self.view.frame.size.height)];
    self.textView.textColor = [UIColor blackColor];
    [self.view addSubview:self.textView];
    
    MathLabel *label = [[MathLabel alloc] initWithFrame:self.textView.frame];
    label.latex = @"x = \\frac{-b \\pm \\sqrt{b^2-4ac}}{2a} + \\frac{-b \\pm \\sqrt{b^2-4ac}}{2a} + \\frac{-b \\pm \\sqrt{b^2-4ac}}{2a}";
    label.fontSize = 15;
    label.textColor = [UIColor blueColor];
//    label.labelMode = kMTMathUILabelModeText;
//    [label sizeToFit];
//    [label setFrame:CGRectMake((self.view.bounds.size.width - label.frame.size.width) / 2.f, (self.view.bounds.size.height - label.frame.size.height) / 2.f - 100.f, label.frame.size.width, label.frame.size.height)];
//    [self.view addSubview:label];
    
//    UIImage *image = [label convertViewToImage];
    
//    UIImageView *imageV = [[UIImageView alloc] initWithImage:image];
//    [imageV setCenter:CGPointMake(self.view.bounds.size.width / 2.f, self.view.bounds.size.height / 2.f)];
//    [self.view addSubview:imageV];
    
    
    self.textView.attributedText = [self createAttributeString:label];
    
}

- (NSAttributedString *) createAttributeString:(MathLabel *)label {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"测试就测试中文版。是这里开始。Hello, welcome. 点点滴滴奋斗到底.测试就是这里开始。Hello, welcome. 点点滴滴奋斗到底.测试就是这里开始。Hello, welcome. 点点滴滴奋斗到底.测试就是这里开始。Hello, welcome. 点点滴滴奋斗到底."];
    MathAttachement *attachement = [[MathAttachement alloc] init];
    attachement.image = [label convertViewToImage];
    NSAttributedString *attr = [NSAttributedString attributedStringWithAttachment:attachement];
    [str appendAttributedString:attr];
    [str insertAttributedString:attr atIndex:65];
    
    return str;
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

- (UIImage *)convertViewToImage:(UIView *)view {
    NSLog(@"Begin");
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"End");
    return image;
}

@end
