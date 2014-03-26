//
//  SharedInstance.m
//  train
//
//  Created by wanghaijun on 14-3-27.
//  Copyright (c) 2014年 ___NAVY___. All rights reserved.
//

#import "SharedInstance.h"

@interface SharedInstance ()

@property (nonatomic,strong) NSMutableDictionary* cookies;

@end

@implementation SharedInstance

@synthesize cookies;

static SharedInstance * instance;

+(SharedInstance *)sharedInstance{
    
    if (instance == nil) {
        instance = [SharedInstance new];
    }
    
    return instance;
    
}

@end
