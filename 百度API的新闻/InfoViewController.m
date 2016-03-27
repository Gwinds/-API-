//
//  InfoViewController.m
//  百度API的新闻
//
//  Created by doubi on 16/3/12.
//  Copyright © 2016年 doubi. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url=[NSURL URLWithString:self.ururl];
    NSURLRequest  *request=[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    self.webView.delegate=self;
    self.navigationItem.title=@"正在努力加载。。。。。";
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
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.navigationItem.title=@"";
    
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (error) {
        self.navigationItem.title=@"加载失败";
    }
}

@end
