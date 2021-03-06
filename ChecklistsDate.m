//
//  ChecklistsDate.m
//  Checklists
//
//  Created by 马遥 on 15/7/6.
//  Copyright (c) 2015年 马遥. All rights reserved.
//

#import "ChecklistsDate.h"

@implementation ChecklistsDate
#pragma mark - const NSString
NSString *const primaryKey = @"INTEGER PRIMARY KEY NOT NULL";
NSString *const textType = @"TEXT";

NSString *const iconName = @"iconName";

NSString *const listItemID = @"listItem_id";
NSString *const listItemText = @"listItem_text";
NSString *const listItemChecked = @"checked";
NSString *const listItemDueDate = @"dueDate";
NSString *const listItemShouldRemind = @"shouldRemind";

NSString *const listsTableName = @"lists";
NSString *const listsID = @"lists_id";
NSString *const listsName = @"lists_name";

NSString *const ChecklistIndex = @"ChecklistIndex";
NSString *const firstTime = @"FirstTime";

@synthesize dbManager;


#pragma mark- init
- (id) init{
    self = [super init];
    if (self) {
        self.dbManager = [[DBManager alloc]init];
    }
    return self;
}
#pragma mark- shareManager
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
