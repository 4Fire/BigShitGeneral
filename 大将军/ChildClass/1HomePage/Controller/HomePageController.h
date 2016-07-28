//
//  HomePageController.h
//  大将军
//
//  Created by 石燚 on 16/7/6.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomePageDelegate <NSObject>

- (void)clickLeftBtn;

@end

@interface HomePageController : UIViewController

@property (nonatomic, strong) UIButton *drawBtn;

@property (nonatomic, weak) id<HomePageDelegate> delegate;

- (void)returnToday;

@end
