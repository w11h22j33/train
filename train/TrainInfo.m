//
//  TrainInfo.m
//  train
//
//  Created by wanghaijun on 14-3-27.
//  Copyright (c) 2014年 ___NAVY___. All rights reserved.
//

#import "TrainInfo.h"

@implementation TrainInfo

@synthesize t_arrive_time,t_canWebBuy,t_day_difference,t_end_station_name,t_end_station_telecode,t_from_station_name,t_from_station_no,t_from_station_telecode;

@synthesize t_gr_num,t_is_support_card,t_lishi,t_qt_num,t_rw_num,t_rz_num,t_start_train_date;

@synthesize t_start_station_name,t_start_station_telecode,t_start_time,t_station_train_code,t_swz_num,t_to_station_name,t_to_station_no;

@synthesize t_to_station_telecode,t_train_no,t_tz_num,t_wz_num,t_yw_num,t_yz_num,t_ze_num,t_zy_num;

@synthesize t_lishiValue,t_secretStr,t_yp_info;

- (id)initWithDic:(NSDictionary *)dic{
    
    self = [super init];
    
    NSArray *keys = [dic allKeys];
    
    for (NSString *key in keys) {
        
        NSString *propertyKey = [NSString stringWithFormat:@"t_%@",key];
        NSString *propertySelector = [NSString stringWithFormat:@"setT_%@:",key];

        if ([self respondsToSelector:NSSelectorFromString(propertySelector)]) {
            
            [self setValue:[dic objectForKey:key] forKey:propertyKey];
            
        }
        
    }
    
    return self;
    
}

- (NSString *)description{
    
    return [NSString stringWithFormat:@"%@->%@ ;%@->%@ ;车次:%@ ;编号:%@",t_from_station_name,t_end_station_name,t_start_time,t_arrive_time,t_station_train_code,t_train_no];
    
}

@end
