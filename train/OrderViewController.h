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

@interface OrderViewController : UIViewController

@property (nonatomic,strong) PassengerInfo *passInfo;
@property (nonatomic,strong) TrainInfo *trainInfo;

@end
