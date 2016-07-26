//
//  DoggyCollectionView.h
//  大将军
//
//  Created by 石燚 on 16/7/7.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DoggyCollectionView;

@protocol doggyCollectionDelegate <NSObject>

- (void)didselectDoggy:(Dog *)dog;

@end

@interface DoggyCollectionView : UIView

@property (nonatomic, weak) id<doggyCollectionDelegate> delegate;

@property (nonatomic, strong) NSArray *doggyArray;

@property (nonatomic, strong) UICollectionView *collection;

- (instancetype)initWithFrame:(CGRect)frame WithDoggyArray:(NSArray *)array;

@end
