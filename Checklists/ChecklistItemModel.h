//
//  ChecklistsModel.h
//  Checklists
//
//  Created by 马遥 on 15/7/6.
//  Copyright (c) 2015年 马遥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChecklistItemModel : NSObject

- (ChecklistItemModel *)initChecklists;
- (ChecklistItemModel *)initWithTableName:(NSString *)name ListID:(NSString *)listID Text:(NSString *)text andChecked:(BOOL)check;
//+ (int) countOfLists;
+ (NSArray *) arrayOfProperties;
- (NSDictionary *) dictionaryOfdata;
//+ (NSArray *) arrayOfObjects:(NSArray *)objects;
//+ (NSDictionary *) dictionaryOfObject:(id)object;
+ (NSDictionary *) dictionaryOfPropertiesAndTypes;
- (void) deleteItemWithID:(NSString *)listID;
- (NSDictionary *) dictionaryOfText:(NSString *)text;
- (void) toggleChecked;
- (NSString *) stringWithChecked;

@property (nonatomic) NSString *list_tableName;
@property (nonatomic) NSString *list_id;
@property (nonatomic) NSString *list_text;
@property (nonatomic,assign) BOOL checked;
@property (nonatomic) NSArray *columns;
@end
