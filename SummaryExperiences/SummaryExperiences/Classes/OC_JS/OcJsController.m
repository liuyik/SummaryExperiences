//
//  OcJsController.m
//  SummaryExperiences
//
//  Created by 刘毅 on 2017/7/29.
//  Copyright © 2017年 刘毅. All rights reserved.
//

#import "OcJsController.h"
#import "LYUIWebViewController.h"
#import "WKWebViewController.h"
#import "WKWebViewMessageHandlerController.h"

@interface OcJsController ()

@end

@implementation OcJsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)webview拦截Url:(id)sender {
    LYUIWebViewController *webViewC = [[LYUIWebViewController alloc] init];
    [self.navigationController pushViewController:webViewC animated:YES];
}
- (IBAction)WkWebView拦截URL:(id)sender {
    WKWebViewController *webViewC = [[WKWebViewController alloc] init];
    [self.navigationController pushViewController:webViewC animated:YES];
}
- (IBAction)messageHandler:(id)sender {
    WKWebViewMessageHandlerController *webViewC = [[WKWebViewMessageHandlerController alloc] init];
    [self.navigationController pushViewController:webViewC animated:YES];
}



@end
