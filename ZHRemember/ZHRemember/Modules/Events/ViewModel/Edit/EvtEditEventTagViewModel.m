//
//  EvtEditEventTagViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/21.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtEditEventTagViewModel.h"
#import "EvtEventApi.h"

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
    self.currentTag = self.tags[index];
}
- (void)requestTags{
    @weakify(self)
    [EvtEventApi getTagListWithDone:^(NSArray<EvtTagModel *> *tagList, NSDictionary *result) {
        @strongify(self)
        self.tags = tagList;
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
