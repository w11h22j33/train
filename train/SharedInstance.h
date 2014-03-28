//
//  SharedInstance.h
//  train
//
//  Created by wanghaijun on 14-3-27.
//  Copyright (c) 2014年 ___NAVY___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Station.h"

@interface SharedInstance : NSObject

@property (nonatomic,strong) NSMutableDictionary* cookies;
@property (nonatomic,strong) NSMutableDictionary* stations;
@property (nonatomic,strong) Station* beginStation;
@property (nonatomic,strong) Station* endStation;

+ (SharedInstance*)sharedInstance;

+ (void)addCookie:(NSString*)value forKey:(NSString*)key;

+ (void)addCookieFromInitResponse:(NSString*)responseString;

+ (void)setLoginFlag:(BOOL)flag;

+ (BOOL)isLogin;

+ (void)initStations:(NSString*)string;

@end
