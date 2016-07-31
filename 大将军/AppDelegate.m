//
//  AppDelegate.m
//  大将军
//
//  Created by 石燚 on 16/7/15.
//  Copyright © 2016年 SingYi. All rights reserved.
//

//leanCloud
#import <AVOSCloud/AVOSCloud.h>;


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
    //leanCloud
    [AVOSCloud setApplicationId:@"1g0inh8S6gA6zmogkU6bkA19-gzGzoHsz"
                      clientKey:@"8qhdXls0HgxhHpqp6LN0vXGS"];
    
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
//            for (Dog *dog in dogs) {
//                NSLog(@"%@", dog.name);
//                NSLog(@"%@", dog.iconImage);
//            }
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
    [self saveContext];
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
    [self saveContext];
}


#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = [Context context];
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
@end
