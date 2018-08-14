//
//  AppDelegate+ZHThirdPart.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/7/20.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "AppDelegate+ZHThirdPart.h"
#import <AVOSCloud/AVOSCloud.h>

#define AVOSCloudAppId @"OWMbwAs72wWfNRHS51jV5Tso-gzGzoHsz"
#define AVOSCloudAppkey @"LeFEoxaulIkxlIQx37YvadqU"

@implementation AppDelegate (ZHThirdPart)

- (void)zh_setupLeanCloudService{
    [AVOSCloud setApplicationId:AVOSCloudAppId clientKey:AVOSCloudAppkey];
    [AVOSCloud setAllLogsEnabled:NO];
    [self loginIn];
}
- (void)loginIn{
    
    [AVUser logInWithUsername:@"xuzhenhao" password:@"a123456" error:nil];
}
- (void)leanTest{
    AVObject *studentTom = [[AVObject alloc] initWithClassName:@"Student"];
    [studentTom setObject:@"Tom" forKey:@"name"];
    //对象内嵌
//    NSDictionary *addr = @{@"city":@"北京",@"address":@"长安街",@"postcode":@"10017"};
//    [studentTom setObject:addr forKey:@"address"];
    
    //对象引用
    AVObject *tomAddress = [[AVObject alloc] initWithClassName:@"Address"];
    [tomAddress setObject:@"北京" forKey:@"city"];
    [tomAddress setObject:@"长安街" forKey:@"street"];
    [studentTom setObject:tomAddress forKey:@"addressRef"];
    
    [studentTom saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
    }];
}
- (void)leanQueryTest{
    AVQuery *query = [AVQuery queryWithClassName:@"Student"];
    [query includeKey:@"addressRef"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
    }];
}

@end
