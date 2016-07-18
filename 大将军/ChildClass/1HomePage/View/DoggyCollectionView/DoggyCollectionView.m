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

@interface DoggyCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collection;

@end

@implementation DoggyCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame WithDoggyArray:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        self.doggyArray = array;
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
    
    
    cell.backgroundColor = COLOR(247, 68, 97);
    cell.doggyIcon.image = [UIImage imageNamed:@"dogD"];
    
    
    
    cell.layer.cornerRadius = (SCREEN_WIDTH - 30) / 6;
    cell.layer.masksToBounds = YES;
    
    return cell;
}


#pragma mark - setter;
- (void)setDoggyArray:(NSArray *)doggyArray {
    _doggyArray = doggyArray;
    [self.collection reloadData];
}

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




@end





