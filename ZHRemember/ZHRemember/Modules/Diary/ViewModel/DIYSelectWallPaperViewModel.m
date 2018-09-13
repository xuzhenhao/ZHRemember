//
//  DIYSelectWallPaperViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/7.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "DIYSelectWallPaperViewModel.h"
#import "ZHUserStore.h"

@implementation DIYSelectWallPaperViewModel

- (NSInteger)numberOfSections{
    return 2;
}
- (NSInteger)numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }else if (section == 1){
        return 60;
    }
    return 0;
}

- (NSString *)imageNameOfIndex:(NSIndexPath *)path{
    NSString *name = @"letter-paper";
    if (path.section == 0) {
        name = [NSString stringWithFormat:@"%@%zd",name,path.item];
    }else if (path.section == 1){
        NSInteger index = path.item;
//        if (index < 10) {
            index += 10;
//        }
        name = [NSString stringWithFormat:@"%@%zd",name,index];
    }
    
    return name;
    
}
#pragma mark - getter
- (RACCommand *)unlockLetterCommand{
    if (!_unlockLetterCommand) {
        _unlockLetterCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                [[ZHUserStore shared] enableCustomLettersWithCost:IAPUnlockLetterPirce done:^(BOOL success, NSError *error) {
                    [subscriber sendNext:@(success)];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _unlockLetterCommand;
}

@end
