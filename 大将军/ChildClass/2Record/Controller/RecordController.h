//
//  RecordController.h
//  大将军
//
//  Created by 石燚 on 16/7/6.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RecordDelegate <NSObject>

- (void)RecordClickLeftBtn;

@end

@interface RecordController : UIViewController

@property (nonatomic, weak) id<RecordDelegate> delegate;

@end
