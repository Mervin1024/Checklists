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

- (ChecklistModel *)init{
    if ((self = [super init])) {
        dbManager = [ChecklistsDate shareManager].dbManager;
        columns = [ChecklistModel arrayOfPropertier];
        listItems = [NSMutableArray array];
    }
    return self;
}

- (ChecklistModel *)initWithID:(NSString *)listID andName:(NSString *)name{
    if ((self = [super init])) {
        dbManager = [ChecklistsDate shareManager].dbManager;
        columns = [ChecklistModel arrayOfPropertier];
        list_name = name;
        listItems = [NSMutableArray array];
        [listItems addObjectsFromArray:[dbManager arrayOfAllBySelect:[ChecklistItemModel arrayOfProperties] fromTable:name where:nil]];
        if (listID) {
            list_id = listID;
        }
    }
    return self;
}
//
//+ (int) countOfLists{
//    DBManager *dbManager = [ChecklistsDate shareManager].dbManager;
//    return [dbManager countOfItemsNumberInTable:listsTableName];
//}
//    
+ (NSArray *) arrayOfPropertier{
    return @[listsID,listsName];
}

+ (NSDictionary *) dictionaryOfPropertiesAndTypes{
    NSArray *types = @[primaryKey,textType];
    return [NSDictionary dictionaryWithObjects:types forKeys:[ChecklistModel arrayOfPropertier]];
}

+ (void) deletListWithID:(NSString *)list_id{
    DBManager *dbManager = [ChecklistsDate shareManager].dbManager;
    [dbManager deleteFromTableName:listsTableName where:@{listsID:list_id}];
}

- (NSDictionary *) dictionaryOfText:(NSString *)text{
    if (text) {
        list_name = text;
        return [NSDictionary dictionaryWithObjects:@[text] forKeys:@[listsName]];
    }
    return 0;
}

- (NSDictionary *) dictionaryOfdata{
    if (list_id) {
        return [NSDictionary dictionaryWithObjects:@[list_id,list_name] forKeys:@[listsID,listsName]];
    }
    return [NSDictionary dictionaryWithObjects:@[list_name] forKeys:@[listsName,]];
}


@end
