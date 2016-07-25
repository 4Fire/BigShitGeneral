//
//  DogInfoViewController.h
//  大将军
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dog.h"

@protocol DogInfoViewControllerDelegate <NSObject>

- (void)dogInfoDidChanged;

@end


@interface DogInfoViewController : UIViewController
@property (nonatomic, strong) Dog *dog;

@property (nonatomic, weak) id<DogInfoViewControllerDelegate> delegate;

@end
