//
//  DIYWriteDiaryViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/30.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "DIYWriteDiaryViewModel.h"
#import "ZHDiaryApi.h"

@interface DIYWriteDiaryViewModel()
/** 日记时间戳*/
@property (nonatomic, copy)     NSString    *unixTime;
/** 日记时间*/
@property (nonatomic, strong)   NSDate     *date;

@end

@implementation DIYWriteDiaryViewModel
+ (instancetype)defaultViewModel{
    DIYWriteDiaryViewModel *vm = [DIYWriteDiaryViewModel new];
    //当前时间
    vm.date = [NSDate date];
    //默认晴天
    vm.weathImageName = @"weather-sun-big";
    //默认微笑脸
    vm.moodImageName = @"diary-mood1";
    
    return vm;
}

#pragma mark - utils
/**将数据拼成网络请求用的模型*/
- (ZHDiaryModel *)getParamModel{
    ZHDiaryModel *model = [ZHDiaryModel new];
    model.unixTime = self.unixTime;
    model.diaryText = self.diaryText;
    model.weatherImageName = self.weathImageName;
    model.moodImageName = self.moodImageName;
    
    return model;
}

#pragma mark - setter
- (void)setDate:(NSDate *)date{
    NSString *dateFormat = [date formattedDateWithFormat:@"M月,dd,HH:mm" locale:[NSLocale systemLocale]];
    NSArray *temp = [dateFormat componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
    self.monthDesc = temp[0];
    self.dayDesc = temp[1];
    self.hourDesc = temp[2];
    self.weekDesc = [date getWeekDay];
    
    self.unixTime = [NSString stringWithFormat:@"%.0f",[date timeIntervalSince1970]];
}
#pragma mark - getter
- (RACCommand *)saveDiaryCommand{
    if (!_saveDiaryCommand) {
        @weakify(self)
        
        _saveDiaryCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                @strongify(self)
                [ZHDiaryApi saveDiary:[self getParamModel] done:^(BOOL success, NSDictionary *result) {
                    [subscriber sendNext:@(success)];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
        }];
    }
    return _saveDiaryCommand;
}

@end
