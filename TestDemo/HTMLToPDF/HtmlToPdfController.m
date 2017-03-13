//
//  HtmlToPdfController.m
//  TestDemo
//
//  Created by Fantasy on 16/12/29.
//  Copyright © 2016年 fantasy. All rights reserved.
//

#import "HtmlToPdfController.h"
#import <WebKit/WebKit.h>
#import "HTMLToPDF.h"

#define kPaperSizeA4 CGSizeMake(595,842)
#define kPaperSizeLetter CGSizeMake(612,792)

@interface HtmlToPdfController ()
<
    WKUIDelegate,
    WKNavigationDelegate,
    NDHTMLtoPDFDelegate
>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) HTMLToPDF *PDFCreator;
@end

@implementation HtmlToPdfController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
    [self.webView setUIDelegate:self];
    [self.webView setNavigationDelegate:self];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"导出" style:UIBarButtonItemStylePlain target:self action:@selector(htmlToPdfButtonPressed:)];
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)htmlToPdfButtonPressed:(id)sender {
    NSString *outerHTML = @"document.documentElement.outerHTML";
    [self.webView evaluateJavaScript:outerHTML
                   completionHandler:^(NSString *html, NSError * error) {
                       if (error) {
                           NSLog(@"error : %@",error);
                       } else {
                           NSLog(@"html : %@",html);
                           dispatch_async(dispatch_get_main_queue(), ^{
                               [self convertToPDF:html];
                           });
                       }
                   }];
}

- (void) convertToPDF:(NSString *)html {
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/demo.pdf"];
    self.PDFCreator = [HTMLToPDF createPDFWithHTML:html
                                          pathForPDF:[path stringByExpandingTildeInPath]
                                            delegate:self
                                            pageSize:kPaperSizeLetter
                                             margins:UIEdgeInsetsMake(10, 5, 10, 5)];
}

#pragma mark -WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

- (void) webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

- (void) webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

- (void) webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(nonnull NSError *)error {
    NSLog(@"%s -> error : %@",__PRETTY_FUNCTION__,error);
}

- (void) webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void) webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

- (void)HTMLtoPDFDidSucceed:(HTMLToPDF *)htmlToPDF
{
    NSLog(@"HTMLtoPDF did succeed (%@ / %@)", htmlToPDF, htmlToPDF.PDFpath);
}

- (void)HTMLtoPDFDidFail:(HTMLToPDF *)htmlToPDF
{
    NSLog(@"HTMLtoPDF did fail (%@)", htmlToPDF);
}

@end
