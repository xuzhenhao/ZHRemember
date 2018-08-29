//
//  ZHDBManager.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/29.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "ZHDBManager.h"
#import <FMDB/FMDB.h>

@interface ZHDBManager (){
    FMDatabaseQueue *_queue;
}

@end

@implementation ZHDBManager

static NSString *kDBName = @"com.zh.dbManager.db";

- (instancetype)init{
    return [self initWithDbName:kDBName];
}

- (instancetype)initWithDbName:(NSString *)dbName{
    NSParameterAssert(dbName != nil);
    
    if (self = [super init]) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *dbPath = [path stringByAppendingPathComponent:dbName];
        
        _queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    }
    return self;
}

+ (ZHDBManager *)manager{
    static ZHDBManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

#pragma mark - Private Method

- (BOOL)isTableExists:(NSString *)tableName{
    if (!_queue) {
        NSLog(@"the database open failure!");
        return NO;
    }
    __block BOOL exists = NO;
    [_queue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:@"SELECT name FROM sqlite_master WHERE type='table' AND name=?",tableName];
        while ([result next]) {
            if ([[result stringForColumnIndex:0] length] > 0) {
                exists = YES;
            }
        }
    }];
    //if not exists,created it
    if (!exists) {
        return [self createTable:tableName];
    }
    
    return exists;
}

- (BOOL)createTable:(NSString *)tableName{
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE %@ (createDate TEXT PRIMARY KEY,object TEXT NOT NULL, key TEXT NOT NULL)",tableName];
    
    __block BOOL result = NO;
    [_queue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql];
        if ([db hadError]) {
            NSLog(@"create table failure,error=%@",db.lastErrorMessage);
        }
    }];
    
    return result;
}

#pragma mark - Public Method

- (BOOL)insertObject:(id)object forKey:(NSString *)key atTable:(NSString *)tableName{
    NSParameterAssert(object != [NSNull null]);
    NSParameterAssert(object != nil);
    NSParameterAssert(key != nil);
    NSParameterAssert(tableName != nil);
    __block BOOL result = NO;
    if ([self isTableExists:tableName]) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
        NSString *objectStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSString *createDate = [NSString stringWithFormat:@"%@",@([[NSDate date] timeIntervalSince1970])];
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (createDate,object,key) VALUES (?,?,?)",tableName];
        
        [_queue inDatabase:^(FMDatabase *_db) {
            result = [_db executeUpdate:sql,createDate,objectStr,key];
            if ([_db hadError]) {
                NSLog(@"failure insert into table:%@, error:%@",tableName,_db.lastErrorMessage);
            }
        }];
    }
    [_queue close];
    return result;
}

- (BOOL)deleteObjectForKey:(NSString *)key atTable:(NSString *)tableName{
    NSParameterAssert(key != nil);
    NSParameterAssert(tableName != nil);
    
    __block BOOL result = NO;
    if ([self isTableExists:tableName]) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE key = ?",tableName];
        
        [_queue inDatabase:^(FMDatabase *_db) {
            result = [_db executeUpdate:sql,key];
            if ([_db hadError]) {
                NSLog(@"failure delete object with key:%@, error:%@",key,_db.lastErrorMessage);
            }
        }];
    }
    [_queue close];
    return result;
}

- (BOOL)deleteAllAtTable:(NSString *)tableName{
    NSParameterAssert(tableName != nil);
    
    __block BOOL result = NO;
    if ([self isTableExists:tableName]) {
        [_queue inDatabase:^(FMDatabase *_db) {
            result = [_db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@",tableName]];
            if ([_db hadError]) {
                NSLog(@"failure delete object with table:%@, error:%@",tableName,_db.lastErrorMessage);
            }
        }];
    }
    [_queue close];
    return result;
}

- (BOOL)updateObject:(id)object forKey:(NSString *)key atTable:(NSString *)tableName{
    NSParameterAssert(object != [NSNull null]);
    NSParameterAssert(key != nil);
    NSParameterAssert(tableName != nil);
    
    __block BOOL result = NO;
    if ([self isTableExists:tableName]) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
        NSString *objectStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET object = ? WHERE key = ?",tableName];
        
        [_queue inDatabase:^(FMDatabase *_db) {
            result = [_db executeUpdate:sql,objectStr,key];
            if ([_db hadError]) {
                NSLog(@"update failure at table:%@ with key:%@, error:%@",tableName,key,_db.lastErrorMessage);
            }
        }];
    }
    [_queue close];
    return result;
}

- (NSArray *)objectForKey:(NSString *)key atTable:(NSString *)tableName{
    NSParameterAssert(key != nil);
    NSParameterAssert(tableName != nil);
    NSMutableArray *array = [NSMutableArray array];
    if ([self isTableExists:tableName]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT object FROM %@ WHERE key = ?",tableName];
        
        [_queue inDatabase:^(FMDatabase *_db) {
            FMResultSet *rs = [_db executeQuery:sql,key];
            while ([rs next]) {
                NSData *data = [[NSData alloc] initWithBase64EncodedString:[rs stringForColumn:@"object"]
                                                                   options:NSDataBase64DecodingIgnoreUnknownCharacters];
                id object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                if (object != nil) {
                    [array addObject:object];
                }
            }
        }];
    }
    [_queue close];
    return [array copy];
}

- (NSArray *)objectsAtTable:(NSString *)tableName{
    NSParameterAssert(tableName != nil);
    NSMutableArray *array = [NSMutableArray array];
    
    if ([self isTableExists:tableName]) {
        [_queue inDatabase:^(FMDatabase *_db) {
            FMResultSet *rs = [_db executeQuery:[NSString stringWithFormat:@"SELECT object FROM %@ ORDER BY createDate Desc",tableName]];
            while ([rs next]) {
                NSData *data = [[NSData alloc] initWithBase64EncodedString:[rs stringForColumn:@"object"]
                                                                   options:NSDataBase64DecodingIgnoreUnknownCharacters];
                id object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                if (object != nil) {
                    [array addObject:object];
                }
            }
            [rs close];
        }];
    }
    [_queue close];
    return [array copy];
}

- (NSArray *)objectsAtTable:(NSString *)tableName offset:(NSInteger)offset limit:(NSInteger)limit{
    NSParameterAssert(tableName != nil);
    NSMutableArray *array = [NSMutableArray array];
    if ([self isTableExists:tableName]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT object FROM %@ ORDER BY createDate DESC LIMIT ? OFFSET ?",tableName];
        
        [_queue inDatabase:^(FMDatabase *_db) {
            FMResultSet *rs = [_db executeQuery:sql,@(limit),@(offset)];
            while ([rs next]) {
                NSData *data = [[NSData alloc] initWithBase64EncodedString:[rs stringForColumn:@"object"]
                                                                   options:NSDataBase64DecodingIgnoreUnknownCharacters];
                id object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                if (object != nil) {
                    [array addObject:object];
                }
            }
        }];
    }
    [_queue close];
    return [array copy];
}

- (NSArray *)getAllKeysAtTable:(NSString *)tableName{
    NSParameterAssert(tableName != nil);
    NSMutableArray *array = [NSMutableArray array];
    if ([self isTableExists:tableName]) {
        [_queue inDatabase:^(FMDatabase *_db) {
            FMResultSet *rs = [_db executeQuery:[NSString stringWithFormat:@"SELECT object FROM %@",tableName]];
            while ([rs next]) {
                NSString *key = [rs stringForColumn:@"key"];
                if (key != nil) {
                    [array addObject:key];
                }
            }
            [rs close];
        }];
    }
    [_queue close];
    return [array copy];
}
@end
