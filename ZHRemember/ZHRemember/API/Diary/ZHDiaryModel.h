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


@end
