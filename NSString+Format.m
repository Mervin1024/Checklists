//
//  NSString+Format.m
//  Checklists
//
//  Created by 马遥 on 15/7/6.
//  Copyright (c) 2015年 马遥. All rights reserved.
//

#import "NSString+Format.h"

@implementation NSString (Format)

- (NSString *) stringSwapWithBoundary:(NSString *)boundary{
    NSString *string = boundary;
    string = [string stringByAppendingString:self];
    string = [string stringByAppendingString:boundary];
    return string;
}

- (BOOL) isYes{
    if ([self isEqualToString:@"YES"]) {
        return YES;
    }else
        return NO;
}

- (NSDate *)dateFromString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:self];
    return date;
}

@end
