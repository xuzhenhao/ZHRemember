//
//  EvtEditEventTagViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/21.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtEditEventTagViewModel.h"
#import "EvtEventStore.h"

@interface EvtEditEventTagViewModel()
/** 可选标签数组*/
@property (nonatomic, strong)   NSArray<EvtTagModel *>     *tags;
/** 当前标签*/
@property (nonatomic, strong)   EvtTagModel     *currentTag;
@property (nonatomic, copy)     NSString    *tagDesc;

@end


@implementation EvtEditEventTagViewModel
+ (instancetype)viewModelWithTag:(EvtTagModel *)currentTag{
    EvtEditEventTagViewModel *tagVM = [[EvtEditEventTagViewModel alloc] init];
    tagVM.currentTag = currentTag;
    
    return tagVM;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        [self requestTags];
    }
    return self;
}

- (void)updateCurrentTagWithIndex:(NSInteger)index{
    if (self.tags.count < 1) {
        return;
    }
    self.currentTag = self.tags[index];
}
- (void)requestTags{
    @weakify(self)
    
    [[[RACSignal combineLatest:@[RACObserve([EvtEventStore shared], publicTags),
                               RACObserve([EvtEventStore shared], privateTags)]] filter:^BOOL(RACTuple * _Nullable value) {
        RACTupleUnpack(NSArray *publicTag,NSArray *privateTag) = value;
        return publicTag.count > 0 || privateTag.count > 0;
    }] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self)
        RACTupleUnpack(NSArray *publicTag,NSArray *privateTag) = x;
        NSMutableArray *tempM = [NSMutableArray arrayWithArray:publicTag];
        if (privateTag.count > 0) {
            [tempM addObjectsFromArray:privateTag];
        }
        self.tags = [tempM copy];
    }];
    
//    [[RACObserve([EvtEventStore shared], publicTags) filter:^BOOL(id  _Nullable value) {
//        return value != nil;
//    }] subscribeNext:^(id  _Nullable x) {
//        @strongify(self)
//        NSMutableArray *tempM = [NSMutableArray arrayWithArray:x];
//        if ([EvtEventStore shared].privateTags.count > 0) {
//            [tempM addObjectsFromArray:[EvtEventStore shared].privateTags];
//        }
//        self.tags = [tempM copy];
//    }];

    [[EvtEventStore shared] getEventTagsWithDone:^(BOOL succeed, NSError *error) {
        
    }];
}
- (NSInteger)tagCount{
    return self.tags.count;
}
/**标签文字描述*/
- (NSString *)tagDescForRow:(NSInteger)row{
    return self.tags[row].tagName;
}

#pragma mark - setter
- (void)setCurrentTag:(EvtTagModel *)currentTag{
    _currentTag = currentTag;
    self.tagDesc = currentTag.tagName;
}

@end
