//
//  UserDefaults.h
//  Checklists
//
//  Created by 马遥 on 15/7/7.
//  Copyright (c) 2015年 马遥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaults : NSObject

+ (void) registerDefaults;
+ (NSInteger) indexOfSelectedChecklist;
+ (BOOL) boolOfFirstTime;
+ (void) setIndexOfSelectedChecklist:(NSInteger)index;
+ (void) setBoolOfFirstTime:(BOOL)no;

@end
