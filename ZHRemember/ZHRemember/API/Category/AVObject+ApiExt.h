//
//  AVObject+ApiExt.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/21.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface AVObject (ApiExt)

/**
 获取字典形式的数据

 @return 返回字典形式的数据
 */
- (NSDictionary *)localData;

@end
