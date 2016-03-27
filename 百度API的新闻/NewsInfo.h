//
//  NewsInfo.h
//  百度API的新闻
//
//  Created by doubi on 16/3/12.
//  Copyright © 2016年 doubi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsInfo : NSObject
@property(strong,nonatomic)NSString *title;
@property(strong,nonatomic)NSString *url;
@property(strong,nonatomic)NSString *abstract;
@property(strong,nonatomic)NSString *image_url;
@end
