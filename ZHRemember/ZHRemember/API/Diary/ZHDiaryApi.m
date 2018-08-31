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

@implementation ZHDiaryApi

+ (void)saveDiary:(ZHDiaryModel *)diary
             done:(void(^)(BOOL success,NSDictionary *result))doneHandler{
    AVObject *diaryObj = [[AVObject alloc] initWithClassName:DiaryClassName];
    
    [self fillObject:diaryObj withDiary:diary];
    [diaryObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        doneHandler(succeeded,nil);
    }];
}

#pragma mark - utils
+ (void)fillObject:(AVObject *)diaryObj withDiary:(ZHDiaryModel *)diaryModel{
    [diaryObj setObject:[AVUser currentUser].objectId forKey:AVUserIdKey];
    [diaryObj setValue:diaryModel.diaryId forKey:AVObjectIdKey];
    [diaryObj setObject:diaryModel.diaryText forKey:DiaryClassTextKey];
    [diaryObj setObject:diaryModel.unixTime forKey:DiaryClassTimeKey];
}
@end
