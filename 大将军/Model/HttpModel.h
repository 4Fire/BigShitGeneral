//
//  HttpModel.h
//  大将军
//
//  Created by 石燚 on 16/7/31.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpModel : NSObject

//注册的网络请求
+ (void)registerWihtUsername:(NSString *)username AndPassword:(NSString *)password;

//登陆的网络请求
+ (void)logingWithUsername:(NSString *)username AndPassword:(NSString *)password;

@end
