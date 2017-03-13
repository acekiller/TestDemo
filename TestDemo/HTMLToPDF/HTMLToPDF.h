//
//  HTMLToPDF.h
//  TestDemo
//
//  Created by Fantasy on 16/12/29.
//  Copyright © 2016年 fantasy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTMLToPDF;

@protocol NDHTMLtoPDFDelegate
@optional
- (void)HTMLtoPDFDidSucceed:(HTMLToPDF *)htmlToPDF;
- (void)HTMLtoPDFDidFail:(HTMLToPDF *)htmlToPDF;
@end

@interface HTMLToPDF : UIViewController
@property (nonatomic, weak) id  delegate;
@property (nonatomic, strong, readonly) NSString *PDFpath;
+ (id)createPDFWithHTML:(NSString*)HTML pathForPDF:(NSString*)PDFpath delegate:(id )delegate
               pageSize:(CGSize)pageSize margins:(UIEdgeInsets)pageMargins;

@end
