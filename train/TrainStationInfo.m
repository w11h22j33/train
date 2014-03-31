//
//  TrainStationInfo.m
//  train
//
//  Created by wanghaijun on 14-3-28.
//  Copyright (c) 2014年 ___NAVY___. All rights reserved.
//

#import "TrainStationInfo.h"

@implementation TrainStationInfo

@synthesize ts_arrive_time,ts_end_station_name,ts_isEnabled,ts_service_type,ts_start_station_name,ts_start_time,ts_station_name,ts_station_no,ts_station_train_code,ts_stopover_time,ts_train_class_name;

- (id)initWithDic:(NSDictionary *)dic{
    
    self = [super init];
    
    NSArray *keys = [dic allKeys];
    
    for (NSString *key in keys) {
        
        NSString *propertyKey = [NSString stringWithFormat:@"ts_%@",key];
        NSString *propertySelector = [NSString stringWithFormat:@"setTs_%@:",key];
        
        if ([self respondsToSelector:NSSelectorFromString(propertySelector)]) {
            
            [self setValue:[dic objectForKey:key] forKey:propertyKey];
            
        }
        
    }
    
    return self;
    
}

- (NSString *)description{
    
    return [NSString stringWithFormat:@"%@ %@ : %@ --> %@ ; 停车%@",ts_station_no,ts_station_name,ts_arrive_time,ts_start_time,ts_stopover_time];
    
}

@end
