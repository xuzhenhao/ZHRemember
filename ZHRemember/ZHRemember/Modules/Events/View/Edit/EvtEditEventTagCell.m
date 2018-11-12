//
//  EvtEditEventTagCell.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/21.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtEditEventTagCell.h"
#import "EvtEditEventTagViewModel.h"

@interface EvtEditEventTagCell()<UIPickerViewDataSource,
UIPickerViewDelegate,ZHTableViewCellProtocol>

@property (weak, nonatomic) IBOutlet UITextField *textField;
/**重复周期选择器*/
@property (nonatomic, strong)   UIPickerView     *pickView;
@property (nonatomic, strong)   UIToolbar     *toolBar;

@property (nonatomic, strong)   EvtEditEventTagViewModel     *viewModel;

@end

@implementation EvtEditEventTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initSetup];
}
- (void)initSetup{
    self.textField.inputView = self.pickView;
    self.textField.inputAccessoryView = self.toolBar;
}
- (void)updateWithData:(ZHTableViewItem *)data{
    
    self.viewModel = data.data;
    @weakify(self)
    [RACObserve(self.viewModel, tagDesc) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.textField.text = x;
    }];
}
#pragma mark - pickView delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.viewModel tagCount];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.viewModel tagDescForRow:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [self.viewModel updateCurrentTagWithIndex:row];
}

#pragma mark - action
- (void)clickToolbarFinishEvent{
    [self.textField endEditing:YES];
    NSInteger index = [self.pickView selectedRowInComponent:0];
    [self pickerView:self.pickView didSelectRow:index inComponent:0];
}

#pragma mark - getter&setter
- (UIPickerView *)pickView{
    if (!_pickView) {
        _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 0, 215)];
        _pickView.delegate = self;
        _pickView.dataSource = self;
        _pickView.backgroundColor = [UIColor whiteColor];
    }
    return _pickView;
}
- (UIToolbar *)toolBar{
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
        UIBarButtonItem *fixBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *finBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(clickToolbarFinishEvent)];
        finBtn.tintColor = [UIColor whiteColor];
        fixBtn.tintColor = [UIColor clearColor];
        
        [_toolBar setBackgroundImage:[UIImage zh_imageWithColor:[UIColor zh_tabbarColor] size:CGSizeMake(ZHScreenWidth, 44)] forToolbarPosition:0 barMetrics:UIBarMetricsDefault];
        
        _toolBar.items = @[fixBtn,finBtn];
        
    }
    return _toolBar;
}


@end
