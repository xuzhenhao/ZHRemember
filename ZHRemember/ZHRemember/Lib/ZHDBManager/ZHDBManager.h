//
//  ZHDBManager.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/29.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 基于FMDB封装的通用缓存管理类
 */
@interface ZHDBManager : NSObject

+ (ZHDBManager *)manager;

/**
 *  插入object到指定的table
 *
 *  @param object    要插入的内容，不可为nil
 *  @param key       指定的key，不可nil
 *  @param tableName 要插入的table名称，不可nil
 *
 *  @return YES表示成功
 */
- (BOOL)insertObject:(id)object forKey:(NSString *)key atTable:(NSString *)tableName;
/**
 *  删除对应table中的指定对象
 *
 *  @param key       要删除的对象的key
 *  @param tableName 表名
 *
 *  @return YES表示成功
 */
- (BOOL)deleteObjectForKey:(NSString *)key atTable:(NSString *)tableName;
/**
 *  更新对应table中指定的对象
 *
 *  @param object    要更新的对象
 *  @param key       要更新的对象的key
 *  @param tableName 表名
 *
 *  @return YES表示成功
 */
- (BOOL)updateObject:(id)object forKey:(NSString *)key atTable:(NSString *)tableName;
/**
 *  删除指定表内的所有内容
 *
 *  @param tableName 表名
 *
 *  @return YES表示成功
 */
- (BOOL)deleteAllAtTable:(NSString *)tableName;
/**
 *  获取指定table内的指定对象
 *
 *  @param key       查询对应的key
 *  @param tableName 表名
 *
 *  @return 返回对象的列表，由于key不一定唯一，可能返回多条对象
 */
- (NSArray *)objectForKey:(NSString *)key atTable:(NSString *)tableName;
/**
 *  获取指定table内的所有对象
 *
 *  @param tableName 表名
 *
 *  @return 返回对象的列表
 */
- (NSArray *)objectsAtTable:(NSString *)tableName;
/**
 *  获取指定返回内的对象
 *
 *  @param tableName 表名
 *  @param offset    偏移量
 *  @param limit     限制条数
 *
 *  @return 返回对象的列表
 */
- (NSArray *)objectsAtTable:(NSString *)tableName offset:(NSInteger)offset limit:(NSInteger)limit;

/**
 获取指定table内所有key
 
 @param tableName 表名
 @return 返回的key列表
 */
- (NSArray *)getAllKeysAtTable:(NSString *)tableName;

@end
