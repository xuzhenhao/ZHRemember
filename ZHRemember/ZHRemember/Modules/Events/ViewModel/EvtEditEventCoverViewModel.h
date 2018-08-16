//
//  EvtEditEventCoverViewModel.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/14.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 编辑事件封面对应vm
 */
@interface EvtEditEventCoverViewModel : NSObject

@property (nonatomic, strong)   UIImage     *cover;

/** 封面数据*/
@property (nonatomic, strong)   NSData     *coverData;

+ (instancetype)viewModelWithCoverURL:(NSString *)coverString;

@property (nonatomic, strong)   RACSubject     *selectPhotoSubject;

@end
