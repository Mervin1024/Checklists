//
//  NSString+Format.h
//  Checklists
//
//  Created by 马遥 on 15/7/6.
//  Copyright (c) 2015年 马遥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Format)

- (NSString *) stringSwapWithBoundary:(NSString *)boundary;
- (BOOL) isYes;
- (NSDate *)dateFromString;

@end
