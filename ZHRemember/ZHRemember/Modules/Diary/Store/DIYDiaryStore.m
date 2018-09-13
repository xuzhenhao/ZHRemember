//
//  DIYDiaryStore.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/13.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "DIYDiaryStore.h"
#import "ZHDiaryApi.h"
#import "ZHDBManager.h"
/**日记缓存表名*/
#define kDiaryStoreTable @"DIYDiaryStoreTableName"

@interface DIYDiaryStore()

@property (nonatomic, strong)   NSArray<ZHDiaryModel *>     *diarys;

@end

@implementation DIYDiaryStore

+ (instancetype)shared{
    static DIYDiaryStore *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}
- (void)loadDataWithPage:(NSInteger)page
                    done:(void(^)(BOOL succeed,NSError *error))done{
    //先加载本地的
    NSArray *localDiarys = [[ZHDBManager manager] objectsAtTable:kDiaryStoreTable];
    if (localDiarys.count > 0) {
        done(YES,nil);
        self.diarys = localDiarys;
    }
    
    //加载网络的
    @weakify(self)
    [ZHDiaryApi getDiaryListWithPage:page done:^(NSArray<ZHDiaryModel *> *diaryList, NSError *error) {
        @strongify(self)
        if (error) {
            done(NO,error);
            return ;
        }
        done(YES,nil);
        self.diarys = diaryList;
        [self _cacheLocalDiarys:diaryList];
    }];
    
}
- (void)saveDiary:(ZHDiaryModel *)diary
             done:(void(^)(BOOL succeed,NSError *error))done{
    if (!diary) {
        done(NO,[NSError errorWithDomain:@"" code:-1 userInfo:@{NSErrorDescKey:@"数据为空"}]);
        return;
    }
    //先本地更新
    if (!diary.diaryId) {
        //新增的
        diary.diaryId = [NSString zh_onlyID];
        //先本地保存
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:diary];
        [array addObjectsFromArray:self.diarys];
        self.diarys = [array copy];
        done(YES,nil);
        [self _cacheLocalDiarys:self.diarys];
    }else{
        //更新
        BOOL succeed = [[ZHDBManager manager] updateObject:diary forKey:diary.diaryId atTable:kDiaryStoreTable];
        if (succeed) {
            //重新加载到内存
            NSArray *localDiarys = [[ZHDBManager manager] objectsAtTable:kDiaryStoreTable];
            self.diarys = localDiarys;
            done(YES,nil);
        }
    }
    //同步网络
    __weak typeof(self)weakself = self;
    [ZHDiaryApi saveDiary:diary done:^(BOOL success, NSError *error) {
        if (error) {
            done(NO,error);
        }else{
            [weakself loadDataWithPage:0 done:^(BOOL succeed, NSError *error) {
                
            }];
        }
    }];
}
- (void)deleteDiaryWithObjectId:(NSString *)objectId
                        diaryId:(NSString *)diaryId
                           done:(void(^)(BOOL succeed,NSError *error))done{
    if (!diaryId) {
        done(NO,[NSError errorWithDomain:@"" code:-1 userInfo:@{NSErrorDescKey:@"数据为空"}]);
        return;
    }
    //先本地删除
    BOOL succeed = [[ZHDBManager manager] deleteObjectForKey:diaryId atTable:kDiaryStoreTable];
    if (succeed) {
        //重新加载到内存
        NSArray *localTags = [[ZHDBManager manager] objectsAtTable:kDiaryStoreTable];
        done(YES,nil);
        self.diarys = localTags;
    }
    if (objectId) {
        //同步网络
        [ZHDiaryApi deleteDiaryWithId:objectId done:^(BOOL success, NSError *error) {
            if (error) {
                done(NO,error);
            }
        }];
    }
}

#pragma mark - help
- (void)_cacheLocalDiarys:(NSArray<ZHDiaryModel *> *)diarys{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[ZHDBManager manager] deleteAllAtTable:kDiaryStoreTable];
        for (ZHDiaryModel *model in diarys) {
            [[ZHDBManager manager] insertObject:model forKey:model.diaryId atTable:kDiaryStoreTable];
        }
    });
}
@end
