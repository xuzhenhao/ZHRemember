//
//  ZHVersionManager.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/5.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "ZHVersionManager.h"
#import "ZHVersionApi.h"

@interface ZHVersionManager()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation ZHVersionManager

+ (instancetype)sharedManager{
    static ZHVersionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]init];
    });
    return manager;
}
- (void)checkUpdateVersionWithDoneHandler:(void (^)(BOOL isNewVersion,NSString *versionDesc))done{
    __weak typeof(self)weakself = self;
    //如果当天已经提示过了，直接返回
    if ([self todayIsShowed]) {
        done(NO,nil);
        return;
    }
    
    [ZHVersionApi getLatestVersionWithDoneHandler:^(NSString *versionNum, NSString *versionDesc) {
        NSString *localVersion = [weakself appLocalVersion];
        
        BOOL isNewVersion = [weakself isNewVersionWithServerVersion:versionNum localVersion:localVersion];
        done(isNewVersion,versionDesc);
    }];
}

#pragma mark - utils
/**
 *  获取本地应用版本号
 */
- (NSString *)appLocalVersion {
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [info objectForKey:@"CFBundleShortVersionString"];
    
    return [version stringByTrimmingCharactersInSet:[NSCharacterSet letterCharacterSet]];
}
/**
 *  比对服务器版本号和本地版本号
 *
 *  @param serverVersion 服务器版本号
 *  @param localVersion  本地版本号
 *
 *  @return 是否有新版本
 */
- (BOOL)isNewVersionWithServerVersion:(NSString *)serverVersion localVersion:(NSString *)localVersion{
    
    if ([serverVersion compare:localVersion options:NSNumericSearch] == NSOrderedDescending) {
        return YES;
    }
    
    return NO;
}
- (BOOL)todayIsShowed{
    //获取上次提示更新的时间
    NSString *oldDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"com.appLatestVersion"];
    NSString *currentTime = [self.dateFormatter stringFromDate:[NSDate date]];
    if ([currentTime isEqualToString:oldDate]) {
        return YES;
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:currentTime forKey:@"com.appLatestVersion"];
        return NO;
    }
}
#pragma mark - getter&setter
- (NSDateFormatter *)dateFormatter{
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yy-MM-dd"];
    }
    return _dateFormatter;
}
@end
