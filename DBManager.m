//
//  DBManager.m
//  Checklists
//
//  Created by 马遥 on 15/7/6.
//  Copyright (c) 2015年 马遥. All rights reserved.
//

#import "DBManager.h"
#import "NSDictionary+Assemble.h"
#import "NSArray+Assemble.h"
#import "NSString+Format.h"

@implementation DBManager{
    FMDatabaseQueue *dBQueue;
}
#pragma mark - Supporting Utils
- (NSString *)dbPath:(NSString *)name{
    NSArray *documentsPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *databaseFilePath = [[documentsPaths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_Mervin.sql",name]];
    return databaseFilePath;
}

- (NSString *) makeSqlString:(NSDictionary *)columns{
//    NSLog(@"makeSQLString");
    NSArray *keys = [columns allKeys];
    NSMutableArray *pairs = [NSMutableArray array];
    for (NSString *key in keys) {
        NSString *type = [columns objectForKey:key];
        NSString *assemble = [key stringSwapWithBoundary:@"'"];
        assemble = [assemble stringByAppendingFormat:@" %@",type];
        [pairs addObject:assemble];
    }
    NSString *string = [pairs stringByJoinSimplyWithBoundary:@","];
//    NSLog(@"SqlString:%@",string);
    return string;
}
#pragma mark - init
- (id)init{
    self = [super init];
    if (self) {
        dBQueue = [FMDatabaseQueue databaseQueueWithPath:[self dbPath:@"Checklists3_db"]];
    }
    return self;
}
#pragma mark - connectDB
- (void) connectDB{
    dBQueue = [FMDatabaseQueue databaseQueueWithPath:[self dbPath:@"Checklists3_db"]];
}
#pragma mark - createTable
- (BOOL) createTableName:(NSString *)name columns:(NSDictionary *)columns{
    NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' (%@)",name,[self makeSqlString:columns]];
    NSLog(@"sqlCreateTable:%@",sqlCreateTable);
    [dBQueue inDatabase:^(FMDatabase *db){
        [db executeUpdate:sqlCreateTable];
        NSLog(@"createTable");
    }];
    return YES;
}
#pragma mark - Query
- (NSArray *) arrayOfAllBySelect:(NSArray *)columns fromTable:(NSString *)name where:(NSDictionary *)conditions{
//    NSLog(@"select");
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM '%@'",name];
    if (conditions) {
        sql = [sql stringByAppendingString:[NSString stringWithFormat:@" WHERE %@",[conditions stringByJoinEntireWithSpaceCharacter:@" = " andBoundary:@" AND "]]];
    }
//    NSLog(@"select:%@",sql);
    __block NSMutableArray *data = [NSMutableArray array];
    [dBQueue inDatabase:^(FMDatabase *db){
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSMutableDictionary *item = [NSMutableDictionary dictionary];
            for (int i = 0; i < columns.count; i++) {
                NSString *value = [rs stringForColumn:columns[i]];
                if (value != nil) {
//                    NSLog(@"SelectCount:%d",i);
//                    NSLog(@"Selectkey:%@,value:%@",columns[i],value);
                    [item setValue:value forKey:columns[i]];
                }
            }
            [data addObject:item];
        }
        [rs close];
    }];
    return data;
}

- (NSArray *) arrayOfAllBySelect:(NSArray *)columns fromTable:(NSString *)name where:(NSDictionary *)conditions orderBy:(NSArray *)order{
    __block NSMutableArray *data = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM '%@'",name];
    if (conditions) {
        sql = [sql stringByAppendingString:[NSString stringWithFormat:@" WHERE %@",[conditions stringByJoinEntireWithSpaceCharacter:@" = " andBoundary:@" AND "]]];
    }
    if (order) {
        sql = [sql stringByAppendingString:[NSString stringWithFormat:@" ORDER BY %@",[order stringByJoinSimplyWithBoundary:@","]]];
    }
    [dBQueue inDatabase:^(FMDatabase *db){
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSMutableDictionary *item = [NSMutableDictionary dictionary];
            for (int i = 0; i < columns.count; i++) {
                NSString *value = [rs stringForColumn:columns[i]];
                if (value != nil) {
                    NSLog(@"Count:%d",i);
                    [item setValue:value forKey:columns[i]];
                }
            }
            [data addObject:item];
        }
        [rs close];
    }];

    return data;
}

