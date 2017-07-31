//
//  LYUIWebViewController.m
//  SummaryExperiences
//
//  Created by 刘毅 on 2017/7/29.
//  Copyright © 2017年 刘毅. All rights reserved.
//

#import "LYUIWebViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface LYUIWebViewController ()<UIWebViewDelegate>

/** uiwebview*/
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation LYUIWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
   NSString *url = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [_webView loadRequest:request];
    
}

#pragma mark - UIWebView
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType; {
    
    NSURL *URL = request.URL;
    NSString *scheme = [URL scheme];
    
    if ([scheme isEqualToString:@"haleyaction"]) {
        
        [self handleCustomAction:URL];

        return NO;
    }
    
    return YES;
}


- (void)handleCustomAction:(NSURL *)url {
    NSString *host = [url host];
    if ([host isEqualToString:@"scanClick"]) {
        NSLog(@"扫一扫");
    } else if ([host isEqualToString:@"shareClick"]) {
        [self share:url];
    } else if ([host isEqualToString:@"getLocation"]) {
        [self getLocation];
    } else if ([host isEqualToString:@"setColor"]) {
        [self changeBGColor:url];
    } else if ([host isEqualToString:@"payAction"]) {
        [self payAction:url];
    } else if ([host isEqualToString:@"shake"]) {
        [self shakeAction];
    } else if ([host isEqualToString:@"back"]) {
        [self goBack];
    }

}

- (void)share:(NSURL *)url {
    NSArray *params =[url.query componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    for (NSString *paramStr in params) {
        NSArray *dicArray = [paramStr componentsSeparatedByString:@"="];
        if (dicArray.count > 1) {
            NSString *decodeValue = [dicArray[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [tempDic setObject:decodeValue forKey:dicArray[0]];
        }
    }
    
    NSString *title = [tempDic objectForKey:@"title"];
    NSString *content = [tempDic objectForKey:@"content"];
    NSString *Url = [tempDic objectForKey:@"url"];
    // 在这里执行分享的操作
    
    // 将分享结果返回给js
    NSString *jsStr = [NSString stringWithFormat:@"shareResult('%@','%@','%@')",title,content,Url];
    [self.webView stringByEvaluatingJavaScriptFromString:jsStr];
;
}
- (void)getLocation {
    
    // 获取位置信息
    NSString *location = @"长沙岳麓区雅阁国际";
    // 将结果返回给js
    NSString *jsStr = [NSString stringWithFormat:@"setLocation('%@')",location];
    [self.webView stringByEvaluatingJavaScriptFromString:@"setLocation()"];

    
}
- (void)changeBGColor:(NSURL *)url {
    NSArray *params =[url.query componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    for (NSString *paramStr in params) {
        NSArray *dicArray = [paramStr componentsSeparatedByString:@"="];
        if (dicArray.count > 1) {
            NSString *decodeValue = [dicArray[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [tempDic setObject:decodeValue forKey:dicArray[0]];
        }
    }
    CGFloat r = [[tempDic objectForKey:@"r"] floatValue];
    CGFloat g = [[tempDic objectForKey:@"g"] floatValue];
    CGFloat b = [[tempDic objectForKey:@"b"] floatValue];
    CGFloat a = [[tempDic objectForKey:@"a"] floatValue];
    
    _webView.backgroundColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];

}
- (void)payAction:(NSURL *)url {
    
    NSArray *params =[url.query componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    for (NSString *paramStr in params) {
        NSArray *dicArray = [paramStr componentsSeparatedByString:@"="];
        if (dicArray.count > 1) {
            NSString *decodeValue = [dicArray[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [tempDic setObject:decodeValue forKey:dicArray[0]];
        }
    }
    //    NSString *orderNo = [tempDic objectForKey:@"order_no"];
    //    long long amount = [[tempDic objectForKey:@"amount"] longLongValue];
    //    NSString *subject = [tempDic objectForKey:@"subject"];
    //    NSString *channel = [tempDic objectForKey:@"channel"];
    
    // 支付操作
    
    // 将支付结果返回给js
    NSUInteger code = 1;
    NSString *jsStr = [NSString stringWithFormat:@"payResult('%@',%lu)",@"支付成功",(unsigned long)code];
    [self.webView stringByEvaluatingJavaScriptFromString:jsStr];
    
}
- (void)shakeAction {
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
}
- (void)goBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
