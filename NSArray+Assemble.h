//
//  NSArray+Assemble.h
//  Checklists
//
//  Created by 马遥 on 15/7/6.
//  Copyright (c) 2015年 马遥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Assemble)

- (NSString *) stringByJoinSimplyWithBoundary:(NSString *)boundary;
- (NSString *) stringByJoinEntireWithBoundary:(NSString *)boundary;
- (NSArray *) arrayByMap:(id (^)(id)) map;
- (NSArray *) arrayBySelect:(BOOL (^)(id)) select;
- (void) excetueEach:(void (^)(id)) exexcution;

@end
