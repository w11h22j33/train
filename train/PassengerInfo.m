//
//  PassengerInfo.m
//  train
//
//  Created by wanghaijun on 14-3-30.
//  Copyright (c) 2014年 ___NAVY___. All rights reserved.
//

#import "PassengerInfo.h"

@implementation PassengerInfo

@synthesize p_address,p_born_date,p_code,p_country_code,p_email,p_first_letter,p_index_id,p_mobile_no,p_passenger_flag,p_passenger_id_no,p_passenger_id_type_code,p_passenger_id_type_name,p_passenger_name,p_passenger_type,p_passenger_type_name,p_phone_no,p_postalcode,p_recordCount,p_sex_code,p_sex_name,p_total_times;

- (id)initWithDic:(NSDictionary *)dic{
    
    self = [super init];
    
    NSArray *keys = [dic allKeys];
    
    for (NSString *key in keys) {
        
        NSString *propertyKey = [NSString stringWithFormat:@"p_%@",key];
        NSString *propertySelector = [NSString stringWithFormat:@"setP_%@:",key];
        
        if ([self respondsToSelector:NSSelectorFromString(propertySelector)]) {
            
            [self setValue:[dic objectForKey:key] forKey:propertyKey];
            
        }
        
    }
    
    return self;
    
}

- (NSString *)description{
    
    return [NSString stringWithFormat:@"%@ %@ %@ %@ %@",p_passenger_name,p_sex_name,p_passenger_id_no,p_mobile_no,p_email];
    
}

@end
