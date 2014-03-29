//
//  Station.m
//  train
//
//  Created by wanghaijun on 14-3-27.
//  Copyright (c) 2014年 ___NAVY___. All rights reserved.
//

#import "Station.h"

@implementation Station

@synthesize sFullName,sIndex,sNo,sShortName,sSortName,sZHName;

- (id)initWithString:(NSArray *)array{
    
    self = [super init];
    
    self.sShortName = [array objectAtIndex:0];
    self.sZHName = [array objectAtIndex:1];
    self.sNo = [array objectAtIndex:2];
    self.sFullName = [array objectAtIndex:3];
    self.sSortName = [array objectAtIndex:4];
    self.sIndex = [array objectAtIndex:5];
    
    return self;
    
}

- (NSString *)description{
    
    return [NSString stringWithFormat:@"%@，%@，%@",self.sZHName,self.sFullName,self.sNo];
    
}

@end
