//
//  PassengerInfo.h
//  train
//
//  Created by wanghaijun on 14-3-30.
//  Copyright (c) 2014年 ___NAVY___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PassengerInfo : NSObject

/**
 
 {"code":"1",
 "passenger_name":"朱媛",
 "sex_code":"F",
 "sex_name":"女",
 "born_date":"1984-01-14 00:00:00",
 "country_code":"CN",
 "passenger_id_type_code":"1",
 "passenger_id_type_name":"二代身份证",
 "passenger_id_no":"37250119840114604X",
 "passenger_type":"1",
 "passenger_flag":"0",
 "passenger_type_name":"成人",
 "mobile_no":"18618268346",
 "phone_no":"",
 "email":"navy.zy@gmail.com",
 "address":"",
 "postalcode":"",
 "first_letter":"ZY",
 "recordCount":"3",
 "total_times":"99",
 "index_id":"2"}
 
 **/

@property (nonatomic,strong) NSString *p_code;
@property (nonatomic,strong) NSString *p_passenger_name;
@property (nonatomic,strong) NSString *p_sex_code;
@property (nonatomic,strong) NSString *p_sex_name;
@property (nonatomic,strong) NSString *p_born_date;
@property (nonatomic,strong) NSString *p_country_code;
@property (nonatomic,strong) NSString *p_passenger_id_type_code;
@property (nonatomic,strong) NSString *p_passenger_id_type_name;
@property (nonatomic,strong) NSString *p_passenger_id_no;
@property (nonatomic,strong) NSString *p_passenger_type;
@property (nonatomic,strong) NSString *p_passenger_flag;
@property (nonatomic,strong) NSString *p_passenger_type_name;
@property (nonatomic,strong) NSString *p_mobile_no;
@property (nonatomic,strong) NSString *p_phone_no;
@property (nonatomic,strong) NSString *p_email;
@property (nonatomic,strong) NSString *p_address;
@property (nonatomic,strong) NSString *p_postalcode;
@property (nonatomic,strong) NSString *p_first_letter;
@property (nonatomic,strong) NSString *p_recordCount;
@property (nonatomic,strong) NSString *p_total_times;
@property (nonatomic,strong) NSString *p_index_id;

- (id)initWithDic:(NSDictionary*)dic;

@end
