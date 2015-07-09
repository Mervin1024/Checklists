//
//  NSArray+Assemble.m
//  Checklists
//
//  Created by 马遥 on 15/7/6.
//  Copyright (c) 2015年 马遥. All rights reserved.
//

#import "NSArray+Assemble.h"
#import "NSString+Format.h"

@implementation NSArray (Assemble)

- (NSString *) stringByJoinSimplyWithBoundary:(NSString *)boundary{
    NSString *string = @"";
    for (int i = 0; i < self.count; i++) {
        string = [string stringByAppendingString:self[i]];
        if (i < self.count - 1) {
            string = [string stringByAppendingString:boundary];
        }
    }
    return string;
}

- (NSString *) stringByJoinEntireWithBoundary:(NSString *)boundary{
    NSString *string = @"";
    for (int i = 0; i < self.count; i++) {
        string = [string stringByAppendingString:[self[i] stringSwapWithBoundary:@"'"]];
        if (i < self.count - 1) {
            string = [string stringByAppendingString:boundary];
        }
    }
    return string;
}

- (NSArray *) arrayByMap:(id (^)(id))map{
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < self.count; i++) {
        [arr addObject:map(self[i])];
    }
    return arr;
}

- (NSArray *) arrayBySelect:(BOOL (^)(id))select{
    NSMutableArray *arr = [NSMutableArray array];
    for (id item in self) {
        if (select(item)) {
            [arr addObject:item];
        }
    }
    return arr;
}

- (void) excetueEach:(void (^)(id))exexcution{
    for (id item in self) {
        exexcution(item);
    }
}

@end
