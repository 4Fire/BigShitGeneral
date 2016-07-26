//
//  DoggyInfoController.m
//  大将军
//
//  Created by 石燚 on 16/7/26.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import "DoggyInfoController.h"

@interface DoggyInfoController ()
@property (nonatomic, strong) UIImageView *titleImage;
@property (nonatomic, strong) UIImageView *dogIcon;
@property (nonatomic, strong) UILabel *dogName;
@property (nonatomic, strong) UILabel *dogSex;
@property (nonatomic, strong) UILabel *dogAge;

@end

@implementation DoggyInfoController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = BACKGROUNDCOLOR;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - setter
- (void)setDog:(Dog *)dog {
    _dog = dog;
}
@end
