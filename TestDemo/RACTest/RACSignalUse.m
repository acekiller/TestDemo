//
//  RACSignalUse.m
//  TestDemo
//
//  Created by Fantasy on 17/3/20.
//  Copyright © 2017年 fantasy. All rights reserved.
//

#import "RACSignalUse.h"
#import <RACSignal.h>

@implementation RACSignalUse

- (RACSignal *)signalOne {
    return [RACSignal return:@"signal One"];
}

- (RACSignal *)signalTwo {
    return [RACSignal return:@"signal Two"];
}

- (RACSignal *)signalThree {
    return [RACSignal return:@"signal Three"];
}

- (RACSignal *)contactSignal {
    return [[self signalOne] concat:[self signalTwo]];
}

- (RACSignal *) bindSignal {
    return [[self signalOne] bind:^RACStreamBindBlock{
        return ^(NSString *description, BOOL *isStop){
            return [RACSignal return:description];
        };
    }];
}

- (RACSignal *)zipSignal {
    return [[self signalOne] zipWith:[self signalTwo]];
}

@end
