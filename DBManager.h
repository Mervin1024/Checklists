//
//  DBManager.h
//  Checklists
//
//  Created by 马遥 on 15/7/6.
//  Copyright (c) 2015年 马遥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMDatabaseAdditions.h"

@interface DBManager : NSObject
- (void) connectDB;
- (BOOL) createTableName:(NSString *)name columns:(NSDictionary *)columns;
- (NSArray *) arrayBySelect:(NSArray *)columns fromTable:(NSString *)name where:(NSDictionary *)conditions orderBy:(NSArray *)order from:(long)from to:(long)to;
- (int) countOfItemsNumberInTable:(NSString *)name where:(NSDictionary *)conditions;
- (BOOL) insertItemsToTableName:(NSString *)name columns:(NSDictionary *)columns;
- (BOOL) updateItemsTableName:(NSString *)name set:(NSDictionary *)columns where:(NSDictionary *)conditions;
- (BOOL) deleteFromTableName:(NSString *)name where:(NSDictionary *)conditions;
- (BOOL) dropTableName:(NSString *)name;
- (BOOL) alterTableName:(NSString *)name toNewName:(NSString *)newName;
- (BOOL) excuteSQLs:(NSArray *) sqls;

@end
