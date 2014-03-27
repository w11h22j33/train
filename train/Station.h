//
//  Station.h
//  train
//
//  Created by wanghaijun on 14-3-27.
//  Copyright (c) 2014年 ___NAVY___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Station : NSObject

@property (nonatomic,strong) NSString* sShortName;
@property (nonatomic,strong) NSString* sZHName;
@property (nonatomic,strong) NSString* sNo;
@property (nonatomic,strong) NSString* sFullName;
@property (nonatomic,strong) NSString* sSortName;
@property (nonatomic,strong) NSString* sIndex;

- initWithString:(NSArray*)array;

@end
