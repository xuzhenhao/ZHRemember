//
//  ZHDiaryModel.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/30.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface ZHDiaryModel : MTLModel<MTLJSONSerializing>

/** 日记id*/
@property (nonatomic, copy)     NSString    *diaryId;
/** 时间戳*/
@property (nonatomic, copy)     NSString    *unixTime;
/** 文本内容*/
@property (nonatomic, copy)     NSString    *diaryText;
/** 日记图片*/
@property (nonatomic, copy)     NSString    *diaryImageURL;
/** 天气图片名称*/
@property (nonatomic, copy)     NSString    *weatherImageName;
/** 心情图片名称*/
@property (nonatomic, copy)     NSString    *moodImageName;
/** 信纸图片名称*/
@property (nonatomic, copy)     NSString    *wallPaperName;


@end
