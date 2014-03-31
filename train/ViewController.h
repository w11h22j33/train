//
//  ViewController.h
//  train
//
//  Created by wanghaijun on 14-3-26.
//  Copyright (c) 2014年 ___NAVY___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StationTableViewController.h"
#import "TrainTableViewController.h"
#import "PassengerTableViewController.h"

#define KEY_ACCOUNT @"key_account"
#define KEY_PASSWORD @"key_password"

@interface ViewController : UIViewController<StationTableViewControllerDelegate>

@end
