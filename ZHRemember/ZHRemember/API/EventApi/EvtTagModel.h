//
//  EvtTagModel.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/20.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Mantle/Mantle.h>


/**
 事件标签
 */
@interface EvtTagModel : MTLModel<MTLJSONSerializing>
/** 标签id*/
@property (nonatomic, copy)     NSString    *tagId;
/** 标签名*/
@property (nonatomic, copy)     NSString    *tagName;
/** 标签类型*/
@property (nonatomic, assign)   NSInteger    tagType;

@end
