//
//  MyThemeColorViewController.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/28.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "MyThemeColorViewController.h"
#import "MyModuleHeader.h"
#import "MyThemeColorEventCell.h"

static CGFloat colorViewWidth = 50;

@interface MyThemeColorViewController ()<UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 选择的颜色*/
@property (nonatomic, strong)   UIColor      *selectedColor;
@property (nonatomic, strong)   UIButton     *addEventButton;
/** 选择颜色滚动视图*/
@property (nonatomic, strong)   UIScrollView     *scrollView;

/** 可选择的颜色*/
@property (nonatomic, strong)   NSArray<UIColor *>     *colors;
/** 之前选的颜色视图*/
@property (nonatomic, strong)   UIView     *perColorView;
/** 当前选的颜色视图*/
@property (nonatomic, strong)   UIView     *currentColorView;

@property (nonatomic, strong)   NSMutableArray     *colorViews;

@end

@implementation MyThemeColorViewController
+ (instancetype)themeColorViewController{
    return [self viewControllerWithStoryBoard:MyModuleStoryboard];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
- (void)setupUI{
    self.selectedColor = [UIColor zh_themeColor];
    
    [self.view addSubview:self.addEventButton];
    
    [self setupScrollView];
    self.tableView.rowHeight = 370;
    
    @weakify(self)
    [[RACObserve(self, selectedColor) deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView reloadData];
        self.addEventButton.backgroundColor = self.selectedColor;
        self.addEventButton.layer.shadowColor = self.selectedColor.CGColor;
    }];
}
- (void)setupScrollView{
    [self.view addSubview:self.scrollView];
    
    CGFloat xPos = 12;
    CGFloat margin = 10;
    for (UIColor *color in self.colors) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(xPos, 0, colorViewWidth, colorViewWidth)];
        view.layer.cornerRadius = colorViewWidth/ 2;
        view.layer.masksToBounds = YES;
        view.backgroundColor = color;
        UITapGestureRecognizer *selectTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectView:)];
        [view addGestureRecognizer:selectTap];
        
        [self.scrollView addSubview:view];
        xPos += (margin+colorViewWidth);
    }
    self.scrollView.contentSize = CGSizeMake(xPos, colorViewWidth);
}
#pragma mark - acton
- (void)didSelectView:(UITapGestureRecognizer *)sender{
    self.selectedColor = sender.view.backgroundColor;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyThemeColorEventCell *cell = [tableView dequeueReusableCellWithIdentifier:[MyThemeColorEventCell reuseIdentify] forIndexPath:indexPath];
    [cell updateWithColor:self.selectedColor];
    return cell;
}

#pragma mark - getter
- (UIButton *)addEventButton{
    if (_addEventButton == nil) {
        _addEventButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addEventButton setImage:[UIImage imageNamed:@"event-write-pen"] forState:UIControlStateNormal];
        _addEventButton.frame = CGRectMake(ZHScreenWidth - 60, ZHScreenHeight - 350, 50, 50);
        
        _addEventButton.userInteractionEnabled = NO;
        _addEventButton.backgroundColor = self.selectedColor;
        _addEventButton.layer.cornerRadius = 25;
        _addEventButton.layer.shadowOffset = CGSizeMake(0, 8);
        _addEventButton.layer.shadowOpacity = 0.5;
        _addEventButton.layer.shadowColor = self.selectedColor.CGColor;
        _addEventButton.layer.shadowRadius = 12;
    }
    return _addEventButton;
}
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.backgroundColor = [UIColor whiteColor];
        
        _scrollView.frame = CGRectMake(0, self.view.bounds.size.height - ZHNavbarHeight -  colorViewWidth - 20, ZHScreenWidth, colorViewWidth);
    }
    return _scrollView;
}
- (NSMutableArray *)colorViews{
    if (!_colorViews) {
        _colorViews = [NSMutableArray array];
    }
    return _colorViews;
}
- (NSArray<UIColor *> *)colors{
    if (!_colors) {
        _colors = @[[UIColor redColor],
                    [UIColor yellowColor],
                    [UIColor blackColor],
                    [UIColor blueColor]];
    }
    return _colors;
}
@end
