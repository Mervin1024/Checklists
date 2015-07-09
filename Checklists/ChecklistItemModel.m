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
#pragma mark- init
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
#pragma mark- dictionaryOfChecklistItem
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
#pragma mark- toggleChecked
- (void)toggleChecked{
    self.checked = !self.checked;
}
#pragma mark- initNSString
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
#pragma mark- operateToDBManager
- (void) insertItemToTable{
    [dbManager insertItemsToTableName:list_tableName columns:[self dictionaryOfdata]];
}

- (void) deleteItemWithID:(NSString *)listID{
    [dbManager deleteFromTableName:list_tableName where:@{listItemID:listID}];
}

- (void) updateStateToTable{
    [dbManager updateItemsTableName:list_tableName set:@{listItemText:self.list_text} where:@{listItemID:self.list_id}];
    [dbManager updateItemsTableName:list_tableName set:@{listItemShouldRemind:[self stringWithRemind]} where:@{listItemID:self.list_id}];
    [dbManager updateItemsTableName:list_tableName set:@{listItemDueDate:[self.dueDate stringFromDate]} where:@{listItemID:self.list_id}];
    
}

- (void) updateCheckedToTable{
    [dbManager updateItemsTableName:list_tableName set:@{listItemChecked:[self stringWithChecked]} where:@{listItemID:self.list_id}];
}

- (NSArray *) arrayBySelectWhere:(NSDictionary *)conditions orderBy:(NSArray *)order from:(long)from to:(long)to{
    return [dbManager arrayBySelect:self.columns fromTable:self.list_tableName where:conditions orderBy:order from:from to:to];
}
#pragma mark- UILocalNotification
-(UILocalNotification*)notificationForThisItem{
    NSArray *allNotifications = [[UIApplication sharedApplication]scheduledLocalNotifications];
    for(UILocalNotification *notification in allNotifications){
        NSString *number = [notification.userInfo objectForKey:listItemID];
        if(number != nil && [[NSString stringWithFormat:@"%@",number] isEqualToString:[NSString stringWithFormat:@"%@_%@",self.list_tableName,self.list_id]]){
            return notification;
        }
    }
    return nil;
}

- (void) scheduleNotification{

    UILocalNotification *existingNotification = [self notificationForThisItem];

    if (existingNotification != nil) {
        NSLog(@"发现已有消息通知并删除");
        [[UIApplication sharedApplication]cancelLocalNotification:existingNotification];
    }else{
        NSLog(@"没有发现消息通知");
    }
    if (self.shouldRemind && [self.dueDate compare:[NSDate date]] != NSOrderedAscending) {
        UILocalNotification *localNotification = [[UILocalNotification alloc]init];
        localNotification.fireDate = self.dueDate;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        
        localNotification.alertBody = self.list_text;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.userInfo = @{listItemID:[NSString stringWithFormat:@"%@_%@",self.list_tableName,self.list_id]};
        [[UIApplication sharedApplication]scheduleLocalNotification:localNotification];
        NSLog(@"建立消息通知");
    }
}


@end
