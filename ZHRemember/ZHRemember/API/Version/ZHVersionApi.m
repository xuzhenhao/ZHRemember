//
//  ZHVersionApi.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/5.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "ZHVersionApi.h"
#import <AVOSCloud/AVOSCloud.h>

/**版本更新表名*/
NSString *const VersionClassName = @"Version";
/**版本号字段名*/
NSString *const VersionKeyName = @"num";
/**版本更新描述字段名*/
NSString *const VersionDescKeyName = @"desc";

@implementation ZHVersionApi
+ (void)getLatestVersionWithDoneHandler:(void (^)(NSString * versionNum,NSString *versionDesc))done{
    
    AVQuery *query = [AVQuery queryWithClassName:VersionClassName];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        AVObject *versionObj = objects.firstObject;
        NSString *versionNum = [versionObj objectForKey:VersionKeyName];
        NSString *versionDesc = [versionObj objectForKey:VersionDescKeyName];
        done(versionNum,versionDesc);
    }];
}
@end
