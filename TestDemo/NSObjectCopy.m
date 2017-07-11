//
//  NSObjectCopy.m
//  TestDemo
//
//  Created by Fantasy on 2017/6/2.
//  Copyright © 2017年 fantasy. All rights reserved.
//

#import "NSObjectCopy.h"

@interface CopyObject
- (id) object;
@end

@implementation NSObjectCopy

- (id) copyWithZone:(NSZone *) zone {
    return self;
    
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return self;
}

- (id) getCopyObject:(CopyObject *)object {
    return [object object];
}

@end
