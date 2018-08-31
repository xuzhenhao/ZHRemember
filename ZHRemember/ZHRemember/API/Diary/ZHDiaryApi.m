//
//  ZHDiaryApi.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/30.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "ZHDiaryApi.h"
#import <AVOSCloud/AVOSCloud.h>
#import "AVObject+ApiExt.h"

/**日记表名*/
NSString *const DiaryClassName = @"Diary";
/**日记表，日记文字key*/
NSString *const DiaryClassTextKey = @"diary_text";
/**日记表，时间key*/
NSString *const DiaryClassTimeKey = @"create_time";
/**日记表，天气图片key*/
NSString *const DiaryClassWeatherKey = @"weather_image";
/**日记表，心情图片key*/
NSString *const DiaryClassMoodKey = @"mood_image";

@implementation ZHDiaryApi

+ (void)saveDiary:(ZHDiaryModel *)diary
             done:(void(^)(BOOL success,NSDictionary *result))doneHandler{
    AVObject *diaryObj = [[AVObject alloc] initWithClassName:DiaryClassName];
    
    [self fillObject:diaryObj withDiary:diary];
    [diaryObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        doneHandler(succeeded,nil);
    }];
}
+ (void)getDiaryListWithPage:(NSInteger)page
                        done:(void(^)(NSArray<ZHDiaryModel *> *diaryList,NSDictionary *result))doneHandler{
    AVQuery *query = [AVQuery queryWithClassName:DiaryClassName];
    [query whereKey:AVUserIdKey equalTo:[AVUser currentUser].objectId];
    
    query.limit = AVPerPageCount;
    query.skip = page * AVPerPageCount;
    [query orderByDescending:@"create_time"];//最近的日记在前面
    
    NSMutableArray *tempM = [NSMutableArray array];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        for (AVObject *obj in objects) {
            NSDictionary *dict = [obj zh_localData];
            [dict setValue:obj.objectId forKey:AVObjectIdKey];
            [tempM addObject:dict];
        }
        NSArray *lists = [MTLJSONAdapter modelsOfClass:[ZHDiaryModel class] fromJSONArray:tempM error:nil];
        doneHandler(lists,nil);
    }];
}

#pragma mark - utils
+ (void)fillObject:(AVObject *)diaryObj withDiary:(ZHDiaryModel *)diaryModel{
    [diaryObj setObject:[AVUser currentUser].objectId forKey:AVUserIdKey];
    [diaryObj setValue:diaryModel.diaryId forKey:AVObjectIdKey];
    [diaryObj setObject:diaryModel.diaryText forKey:DiaryClassTextKey];
    [diaryObj setObject:diaryModel.unixTime forKey:DiaryClassTimeKey];
    [diaryObj setObject:diaryModel.weatherImageName forKey:DiaryClassWeatherKey];
    [diaryObj setObject:diaryModel.moodImageName forKey:DiaryClassMoodKey];
}
@end
