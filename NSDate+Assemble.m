//
//  NSDate+Assemble.m
//  Checklists
//
//  Created by 马遥 on 15/7/8.
//  Copyright (c) 2015年 马遥. All rights reserved.
//

#import "NSDate+Assemble.h"

@implementation NSDate (Assemble)
- (NSString *)stringFromDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *date = [dateFormatter stringFromDate:self];
    return date;
}
@end
