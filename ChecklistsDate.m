//
//  ChecklistsDate.m
//  Checklists
//
//  Created by 马遥 on 15/7/6.
//  Copyright (c) 2015年 马遥. All rights reserved.
//

#import "ChecklistsDate.h"

@implementation ChecklistsDate

NSString *const primaryKey = @"INTEGER PRIMARY KEY NOT NULL";
NSString *const textType = @"TEXT";

//NSString *const listItemTableName = @"listItem";
NSString *const listItemID = @"listItem_id";
NSString *const listItemText = @"listItem_text";
NSString *const listItemChecked = @"checked";

NSString *const listsTableName = @"lists";
NSString *const listsID = @"lists_id";
NSString *const listsName = @"lists_name";

@synthesize dbManager;



- (id) init{
    self = [super init];
    if (self) {
        self.dbManager = [[DBManager alloc]init];
    }
    return self;
}

+ (ChecklistsDate *)shareManager{
    static ChecklistsDate *shareAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareAccountManagerInstance = [[self alloc] init];
    });
//    NSLog(@"shareManager");
    return shareAccountManagerInstance;
}


@end
