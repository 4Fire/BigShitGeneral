//
//  PersonDogsCell.h
//  大将军
//
//  Created by apple on 16/7/19.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PersonDogsCell;

@protocol PersonDogsCellDelegate <NSObject>

@optional
-(void)personDogsCellDeletecell:(PersonDogsCell *)cell;

@end


@interface PersonDogsCell : UICollectionViewCell
@property (nonatomic, weak)   id<PersonDogsCellDelegate> delegate;
@property (nonatomic, strong) UIImageView *dogIcon;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, assign) NSInteger rowIndex;
@property (nonatomic, assign) BOOL isDeleted;
@property (nonatomic, strong) UILongPressGestureRecognizer *gesture;
@end
