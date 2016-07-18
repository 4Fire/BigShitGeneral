//
//  CalendarCell.h
//  大将军
//
//  Created by 石燚 on 16/7/7.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *day;
@property (nonatomic, strong) UILabel *month;
@property (nonatomic, strong) UIView *tesView;
@property (nonatomic, strong) NSDate *date;

@end
