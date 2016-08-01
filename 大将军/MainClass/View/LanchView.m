//
//  LanchView.m
//  大将军
//
//  Created by 石燚 on 16/8/1.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import "LanchView.h"

@interface LanchView ()

// block属性
@property (nonatomic, copy) void(^block)();

@end

@implementation LanchView

- (instancetype)initWithFrame:(CGRect)frame EndBlock:(void(^)())endBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        _block = endBlock;
        [self initalizeInterface];
    }
    return self;
}

- (void)initalizeInterface {
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:@"background.jpeg"]]];
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:@"屎字1.png"]]];
    
    titleImageView.bounds = CGRectMake(0, 0, SCREEN_WIDTH * 0.5, SCREEN_WIDTH * 0.3);
    titleImageView.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.35 + 50);
    titleImageView.alpha = 0;
    
    //////
    UIImageView *titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:@"狗head.png"]]];
    titleIconView.bounds = CGRectMake( 0, 0, SCREEN_WIDTH * 0.45, SCREEN_WIDTH * 0.45);
    titleIconView.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.18 + 50);
    titleIconView.alpha = 0;
    ///////////
    
    
    UIView *viewtest = [[UIView alloc] initWithFrame:self.bounds];
    viewtest.backgroundColor = [UIColor colorWithWhite:0.08 alpha:0];
    [self addSubview:viewtest];
    [self addSubview:titleIconView];
    [self addSubview:titleImageView];
    [UIView animateWithDuration:2 animations:^{
        
        titleImageView.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.35);
        titleImageView.alpha = 1;
        
        titleIconView.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.18);
        titleIconView.alpha = 1;
        
        viewtest.backgroundColor = [UIColor colorWithWhite:0.08 alpha:0.9];
        
        
    } completion:^(BOOL finished) {
        if (_block) {
            _block();
        }
        [UIView animateWithDuration:1 animations:^{
            [self removeFromSuperview];
        }];
    }];
}

@end
