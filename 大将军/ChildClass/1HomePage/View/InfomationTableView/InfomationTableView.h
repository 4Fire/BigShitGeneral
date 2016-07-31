//
//  InfomationTableView.h
//  大将军
//
//  Created by 石燚 on 16/7/8.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InfomationTableView;

@protocol  InfomationTableDelegate <NSObject>

- (void)InfomationTableView:(UITableView *)infoTable didSelectIndepathForCell:(NSIndexPath *)indexPath;

@end


@interface InfomationTableView : UIView

@property (nonatomic, weak) id<InfomationTableDelegate> delegate;

@end
