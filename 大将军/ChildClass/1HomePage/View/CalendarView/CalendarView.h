//
//  CalendarView.h
//  大将军
//
//  Created by 石燚 on 16/7/7.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalendarView;

@protocol CalendarDelegate <NSObject>

- (void)didselectDate;

@end


@interface CalendarView : UIView

@property (nonatomic, weak) id<CalendarDelegate> delegate;

- (instancetype)init;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)scrollToCenter;

@end
