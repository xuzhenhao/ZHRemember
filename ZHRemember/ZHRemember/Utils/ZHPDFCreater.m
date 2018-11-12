//
//  ZHPDFCreater.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/15.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "ZHPDFCreater.h"

@implementation ZHPDFCreater
+ (NSString *)filePathWithName:(NSString *)name{
    return [self saveDirectory:name];
}
+ (BOOL)createPDFWithImages:(NSArray<UIImage *>*)images
                   fileName:(NSString *)fileName
                   pageSize:(CGSize)size{
    
    if (!images || images.count == 0) return NO;
    // pdf文件存储路径
    NSString *pdfPath = [self saveDirectory:fileName];
    BOOL result = UIGraphicsBeginPDFContextToFile(pdfPath, CGRectMake(0, 0, size.width, size.height), NULL);
    
    // pdf每一页的尺寸大小
    CGRect pdfBounds = UIGraphicsGetPDFContextBounds();
    CGFloat pdfWidth = pdfBounds.size.width;
    CGFloat pdfHeight = pdfBounds.size.height;
    
    [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
        // 绘制PDF
        UIGraphicsBeginPDFPage();
        // 获取每张图片的实际长宽
        CGFloat imageW = image.size.width;
        CGFloat imageH = image.size.height;
        
        // 如果图片宽高都小于PDF宽高
        if (imageW <= pdfWidth && imageH <= pdfHeight) {
            
            CGFloat originX = (pdfWidth - imageW) * 0.5;
            CGFloat originY = (pdfHeight - imageH) * 0.5;
            [image drawInRect:CGRectMake(originX, originY, imageW, imageH)];
            
        }
        else{
            CGFloat w,h; // 先声明缩放之后的宽高
            //            图片宽高比大于PDF
            if ((imageW / imageH) > (pdfWidth / pdfHeight)){
                w = pdfWidth - 20;
                h = w * imageH / imageW;
                
            }else{
                //             图片高宽比大于PDF
                h = pdfHeight - 20;
                w = h * imageW / imageH;
            }
            [image drawInRect:CGRectMake((pdfWidth - w) * 0.5, (pdfHeight - h) * 0.5, w, h)];
        }
    }];
    UIGraphicsEndPDFContext();
    
    return result;
}

//+ (BOOL)convertPDFWithWebView:(UIWebView *)webView fileName:(NSString *)fileName{
//
//    NSString *pdfPath = [self saveDirectory:fileName];
//    NSLog(@"****************文件路径：%@*******************",pdfPath);
//
//    NSData *pdfData = [webView convert2PDFData];
//    BOOL result = [pdfData writeToFile:pdfPath atomically:YES];
//
//    return result;
//}


/**
 文件保存路径
 */
// 创建目录文件夹
+ (void)creatPDFFolder{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[self pdfSaveFolder]]) {
        [fileManager createDirectoryAtPath:[self pdfSaveFolder] withIntermediateDirectories:YES attributes:nil error:NULL];
    }
}
//    文件存放主目录
+ (NSString *)pdfSaveFolder{
    return [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"ZHPDF"];
}

+ (NSString *)saveDirectory:(NSString *)fileName{
    [self creatPDFFolder];
    return [[self pdfSaveFolder] stringByAppendingPathComponent:fileName];
}
@end
