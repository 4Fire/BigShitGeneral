//
//  DoggyInfoController.m
//  大将军
//
//  Created by 石燚 on 16/7/26.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import "DoggyInfoController.h"

@interface DoggyInfoController ()

@end

@implementation DoggyInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUNDCOLOR;
}

#pragma mark - setter
- (void)setDog:(Dog *)dog {
    _dog = dog;
}




@end
