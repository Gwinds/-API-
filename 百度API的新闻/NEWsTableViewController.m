//
//  NEWsTableViewController.m
//  百度API的新闻
//
//  Created by doubi on 16/3/12.
//  Copyright © 2016年 doubi. All rights reserved.
//

#import "NEWsTableViewController.h"

@interface NEWsTableViewController ()

@end

@implementation NEWsTableViewController
{


    NewsInfo *selectItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    recvData =[[NSMutableData alloc] init];
    news=[NSMutableArray array];
    [self  loadNewsData];
    UIRefreshControl *refresh=[[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(Refresh:) forControlEvents:UIControlEventValueChanged];
    refresh.attributedTitle=[[NSAttributedString alloc] initWithString:@"正在刷新"];
    self.refreshControl=refresh;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return news.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    NewsInfo *one=[news objectAtIndex:indexPath.row];
    UITextView *textview=(UITextView*)[cell viewWithTag:111];
    if (textview) {
        textview.text=one.title;
    }
    //加载对应的图片
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self loadNewsImage:cell andImageUrl:one.image_url];
    });
    

    
    return cell;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"show"]) {
        InfoViewController *dv=[segue destinationViewController];
        dv.ururl=selectItem.url;
    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectItem=news[indexPath.row];
    [self performSegueWithIdentifier:@"show" sender:self];

}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}

-(void) loadNewsData
{
    NSString *httpurl=@"http://apis.baidu.com/songshuxiansheng/news/news";
    NSString *args=@"";//arg1=xx&arg2=xx
    NSString *urlStr=[[NSString alloc]initWithFormat:@"%@?%@",httpurl,args];
    NSURL *url=[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:(NSURLRequestUseProtocolCachePolicy) timeoutInterval:10];
    //默认为GET
    [request setHTTPMethod:@"GET"];
    [request setValue:@"0f187d18aa91a81c2664a2d0ca01d2e6" forHTTPHeaderField:@"apikey"];
    //建立会话
    NSURLSession *session=[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task=[session dataTaskWithRequest:request];
    //启动任务
    [task resume];
    
    
    
    

}
#pragma mark--------NSURLsession-Delegate--
//已经接收响应
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    recvData.length=0;
    completionHandler(NSURLSessionResponseAllow);

}
//已经接收数据
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{

    [recvData appendData:data];

}
//已经完成错误提示
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error) {
        NSLog(@"did complete error:%@",error.localizedDescription);
    }
    else
    {
        
//        NSLog(@">>%@",[[NSString alloc] initWithData:recvData encoding:NSUTF8StringEncoding]);
        [self AnalyticsJSON];
    }
    [self.refreshControl endRefreshing];

}
-(void)AnalyticsJSON
{
    NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:recvData options:NSJSONReadingMutableLeaves error:nil];
    
    if (!jsonDict) {
        [self showAlert:@"解析JSON faild"];
        return;
    }
    //success 取出数据信息
    NewsInfo *one;
    one=[[NewsInfo alloc] init];
    NSArray *tempArray=[jsonDict objectForKey:@"retData"];
    if (!tempArray) {
        [self showAlert:@"加载数据失败"];
        return;
    }
    //success
//    当有新的新闻时 清空之前的；
    if (tempArray.count>0) {
        [news removeAllObjects];
    }
    for(NSDictionary *dict in tempArray)
    {
        NSArray *keys=[dict allKeys];
        NSLog(@"$$$%@",keys);
        one=[[NewsInfo alloc] init];
        for (NSString *key in keys ) {
              NSLog(@"%@>>%@",key,[dict objectForKey:key]);
            [one setValue:[dict objectForKey:key] forKey:key];
        }
        [news addObject:one];
    
    }
    [self.tableView reloadData];

}
-(void)showAlert:(NSString*)msg
{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    
    

}
-(void)loadNewsImage:(UITableViewCell *)cell andImageUrl:(NSString *)urlStr
{
    NSURL *url=[NSURL URLWithString:urlStr];
    if (!url) {
        return;
    }
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *task=[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            return;
        }
        UIImage *image=[[UIImage alloc] initWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImageView *Iv=(id)[cell viewWithTag:110];
            Iv.image=image;
        });
    }];
    [task resume];

}
-(void)Refresh:(UIRefreshControl *)sender
{

    [self loadNewsData];
}
@end
