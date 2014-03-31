//
//  OrderViewController.h
//  train
//
//  Created by wanghaijun on 14-3-30.
//  Copyright (c) 2014年 ___NAVY___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassengerInfo.h"
#import "TrainInfo.h"
#import "PassengerTableViewController.h"

@interface OrderViewController : UIViewController<PassengerTableViewControllerDelegate>

@property (nonatomic,strong) PassengerInfo *passInfo;
@property (nonatomic,strong) TrainInfo *trainInfo;

@end
