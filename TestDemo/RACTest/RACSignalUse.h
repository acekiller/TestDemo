//
//  RACSignalUse.h
//  TestDemo
//
//  Created by Fantasy on 17/3/20.
//  Copyright © 2017年 fantasy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RACSignal.h>

@interface RACSignalUse : NSObject

- (RACSignal *)contactSignal;

- (RACSignal *) bindSignal;

- (RACSignal *)zipSignal;

@end
