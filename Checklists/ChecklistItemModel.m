//
//  ChecklistsModel.m
//  Checklists
//
//  Created by 马遥 on 15/7/6.
//  Copyright (c) 2015年 马遥. All rights reserved.
//

#import "ChecklistItemModel.h"
#import "DBManager.h"
#import "ChecklistsDate.h"
#import "NSArray+Assemble.h"
#import "NSDictionary+Assemble.h"
#import "NSString+Format.h"
#import "NSDate+Assemble.h"

@interface ChecklistItemModel(){
    DBManager *dbManager;
}

@end


@implementation ChecklistItemModel
@synthesize list_text;
@synthesize list_id;
@synthesize checked;
@synthesize columns;
@synthesize list_tableName;
@synthesize dueDate;
@synthesize shouldRemind;

- (ChecklistItemModel *)initChecklists{
    if ((self = [super init])) {
        dbManager = [ChecklistsDate shareManager].dbManager;
        self.checked = NO;
        columns = [ChecklistItemModel arrayOfProperties];
    }
    return self;
}

- (ChecklistItemModel *)initWithTableName:(NSString *)name ListID:(NSString *)listID Text:(NSString *)text Checked:(BOOL)check dueDate:(NSDate *)date shouldRemind:(BOOL)remind{
    if ((self = [super init])) {
        dbManager = [ChecklistsDate shareManager].dbManager;
        columns = [ChecklistItemModel arrayOfProperties];
        list_id = listID;
        list_tableName = name;
        list_text = text;
        checked = check;
        dueDate = date;
        shouldRemind = remind;
    }
    return self;
}
//
//+ (int) countOfLists{
//    DBManager *dbManager = [ChecklistsDate shareManager].dbManager;
//    return [dbManager countOfItemsNumberInTable:self];
//}

+ (NSArray *) arrayOfProperties{
    return @[listItemID,listItemText,listItemChecked,listItemShouldRemind,listItemDueDate];
}

- (NSDictionary *) dictionaryOfdata{
    if (list_id) {
        return [NSDictionary dictionaryWithObjects:@[list_id,list_text,[self stringWithChecked],[self stringWithRemind],[dueDate stringFromDate]] forKeys:@[listItemID,listItemText,listItemChecked,listItemShouldRemind,listItemDueDate]];
    }
    return [NSDictionary dictionaryWithObjects:@[list_text,[self stringWithChecked],[self stringWithRemind],[dueDate stringFromDate]] forKeys:@[listItemText,listItemChecked,listItemShouldRemind,listItemDueDate]];
}

+ (NSDictionary *) dictionaryOfPropertiesAndTypes{
    NSArray *types = @[primaryKey,textType,textType,textType,textType];
    return [NSDictionary dictionaryWithObjects:types forKeys:[ChecklistItemModel arrayOfProperties]];
}

- (void) deleteItemWithID:(NSString *)listID{
    [dbManager deleteFromTableName:list_tableName where:@{listItemID:listID}];
}

- (void)toggleChecked{
    self.checked = !self.checked;
}

- (NSString *)stringWithChecked{
    if (self.checked) {
        return @"YES";
    }else
        return @"NO";
}

- (NSString *)stringWithRemind{
    if (self.shouldRemind) {
        return @"YES";
    }else
        return @"NO";
}

- (void) insertItemToTable{
    [dbManager insertItemsToTableName:list_tableName columns:[self dictionaryOfdata]];
}

- (void) updateStateToTable{
    [dbManager updateItemsTableName:list_tableName set:@{listItemText:self.list_text} where:@{listItemID:self.list_id}];
    [dbManager updateItemsTableName:list_tableName set:@{listItemShouldRemind:[self stringWithRemind]} where:@{listItemID:self.list_id}];
    [dbManager updateItemsTableName:list_tableName set:@{listItemDueDate:[self.dueDate stringFromDate]} where:@{listItemID:self.list_id}];
}

- (void) updateCheckedToTable{
    [dbManager updateItemsTableName:list_tableName set:@{listItemChecked:[self stringWithChecked]} where:@{listItemID:self.list_id}];
}

@end
