//
//  UserDefaults.m
//  Checklists
//
//  Created by 马遥 on 15/7/7.
//  Copyright (c) 2015年 马遥. All rights reserved.
//

#import "UserDefaults.h"
#import "ChecklistsDate.h"

@implementation UserDefaults

+ (void) registerDefaults{
    NSDictionary *dic = @{ChecklistIndex:@-1,firstTime:@YES};
    [[NSUserDefaults standardUserDefaults]registerDefaults:dic];
}

+ (BOOL) boolOfFirstTime{
    return [[NSUserDefaults standardUserDefaults]boolForKey:firstTime];
}

+ (NSInteger) indexOfSelectedChecklist{
    return [[NSUserDefaults standardUserDefaults]integerForKey:ChecklistIndex];
}

+ (void) setBoolOfFirstTime:(BOOL)no{
    [[NSUserDefaults standardUserDefaults]setBool:no forKey:firstTime];
}

+ (void) setIndexOfSelectedChecklist:(NSInteger)index{
    [[NSUserDefaults standardUserDefaults]setInteger:index forKey:ChecklistIndex];
}

@end
