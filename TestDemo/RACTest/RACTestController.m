//
//  RACTestController.m
//  TestDemo
//
//  Created by Fantasy on 17/3/21.
//  Copyright © 2017年 fantasy. All rights reserved.
//

#import "RACTestController.h"
#import "RACSignalUse.h"

@interface RACTestController ()
@property (nonatomic, strong) RACSignalUse *signalUse;
@end

@implementation RACTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.signalUse = [RACSignalUse new];
//    [[self.signalUse contactSignal] subscribeNext:^(id x) {
//        NSLog(@"%s : %@",__PRETTY_FUNCTION__,x);
//    }];
    
//    [[self.signalUse bindSignal] subscribeNext:^(id x) {
//        NSLog(@"%s : %@",__PRETTY_FUNCTION__,x);
//    }];
    
//    [[self.signalUse zipSignal] subscribeNext:^(id x) {
//        NSLog(@"value : %@",x);
//    }];
    
    NSArray *array = [self makeDatas];
    [self formatTypeTwo:array];
    [self formatTypeFour:array];
    [self formatTypeOne:array];
    [self formatTypeThree:array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *) makeDatas {
    NSMutableArray *datas = [NSMutableArray array];
    NSArray *tmp = [self arrays];
    for (NSInteger i = 0; i < 10000; i++) {
        [datas addObject:[tmp objectAtIndex:i % tmp.count]];
    }
    return datas;
}

- (NSArray *)arrays {
    return @[@"hello",@(356),@"你好",@"welcome",@(YES),@"中国人"];
}

- (NSString *)formatTypeOne:(NSArray *)array {
    NSDate *startTime = [NSDate date];
    if (array.count <= 0) {
        return @"";
    }
    NSMutableString *formats = [NSMutableString string];
    for (id param in array) {
        if ([param isKindOfClass:[NSNumber class]]) {
            [formats appendFormat:@"%@,",[param description]];
        } else if ([param isKindOfClass:[NSString class]]) {
            [formats appendFormat:@"'%@',",param];
        }
    }
    NSString *value = [formats substringToIndex:formats.length - 1];
    NSTimeInterval tim = [[NSDate date] timeIntervalSinceDate:startTime];
    NSLog(@"formatTypeOne %lf : %@",tim,value);
    return value;
}

- (NSString *)formatTypeTwo:(NSArray *)array {
    NSDate *startTime = [NSDate date];
    if (array.count <= 0) {
        return @"";
    }
    NSMutableArray *formats = [NSMutableArray arrayWithCapacity:array.count];
    for (id param in array) {
        if ([param isKindOfClass:[NSNumber class]]) {
            [formats addObject:[param description]];
        } else if ([param isKindOfClass:[NSString class]]) {
            [formats addObject:[NSString stringWithFormat:@"'%@'",param]];
        }
    }
    NSString *value = [formats componentsJoinedByString:@","];
    NSTimeInterval tim = [[NSDate date] timeIntervalSinceDate:startTime];
    NSLog(@"formatTypeTwo %lf : %@",tim,value);
    return value;
}

- (NSString *)formatTypeThree:(NSArray *)array {
    NSDate *startTime = [NSDate date];
    if (array.count <= 0) {
        return @"";
    }
    NSMutableString *formats = [NSMutableString string];
    for (id param in array) {
        if ([param isKindOfClass:[NSNumber class]]) {
            [formats appendFormat:@"%@,",[param description]];
        } else if ([param isKindOfClass:[NSString class]]) {
            [formats appendFormat:@"%@,",param];
        }
    }
    NSString *value = [formats substringToIndex:formats.length - 1];
    NSTimeInterval tim = [[NSDate date] timeIntervalSinceDate:startTime];
    NSLog(@"formatTypeThree %lf : %@",tim,value);
    return value;
}

- (NSString *)formatTypeFour:(NSArray *)array {
    NSDate *startTime = [NSDate date];
    if (array.count <= 0) {
        return @"";
    }
    NSMutableArray *formats = [NSMutableArray arrayWithCapacity:array.count];
    for (id param in array) {
        if ([param isKindOfClass:[NSNumber class]]) {
            [formats addObject:[param description]];
        } else if ([param isKindOfClass:[NSString class]]) {
            [formats addObject:param];
        }
    }
    NSString *value = [formats componentsJoinedByString:@","];
    NSTimeInterval tim = [[NSDate date] timeIntervalSinceDate:startTime];
    NSLog(@"formatTypeFour %lf : %@",tim,value);
    return value;
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
