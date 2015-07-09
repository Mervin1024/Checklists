//
//  NSDictionary+Assemble.m
//  Checklists
//
//  Created by 马遥 on 15/7/6.
//  Copyright (c) 2015年 马遥. All rights reserved.
//

#import "NSDictionary+Assemble.h"
#import "NSArray+Assemble.h"
#import "NSString+Format.h"
#import "ChecklistsDate.h"

@implementation NSDictionary (Assemble)

- (NSString *) stringByJoinSimplyWithSpaceCharacter:(NSString *)spaceCharacter andBoundary:(NSString *)boundary{
    NSString *string;
    NSArray *keys = [self allKeys];
    NSMutableArray *pairs = [NSMutableArray array];
    for (NSString *key in keys) {
        NSString *value = [self objectForKey:key];
        NSString *assemble = key;
        assemble = [assemble stringByAppendingFormat:@"%@%@",spaceCharacter,value];
        [pairs addObject:assemble];
    }
    string = [pairs stringByJoinSimplyWithBoundary:boundary];
    return string;
}

- (NSString *) stringByJoinEntireWithSpaceCharacter:(NSString *)spaceCharacter andBoundary:(NSString *)boundary{
    NSString *string;
    NSArray *keys = [self allKeys];
    NSMutableArray *pairs = [NSMutableArray array];
    for (NSString *key in keys) {
        NSString *value = [self objectForKey:key];
        NSString *assemble = key;
        assemble = [assemble stringByAppendingFormat:@"%@%@",spaceCharacter,[value stringSwapWithBoundary:@"'"]];
        [pairs addObject:assemble];
    }
    string = [pairs stringByJoinSimplyWithBoundary:boundary];
    return string;
}

- (NSComparisonResult)comparelist:(NSDictionary *)otherObject{
    return [[self objectForKey:listsName] localizedStandardCompare:[otherObject objectForKey:listsName]];
}

- (NSComparisonResult)compareItem:(NSDictionary *)otherObject{
    return [[self objectForKey:listItemDueDate] localizedStandardCompare:[otherObject objectForKey:listItemDueDate]];
}

@end
