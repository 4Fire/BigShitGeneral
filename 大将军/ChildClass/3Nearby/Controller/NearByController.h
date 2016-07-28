//
//  NearByController.h
//  大将军
//
//  Created by 郑晋洋 on 16/7/6.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NearbyDeleagete <NSObject>

- (void)NearbyClickLeftBtn;

@end

@interface NearByController : UIViewController

@property (nonatomic, weak) id<NearbyDeleagete> delegate;

@end
