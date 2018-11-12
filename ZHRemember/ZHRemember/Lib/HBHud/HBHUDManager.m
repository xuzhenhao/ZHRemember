//
//  HBHUDManager.m
//  HBTools
//
//  Created by Skyrim on 16/10/19.
//  Copyright © 2016年 haibao. All rights reserved.
//

#import "HBHUDManager.h"
#import <MBProgressHUD/MBProgressHUD.h>

@implementation HBHUDManager

#pragma mark - ProgressHUD

+ (void)hideAllHUD {
    [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
}

+ (void)showMessage:(NSString *)message{
    if (!message) {
        return;
    }
    [self showMessage:message done:nil];
}

+ (void)showMessage:(NSString *)message done:(void(^)())doneHandler{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.yOffset = -100;
        hud.mode = MBProgressHUDModeText;
        hud.labelText = message;
        [hud hide:YES afterDelay:1.5];
        hud.completionBlock = doneHandler;
    });
}

+(void)showIndeterminateMessage:(NSString *)message done:(void (^)())doneHandler {
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.yOffset = -100;
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = message;
        [hud hide:YES afterDelay:1.5];
        hud.completionBlock = doneHandler;
    });
}

+ (void)showCustomMessage:(NSString *)message customView:(UIView *)customView done:(void(^)())doneHandler{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.yOffset = -100;
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = customView;
        hud.labelText = message;
        [hud hide:YES afterDelay:1.5];
        hud.completionBlock = doneHandler;
    });
}

+ (void)showNetworkLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.yOffset = -100;
    });
}

+ (void)hideNetworkLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (UIView *subView in [UIApplication sharedApplication].keyWindow.subviews) {
            if ([subView isKindOfClass:[MBProgressHUD class]]) {
                MBProgressHUD *hud = (MBProgressHUD *)subView;
                if (hud.mode == MBProgressHUDModeIndeterminate && hud.labelText == nil) {
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES];
                }
            }
        }
    });
}

#pragma mark - Alert

+ (void)alertMessage:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}


@end
