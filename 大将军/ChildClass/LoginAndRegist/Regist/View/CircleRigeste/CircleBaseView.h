//
//  NameView.h
//  大将军
//
//  Created by apple on 16/7/12.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleBaseView : UIView
@property (nonatomic, strong) UIView *titleView;

- (void)addEdgingWithEdgingColor:(UIColor *)edgColor;
@end
