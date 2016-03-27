//
//  NEWsTableViewController.h
//  百度API的新闻
//
//  Created by doubi on 16/3/12.
//  Copyright © 2016年 doubi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoViewController.h"
#import "NewsInfo.h"
@interface NEWsTableViewController : UITableViewController<NSURLSessionDataDelegate>
{
    NSMutableData *recvData;
    NSMutableArray *news;
}
-(void) loadNewsData;
-(void)loadNewsImage:(UITableViewCell *)cell andImageUrl:(NSString *)urlStr;

@end