- (NSArray *) arrayBySelect:(NSArray *)columns fromTable:(NSString *)name where:(NSDictionary *)conditions orderBy:(NSArray *)order from:(long)from to:(long)to{
    __block NSMutableArray *data = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM '%@'",name];
    if (conditions) {
        sql = [sql stringByAppendingString:[NSString stringWithFormat:@" WHERE %@",[conditions stringByJoinEntireWithSpaceCharacter:@" = " andBoundary:@" AND "]]];
    }
    if (order) {
        sql = [sql stringByAppendingString:[NSString stringWithFormat:@" ORDER BY %@",[order stringByJoinSimplyWithBoundary:@","]]];
    }
//    NSString *_from = @"1";
//    NSString *_to = @"1";
    long _to = 100000;
    long _from = 0;
    if (from > 0) {
         _from = from;
        if (to > from) {
            _to = to;
        }
    }
    
    NSLog(@"select:%@",sql);
    [dBQueue inDatabase:^(FMDatabase *db){
        FMResultSet *rs = [db executeQuery:sql];
        for (int first = 0; [rs next] && first < _to; first++) {
//            NSLog(@"Count in seart:%d",first);
            if (first >= _from && first < _to) {
                NSMutableDictionary *itme = [NSMutableDictionary dictionary];
                for (int i = 0; i < columns.count; i++) {
                    NSString *value = [rs stringForColumn:columns[i]];
                    if (value != nil) {
//                        NSLog(@"Count:%d",i);
                        [itme setValue:value forKey:columns[i]];
                    }
                }
                [data addObject:itme];
            }
        }
        [rs close];
    }];
    return data;
}

- (int) countOfItemsNumberInTable:(NSString *)name where:(NSDictionary *)conditions{
    __block int itemsCount = 0;
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM '%@'",name];
    if (conditions) {
        sql = [sql stringByAppendingString:[NSString stringWithFormat:@" WHERE %@",[conditions stringByJoinEntireWithSpaceCharacter:@" = " andBoundary:@" AND "]]];
    }
    [dBQueue inDatabase:^(FMDatabase *db){
        itemsCount = [db intForQuery:sql];
    }];
//    NSLog(@"count of items:%d",itemsCount);
    return itemsCount;
}
#pragma mark - insert
- (BOOL) insertItemsToTableName:(NSString *)name columns:(NSDictionary *)columns{
    NSArray *keys = [columns allKeys];
    NSArray *values = [columns allValues];
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO '%@' (%@) VALUES (%@)",name,[keys stringByJoinEntireWithBoundary:@","],[values stringByJoinEntireWithBoundary:@","]];
    [dBQueue inDatabase:^(FMDatabase *db){
        [db executeUpdate:sql];
        NSLog(@"insert into");
    }];
    return YES;
}
#pragma mark - updateItems
- (BOOL) updateItemsTableName:(NSString *)name set:(NSDictionary *)columns where:(NSDictionary *)conditions{
    NSString *sql = [NSString stringWithFormat:@"UPDATE '%@' SET %@ WHERE %@",name,[columns stringByJoinEntireWithSpaceCharacter:@" = " andBoundary:@" AND "],[conditions stringByJoinEntireWithSpaceCharacter:@" = " andBoundary:@" AND "]];
    [dBQueue inDatabase:^(FMDatabase *db){
        [db executeUpdate:sql];
        NSLog(@"updateItems:%@",sql);
    }];
    return YES;
}
#pragma mark - delete=
- (BOOL) deleteFromTableName:(NSString *)name where:(NSDictionary *)conditions{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM '%@' WHERE %@",name,[conditions stringByJoinEntireWithSpaceCharacter:@" = " andBoundary:@" AND "]];
    [dBQueue inDatabase:^(FMDatabase *db){
        [db executeUpdate:sql];
        NSLog(@"deleteItem");
    }];
    return YES;
}

- (BOOL) dropTableName:(NSString *)name{
    NSString *sql = [NSString stringWithFormat:@"DROP TABLE '%@'",name];
    [dBQueue inDatabase:^(FMDatabase *db){
        [db executeUpdate:sql];
        NSLog(@"drop table");
    }];
    return YES;
}
#pragma mark - alter
- (BOOL) alterTableName:(NSString *)name toNewName:(NSString *)newName{
    NSString *sql = [NSString stringWithFormat:@"ALTER TABLE '%@' RENAME TO '%@'",name,newName];
    [dBQueue inDatabase:^(FMDatabase *db){
        [db executeUpdate:sql];
        NSLog(@"rename");
    }];
    return YES;
}

#pragma mark - executeUpdate
- (BOOL) excuteSQLs:(NSArray *)sqls{
    [dBQueue inDatabase:^(FMDatabase *db){
        NSLog(@"excuteSql");
        for (NSString *sql in sqls) {
            [db executeUpdate:sql];
        }
    }];
    return YES;
}

@end
