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

@interface DetailTableViewController : UITableViewController

@property (nonatomic,strong) TrainInfo *train;

@end
