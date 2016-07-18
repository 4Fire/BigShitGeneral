//
//  AppDelegate.m
//  大将军
//
//  Created by 石燚 on 16/7/15.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import "AppDelegate.h"

#import "MainTabbarController.h"
#import "LoginViewController.h"
#import "AddDogViewController.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialWechatHandler.h"
#import <CoreData/CoreData.h>
#import "Context.h"
#import "Owner.h"
#import "Dog.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:@"ownerAccount"];
    if (account && ![account isEqualToString:@""]) {
        
        NSManagedObjectContext *ctx = [Context context];
        Owner *owner = [Owner fetchOwnerToSQLiterWithContext:ctx Account:account];
        if (!owner) {
            LoginViewController *mainVc = [[LoginViewController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mainVc];
            self.window.rootViewController = nav;
        }else {
            NSArray<Dog *> *dogs = [Dog fetchAllDogsFromSQLiterWithContext:ctx withOwner:owner];
            for (Dog *dog in dogs) {
                NSLog(@"%@", dog.name);
            }
            if (dogs.count > 0) {
                MainTabbarController *tabbarVc = [[MainTabbarController alloc] init];
                self.window.rootViewController = tabbarVc;
            }else {
            AddDogViewController *addDog = [[AddDogViewController alloc] init];
            self.window.rootViewController = addDog;
            }
        }
    }else {
    
         LoginViewController *mainVc = [[LoginViewController alloc]init];
         UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mainVc];
        self.window.rootViewController = nav;
    }
    
    [self.window makeKeyAndVisible];
    
#pragma mark - 配置第三方APPID
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:Appkey];
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wx535a166b6fc10c2f" appSecret:@"22c55dab108007fd2440d8d97c23aeff" url:@"http://user.qzone.qq.com/799155018/infocenter?ptsig=v6XoGwRUWG8*txB2crrnEdVGdj5sUVSCNnGQ5FiKBk8_"];
    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:@"http://user.qzone.qq.com/799155018/infocenter?ptsig=v6XoGwRUWG8*txB2crrnEdVGdj5sUVSCNnGQ5FiKBk8_"];
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。需要 #import "UMSocialSinaSSOHandler.h"
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3050076814"
                                              secret:@"b06eea4f9b73a3e8f6eaeb4e5cbda3b4" RedirectURL:@"http://weibo.com/u/2456110315/home?wvr=5"];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
