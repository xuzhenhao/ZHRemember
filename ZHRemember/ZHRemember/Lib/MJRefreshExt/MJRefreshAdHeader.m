//
//  MJRefreshAdHeader.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/27.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "MJRefreshAdHeader.h"

@interface MJRefreshAdHeader()
/** <#desc#>*/
@property (nonatomic, strong)   UIView     *bannerView;
@end

@implementation MJRefreshAdHeader

- (void)placeSubviews
{
    [super placeSubviews];
    
    UIView *arrowView = [self valueForKey:@"arrowView"];
    [self bringSubviewToFront:arrowView];
}

#pragma mark - getter
- (UIView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZHScreenWidth, 50)];
        [self addSubview:_bannerView];
    }
    return _bannerView;
}
- (void)setAdView:(UIView *)adView{
    _adView = adView;
    [self.bannerView addSubview:adView];
    _adView.frame = self.bannerView.bounds;
}
@end
