//
//  HttpModel.m
//  大将军
//
//  Created by 石燚 on 16/7/31.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#define POST_Url_Register @"https://api.leancloud.cn/1.1/users"
#define POST_Url_Login @"https://api.leancloud.cn/1.1/login"

#define POST_Url_Id @"1g0inh8S6gA6zmogkU6bkA19-gzGzoHsz"
#define POST_Url_Apikey @"8qhdXls0HgxhHpqp6LN0vXGS"

#import "HttpModel.h"

@implementation HttpModel

//注册
+ (void)registerWihtUsername:(NSString *)username AndPassword:(NSString *)password {
    //1.获取资源地址
    NSURL *url = [[NSURL alloc]initWithString:POST_Url_Register];
    
    //2.创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //3.配置请求
    request.timeoutInterval = 10.f; //请求超时
    
    request.HTTPMethod = @"POST";    //设置请求方法
    
    //配置头部请求
    [request setValue:POST_Url_Id forHTTPHeaderField:@"X-LC-Id"];
    [request setValue:POST_Url_Apikey forHTTPHeaderField:@"X-LC-Key"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *parmStr = @{@"username":username,@"password":password};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parmStr options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPBody = jsonData;

    
    //4.创建网络会话
    NSURLSession *session = [NSURLSession sharedSession];
    
    //5.创建网络会话任务
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        id obj = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:&error];

        if (error) {

        } else {
            NSLog(@"%@",obj);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        }
        
    }];
    
    [task resume];

}

//登陆
+ (void)logingWithUsername:(NSString *)username AndPassword:(NSString *)password {
    //1.获取资源地址
    NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"https://leancloud.cn:443/1.1/login?username=%@&password=%@",username,password]];
    
    //2.创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //3.配置请求
    request.timeoutInterval = 10.f; //请求超时
    
    request.HTTPMethod = @"get";    //设置请求方法
    
    //配置头部请求
    [request setValue:POST_Url_Id forHTTPHeaderField:@"X-LC-Id"];
    [request setValue:POST_Url_Apikey forHTTPHeaderField:@"X-LC-Key"];
    
//    NSDictionary *parmStr = @{@"data-urlencode":username,@"data-urlencode":password};
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parmStr options:NSJSONWritingPrettyPrinted error:nil];
//    request.HTTPBody = jsonData;
    
    
    //4.创建网络会话
    NSURLSession *session = [NSURLSession sharedSession];
    
    //5.创建网络会话任务
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        id obj = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:&error];
        
        if (error) {
            
        } else {
            NSLog(@"%@",obj);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        }
        
    }];
    
    [task resume];
}


@end
