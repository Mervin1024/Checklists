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

- (ChecklistItemModel *)initChecklists{
    if ((self = [super init])) {
        dbManager = [ChecklistsDate shareManager].dbManager;
        self.checked = NO;
        columns = [ChecklistItemModel arrayOfProperties];
    }
    return self;
}

- (ChecklistItemModel *)initWithTableName:(NSString *)name ListID:(NSString *)listID Text:(NSString *)text andChecked:(BOOL)check{
    if ((self = [super init])) {
        dbManager = [ChecklistsDate shareManager].dbManager;
        columns = [ChecklistItemModel arrayOfProperties];
        if (listID) {
            list_id = listID;
        }
        list_tableName = name;
        list_text = text;
        checked = check;
    }
    return self;
}
//
//+ (int) countOfLists{
//    DBManager *dbManager = [ChecklistsDate shareManager].dbManager;
//    return [dbManager countOfItemsNumberInTable:self];
//}

+ (NSArray *) arrayOfProperties{
    return @[listItemID,listItemText,listItemChecked];
}

- (NSDictionary *) dictionaryOfdata{
    if (list_id) {
        return [NSDictionary dictionaryWithObjects:@[list_id,list_text,[self stringWithChecked]] forKeys:@[listItemID,listItemText,listItemChecked]];
    }
    return [NSDictionary dictionaryWithObjects:@[list_text,[self stringWithChecked]] forKeys:@[listItemText,listItemChecked]];
}

+ (NSDictionary *) dictionaryOfPropertiesAndTypes{
    NSArray *types = @[primaryKey,textType,textType];
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

- (NSDictionary *)dictionaryOfText:(NSString *)text{
    if (text) {
        list_text = text;
        return [NSDictionary dictionaryWithObjects:@[text,[self stringWithChecked]] forKeys:@[listItemText,listItemChecked]];
    }
    return 0;
}

@end
