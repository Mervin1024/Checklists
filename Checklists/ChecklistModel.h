//
//  ChecklistModel.h
//  Checklists
//
//  Created by 马遥 on 15/7/7.
//  Copyright (c) 2015年 马遥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChecklistModel : NSObject

- (ChecklistModel *)initWithID:(NSString *)listID andName:(NSString *)name;
//+ (int) countOfLists;
+ (NSArray *) arrayOfPropertier;
+ (NSDictionary *) dictionaryOfPropertiesAndTypes;
+ (void) deletListWithID:(NSString *)list_id;
- (NSDictionary *) dictionaryOfText:(NSString *)text;
- (NSDictionary *) dictionaryOfdata;

@property (nonatomic) NSString *list_id;
@property (nonatomic) NSString *list_name;
@property (nonatomic) NSMutableArray *listItems;
@property (nonatomic) NSArray *columns;
@end
