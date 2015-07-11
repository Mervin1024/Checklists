//
//  ChecklistsModel.h
//  Checklists
//
//  Created by 马遥 on 15/7/6.
//  Copyright (c) 2015年 马遥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ChecklistItemModel : NSObject

- (ChecklistItemModel *)initChecklists;
- (ChecklistItemModel *)initWithTableName:(NSString *)name ListID:(NSString *)listID Text:(NSString *)text Checked:(BOOL)check dueDate:(NSDate *)date shouldRemind:(BOOL)remind;;
+ (NSArray *) arrayOfProperties;
- (NSDictionary *) dictionaryOfdata;
+ (NSDictionary *) dictionaryOfPropertiesAndTypes;
- (void) deleteItemWithID:(NSString *)listID;
- (void) toggleChecked;
- (NSString *) stringWithChecked;
- (NSString *)stringWithRemind;
- (void) insertItemToTable;
- (NSArray *) arrayBySelectWhere:(NSDictionary *)conditions orderBy:(NSArray *)order from:(long)from to:(long)to;
- (void) updateStateToTable;
- (void) updateCheckedToTable;
- (void) scheduleNotification;
-(UILocalNotification*)notificationForThisItem;

@property (nonatomic,copy) NSString *list_tableName;
@property (nonatomic,copy) NSString *list_id;
@property (nonatomic,copy) NSString *list_text;
@property (nonatomic,assign) BOOL checked;
@property (nonatomic,retain) NSArray *columns;
@property (nonatomic,retain) NSDate *dueDate;
@property (nonatomic,assign) BOOL shouldRemind;
@end
