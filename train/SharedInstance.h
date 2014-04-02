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

@property (nonatomic,strong) NSMutableArray* cookies;
@property (nonatomic,strong) NSMutableArray* stations;
@property (nonatomic,strong) Station* beginStation;
@property (nonatomic,strong) Station* endStation;
@property (nonatomic,strong) NSString* trainDateString;

+ (SharedInstance*)sharedInstance;

+ (void)addCookie:(NSString*)value forKey:(NSString*)key;

+ (void)addCookieFromInitResponse:(NSString*)responseString;

+ (NSString*)getCookieForKey:(NSString*)key;

+ (void)setLoginFlag:(BOOL)flag;

+ (BOOL)isLogin;

+ (void)initStations:(NSString*)string;

@end
