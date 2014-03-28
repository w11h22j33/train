//
//  StationTableViewTableViewController.h
//  train
//
//  Created by wanghaijun on 14-3-27.
//  Copyright (c) 2014年 ___NAVY___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Station.h"

@protocol StationTableViewControllerDelegate<NSObject>

- (void)didSelectedStation:(Station*)station stationType:(NSString*)stationType;

@end

@interface StationTableViewController : UITableViewController

@property (nonatomic,strong) NSString *stationType;
@property (nonatomic,assign) id<StationTableViewControllerDelegate> delegate;

@end
