//
//  ChecklistModel.h
//  Checklists
//
//  Created by 马遥 on 15/7/7.
//  Copyright (c) 2015年 马遥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChecklistModel : NSObject

- (ChecklistModel *)initWithID:(NSString *)listID andName:(NSString *)name iconName:(NSString *)imageName;;
- (int) countUncheckedItems;
+ (NSArray *) arrayOfPropertier;
+ (NSDictionary *) dictionaryOfPropertiesAndTypes;
- (void) deletListFromTable;
//- (NSDictionary *) dictionaryOfText:(NSString *)text iconName:(NSString *)imageName;
- (NSDictionary *) dictionaryOfdata;
- (void) updateNameAndIconNameToTable;
+ (NSArray *) arrayBySelectWhere:(NSDictionary *)conditions orderBy:(NSArray *)order from:(long)from to:(long)to;
- (void) insertItemToTable;
//- (void) updateIconNameFromTable;

@property (nonatomic,copy) NSString *list_id;
@property (nonatomic,copy) NSString *list_name;
@property (nonatomic,retain) NSMutableArray *listItems;
@property (nonatomic,retain) NSArray *columns;
@property (nonatomic,copy) NSString *listIconName;
@end
