//
//  DIYWriteDiaryViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/30.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "DIYWriteDiaryViewModel.h"
#import "ZHDiaryApi.h"
#import "ZHCommonApi.h"

@interface DIYWriteDiaryViewModel()
/** 日记时间戳*/
@property (nonatomic, copy)     NSString    *unixTime;
/** 日记时间*/
@property (nonatomic, strong)   NSDate     *date;

/** 日记id*/
@property (nonatomic, copy)     NSString    *diaryId;

@end

@implementation DIYWriteDiaryViewModel
+ (instancetype)defaultViewModel{
    DIYWriteDiaryViewModel *vm = [DIYWriteDiaryViewModel new];
    //当前时间
    vm.date = [NSDate date];
    //默认晴天
    vm.weathImageName = [NSString diary_weatherImageNameOfIndex:0];
    //默认微笑脸
    vm.moodImageName = [NSString diary_moodImageNameOfIndex:0];
    
    return vm;
}
+ (instancetype)viewModelWithModel:(ZHDiaryModel *)model{
    DIYWriteDiaryViewModel *vm = [DIYWriteDiaryViewModel new];
    vm.date = [NSDate dateWithTimeIntervalSince1970:[model.unixTime integerValue]];
    vm.weathImageName = model.weatherImageName;
    vm.moodImageName = model.moodImageName;
    vm.letterImageName = model.wallPaperName;
    vm.diaryImageURL = model.diaryImageURL;
    vm.diaryText = model.diaryText;
    vm.diaryId = model.diaryId;
    
    return vm;
}
- (void)updateTimeWithDateComponents:(NSDateComponents *)components{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [calendar dateFromComponents:components];
    self.date = date;
}
- (void)updateDiaryImage:(UIImage *)image{
    @weakify(self)
    [ZHCommonApi uploadImage:image done:^(NSString *urlString, NSDictionary *error) {
        @strongify(self)
        if (urlString) {
            self.diaryImageURL = urlString;
        }
    }];
}
#pragma mark - utils
/**将数据拼成网络请求用的模型*/
- (ZHDiaryModel *)getParamModel{
    ZHDiaryModel *model = [ZHDiaryModel new];
    model.diaryId = self.diaryId;
    model.unixTime = self.unixTime;
    model.diaryText = self.diaryText;
    model.weatherImageName = self.weathImageName;
    model.moodImageName = self.moodImageName;
    model.diaryImageURL = self.diaryImageURL;
    model.wallPaperName = self.letterImageName;
    
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
- (RACCommand *)deleteCommand{
    if (!_deleteCommand) {
        @weakify(self)
        _deleteCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self)
                [ZHDiaryApi deleteDiaryWithId:self.diaryId done:^(BOOL success, NSDictionary *result) {
                    [subscriber sendNext:@(success)];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _deleteCommand;
}
@end
