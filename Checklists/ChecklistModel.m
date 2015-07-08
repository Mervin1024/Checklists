//
//  ChecklistModel.m
//  Checklists
//
//  Created by 马遥 on 15/7/7.
//  Copyright (c) 2015年 马遥. All rights reserved.
//

#import "ChecklistModel.h"
#import "DBManager.h"
#import "ChecklistsDate.h"
#import "ChecklistItemModel.h"

@implementation ChecklistModel{
    DBManager *dbManager;
}
@synthesize list_name;
@synthesize list_id;
@synthesize columns;
@synthesize listItems;
@synthesize listIconName;

- (ChecklistModel *)init{
    if ((self = [super init])) {
        dbManager = [ChecklistsDate shareManager].dbManager;
        columns = [ChecklistModel arrayOfPropertier];
        listItems = [NSMutableArray array];
        listIconName = @"No icon";
    }
    return self;
}

- (ChecklistModel *)initWithID:(NSString *)listID andName:(NSString *)name iconName:(NSString *)imageName{
    if ((self = [super init])) {
        dbManager = [ChecklistsDate shareManager].dbManager;
        columns = [ChecklistModel arrayOfPropertier];
        list_name = name;
        listItems = [NSMutableArray array];
        [listItems addObjectsFromArray:[dbManager arrayOfAllBySelect:[ChecklistItemModel arrayOfProperties] fromTable:name where:nil]];
        if (listID) {
            list_id = listID;
        }
        if (imageName) {
            listIconName = imageName;
        }
    }
    return self;
}

- (int) countUncheckedItems{
    int count = 0;
    for (NSDictionary *item in self.listItems) {
        NSString *checked = [item objectForKey:listItemChecked];
        if ([checked isEqualToString:@"NO"]) {
            count += 1;
        }
    }
    return count;
}

+ (NSArray *) arrayOfPropertier{
    return @[listsID,listsName,iconName];
}

+ (NSDictionary *) dictionaryOfPropertiesAndTypes{
    NSArray *types = @[primaryKey,textType,textType];
    return [NSDictionary dictionaryWithObjects:types forKeys:[ChecklistModel arrayOfPropertier]];
}

+ (void) deletListWithID:(NSString *)list_id{
    DBManager *dbManager = [ChecklistsDate shareManager].dbManager;
    [dbManager deleteFromTableName:listsTableName where:@{listsID:list_id}];
}

//- (NSDictionary *) dictionaryOfText:(NSString *)text iconName:(NSString *)imageName{
//    list_name = text;
//    NSMutableArray *values = [NSMutableArray arrayWithObject:text];
//    NSMutableArray *keys = [NSMutableArray arrayWithObject:listsName];
//    if (imageName) {
//        listIconName = imageName;
//        [values addObject:imageName];
//        [keys addObject:iconName];
//    }
//    return [NSDictionary dictionaryWithObjects:values forKeys:keys];
//}

- (NSDictionary *) dictionaryOfdata{
    if (list_id) {
        return [NSDictionary dictionaryWithObjects:@[list_id,list_name,listIconName] forKeys:@[listsID,listsName,iconName]];
    }
    return [NSDictionary dictionaryWithObjects:@[list_name,listIconName] forKeys:@[listsName,iconName]];
}

- (void) updateNameAndIconNameToTable{
    [dbManager updateItemsTableName:listsTableName set:@{listsName:self.list_name} where:@{listsID:self.list_id}];
    [dbManager updateItemsTableName:listsTableName set:@{iconName:self.listIconName} where:@{listsID:self.list_id}];
}

+ (NSArray *)arrayBySelectWhere:(NSDictionary *)conditions orderBy:(NSArray *)order from:(long)from to:(long)to{
    return [[ChecklistsDate shareManager].dbManager arrayBySelect:[ChecklistModel arrayOfPropertier] fromTable:listsTableName where:conditions orderBy:order from:from to:to];
}

- (void) insertItemToTable{
    [dbManager insertItemsToTableName:listsTableName columns:[self dictionaryOfdata]];
}

@end
