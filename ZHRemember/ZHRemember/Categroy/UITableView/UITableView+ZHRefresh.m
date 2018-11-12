//
//  UITableView+ZHRefresh.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/18.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "UITableView+ZHRefresh.h"
#import "MJRefreshAdHeader.h"

@implementation UITableView (ZHRefresh)

- (void)configHeadRefreshControlWithRefreshBlock:(void (^)(void))block{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (block) {
            block();
        }
    }];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.mj_header = header;
}
- (void)configAdHeadRefreshControlWithBannerView:(UIView *)banner refreshBlock:(void (^)(void))block{
    MJRefreshAdHeader *header = [MJRefreshAdHeader headerWithRefreshingBlock:^{
        if (block) {
            block();
        }
    }];
    
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.mj_header = header;
    header.adView = banner;
}


@end
