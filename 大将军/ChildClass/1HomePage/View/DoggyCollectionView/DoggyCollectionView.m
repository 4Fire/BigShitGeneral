//
//  DoggyCollectionView.m
//  大将军
//
//  Created by 石燚 on 16/7/7.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import "DoggyCollectionView.h"
#import "DoggyCell.h"
#import "DoggyLayout.h"
#import "Dog.h"
#import "DoggyModel.h"
#import "Context.h"

@interface DoggyCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource>


@end

static NSInteger currentDog = 0;

@implementation DoggyCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame WithDoggyArray:(NSArray *)array {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserInterface];
    }
    return self;
}



- (void)initUserInterface {
    [self addSubview:self.collection];
}

#pragma mark - dataSource;
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.doggyArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DoggyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DoggyCell" forIndexPath:indexPath];

    
    Dog *dog = self.doggyArray[indexPath.row];
    cell.doggyIcon.image = [UIImage imageWithData:dog.iconImage];
    
    cell.layer.cornerRadius = (SCREEN_WIDTH - 30) / 6;
    cell.layer.masksToBounds = YES;
    
    if (dog.sex.integerValue == 0) {
        cell.backgroundColor = COLOR(247, 68, 97);
    } else {
        cell.backgroundColor = COLOR(147, 224, 254);
    }
    
    if (indexPath.item == currentDog) {
        cell.coverView.hidden = YES;
    } else {
        cell.coverView.hidden = NO;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    currentDog = indexPath.item;
    [collectionView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(didselectDoggy:)]) {
        [self.delegate didselectDoggy:self.doggyArray[indexPath.row]];
    }
}


#pragma mark - setter;


#pragma mark - getter;
- (UICollectionView *)collection {
    if (!_collection) {
        DoggyLayout  *layout = [[DoggyLayout alloc]init];
        
        layout.itemSize = CGSizeMake((SCREEN_WIDTH - 30) / 3, (SCREEN_WIDTH - 30) / 3);
    
        _collection = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        
        _collection.delegate = self;
        _collection.dataSource = self;
        
        
        [_collection registerClass:[DoggyCell class] forCellWithReuseIdentifier:@"DoggyCell"];
        
        _collection.backgroundColor = BACKGROUNDCOLOR;
    }
    return _collection;
}



- (NSArray *)doggyArray {
    _doggyArray = [DoggyModel getAllDogsWithCurrentOwner];
    return _doggyArray;
}




@end





