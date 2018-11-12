//
//  DIYExportPDFViewController.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/15.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "DIYExportPDFViewController.h"
#import "ZHPDFCreater.h"
#import "DIYPDFTemplateView.h"
#import "DIYDiaryStore.h"

@interface DIYExportPDFViewController ()<UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong)   UIDocumentInteractionController     *documentVC;
/** */
@property (nonatomic, assign)   BOOL      isExported;
@end

@implementation DIYExportPDFViewController
+ (instancetype)viewController{
    return [DIYExportPDFViewController new];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (!self.isExported) {
        [HBHUDManager showNetworkLoading];
        [self exportDiary];
        self.isExported = YES;
    }
}
- (void)setupView{
    self.title = @"导出日记本";
    self.view.backgroundColor = [UIColor lightGrayColor];
}
- (void)exportDiary{
    NSMutableArray *images = [NSMutableArray array];
    
    NSArray *array = [DIYDiaryStore shared].diarys;
    for (NSInteger i = 0; i < array.count;i++) {
        DIYPDFTemplateView *templateView = [DIYPDFTemplateView templateViewWithModel:array[i]];
        UIImage *img = [UIImage zh_snapshotOfView:templateView];
        [images addObject:img];
    }
    NSString *fileName = @"diary.pdf";
    [ZHPDFCreater createPDFWithImages:images fileName:fileName pageSize:CGSizeMake(320, 504)];
    
    [HBHUDManager hideNetworkLoading];
    [self sharePdfWithPath:[ZHPDFCreater filePathWithName:fileName]];
}
- (void)sharePdfWithPath:(NSString *)path{
    UIDocumentInteractionController *ctrl = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:path]];
    ctrl.delegate = self;
    ctrl.UTI = @"com.adobe.pdf";
    self.documentVC = ctrl;
    [ctrl presentPreviewAnimated:YES];
}
#pragma mark - UIDocumentInteractionControllerDelegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}
@end
