//
//  ChecklistsDate.h
//  Checklists
//
//  Created by 马遥 on 15/7/6.
//  Copyright (c) 2015年 马遥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBManager.h"

@interface ChecklistsDate : NSObject
+ (ChecklistsDate *)shareManager;
@property (nonatomic,strong) DBManager *dbManager;

extern NSString *const primaryKey;
extern NSString *const textType;

//extern NSString *const listItemTableName;
extern NSString *const listItemID;
extern NSString *const listItemText;
extern NSString *const listItemChecked;

extern NSString *const listsTableName;
extern NSString *const listsID;
extern NSString *const listsName;
@end
