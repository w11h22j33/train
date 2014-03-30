//
//  StationTableViewTableViewController.h
//  train
//
//  Created by wanghaijun on 14-3-27.
//  Copyright (c) 2014年 ___NAVY___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Station.h"
#import "TrainInfo.h"
#import "PassengerInfo.h"

@protocol PassengerTableViewControllerDelegate<NSObject>

- (void)didSelectedPassenger:(PassengerInfo*)passenger;

@end

@interface PassengerTableViewController : UITableViewController

@property (nonatomic,assign) id<PassengerTableViewControllerDelegate> delegate;

@end
