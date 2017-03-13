//
//  HTMLToPDF.m
//  TestDemo
//
//  Created by Fantasy on 16/12/29.
//  Copyright © 2016年 fantasy. All rights reserved.
//

#import "HTMLToPDF.h"
#import <WebKit/WebKit.h>

@interface UIPrintPageRenderer (PDF)
- (NSData*) printToPDF;
@end

@interface HTMLToPDF ()
<
    WKUIDelegate,
    WKNavigationDelegate
>
@property (nonatomic, strong) NSString *PDFpath;
@property (nonatomic) UIEdgeInsets pageMargins;
@property (nonatomic) CGSize pageSize;
@property (nonatomic) NSString *HTML;
@property (nonatomic, strong) WKWebView *webview;

- (void) pdfLoad;

@end

@implementation HTMLToPDF

+ (id)createPDFWithHTML:(NSString*)HTML pathForPDF:(NSString*)PDFpath delegate:(id )delegate
               pageSize:(CGSize)pageSize margins:(UIEdgeInsets)pageMargins
{
    HTMLToPDF *creator = [[HTMLToPDF alloc] initWithHTML:HTML delegate:delegate pathForPDF:PDFpath pageSize:pageSize margins:pageMargins];
    [creator pdfLoad];
    return creator;
}


- (id)initWithHTML:(NSString*)HTML delegate:(id )delegate
        pathForPDF:(NSString*)PDFpath pageSize:(CGSize)pageSize margins:(UIEdgeInsets)pageMargins
{
    self = [super init];
    if (self)
    {
        self.HTML = HTML;
        self.delegate = delegate;
        self.PDFpath = PDFpath;
        self.pageMargins = pageMargins;
        self.pageSize = pageSize;
        
        [[UIApplication sharedApplication].delegate.window addSubview:self.view];
        self.view.frame = CGRectMake(0, 0, 1, 1);
        self.webview = [[WKWebView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:self.webview];
        self.webview.navigationDelegate = self;
        self.view.alpha = 0.0;
    }
    return self;
}

- (void) pdfLoad {
    [self.webview loadHTMLString:self.HTML baseURL:nil];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    if (webView.isLoading) return;
    
    UIPrintPageRenderer *render = [[UIPrintPageRenderer alloc] init];
    [render addPrintFormatter:webView.viewPrintFormatter startingAtPageAtIndex:0];
    CGRect printableRect = CGRectMake(self.pageMargins.left,
                                      self.pageMargins.top,
                                      self.pageSize.width - self.pageMargins.left - self.pageMargins.right,
                                      self.pageSize.height - self.pageMargins.top - self.pageMargins.bottom);
    CGRect paperRect = CGRectMake(0, 0, self.pageSize.width, self.pageSize.height);
    
    [render setValue:[NSValue valueWithCGRect:paperRect] forKey:@"paperRect"];
    [render setValue:[NSValue valueWithCGRect:printableRect] forKey:@"printableRect"];
    
    NSData *pdfData = [render printToPDF];
    BOOL isSuccess = [pdfData writeToFile: self.PDFpath  atomically: YES];
    NSLog(@"%@",isSuccess ? @"YES" : @"NO");
    [self terminateWebTask];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(HTMLtoPDFDidSucceed:)])
        [self.delegate HTMLtoPDFDidSucceed:self];
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    if (webView.isLoading) return;
    [self terminateWebTask];
    if (self.delegate && [self.delegate respondsToSelector:@selector(HTMLtoPDFDidFail:)])
        [self.delegate HTMLtoPDFDidFail:self];
}

- (void)terminateWebTask
{
    [self.webview stopLoading];
    self.webview.UIDelegate = nil;
    self.webview.navigationDelegate = nil;
    [self.webview removeFromSuperview];
    [self.view removeFromSuperview];
    self.webview = nil;
}

@end

@implementation UIPrintPageRenderer (PDF)

- (NSData*) printToPDF
{
    NSMutableData *pdfData = [NSMutableData data];
    
    UIGraphicsBeginPDFContextToData( pdfData, CGRectZero, nil );
    
    [self prepareForDrawingPages: NSMakeRange(0, self.numberOfPages)];
    
    CGRect bounds = UIGraphicsGetPDFContextBounds();
    
    for ( int i = 0 ; i < self.numberOfPages ; i++ )
    {
        UIGraphicsBeginPDFPage();
        
        [self drawPageAtIndex: i inRect: bounds];
    }
    UIGraphicsEndPDFContext();
    return pdfData;
}

@end
