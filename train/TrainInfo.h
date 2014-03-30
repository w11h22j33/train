//
//  TrainInfo.h
//  train
//
//  Created by wanghaijun on 14-3-27.
//  Copyright (c) 2014年 ___NAVY___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrainInfo : NSObject

/**
 
 "train_no":"01000K108402",
 "station_train_code":"K1081",
 
 "start_station_telecode":"HBB",
 "start_station_name":"哈尔滨",
 "end_station_telecode":"TYV",
 "end_station_name":"太原",
 
 "from_station_telecode":"BJP",
 "from_station_name":"北京",
 "from_station_no":"18",
 "to_station_telecode":"TYV",
 "to_station_name":"太原",
 "to_station_no":"25",
 
 "start_time":"02:33",
 "arrive_time":"10:49",
 "day_difference":"0",
 
 "train_class_name":"",
 
 "lishi":"08:16",
 
 **/

@property (nonatomic,strong) NSString *t_train_no;
@property (nonatomic,strong) NSString *t_station_train_code;

@property (nonatomic,strong) NSString *t_start_station_telecode;
@property (nonatomic,strong) NSString *t_start_station_name;
@property (nonatomic,strong) NSString *t_end_station_telecode;
@property (nonatomic,strong) NSString *t_end_station_name;

@property (nonatomic,strong) NSString *t_from_station_telecode;
@property (nonatomic,strong) NSString *t_from_station_name;
@property (nonatomic,strong) NSString *t_from_station_no;
@property (nonatomic,strong) NSString *t_to_station_telecode;
@property (nonatomic,strong) NSString *t_to_station_name;
@property (nonatomic,strong) NSString *t_to_station_no;

@property (nonatomic,strong) NSString *t_start_time;
@property (nonatomic,strong) NSString *t_arrive_time;
@property (nonatomic,strong) NSString *t_day_difference;
@property (nonatomic,strong) NSString *t_lishi;

/**
 
 "swz_num":"--"商务座
 "tz_num":"--",特等座
 "zy_num":"--",一等座
 "ze_num":"--",二等座
 
 "gr_num":"-- ",高级软卧
 "rw_num":"11",软卧
 "yw_num":"有",硬卧
 
 "rz_num":"--",软座
 "yz_num":"有",硬座
 "wz_num":"有",无座
 "qt_num":"--",其他
 
 **/



@property (nonatomic,strong) NSString *t_swz_num;
@property (nonatomic,strong) NSString *t_tz_num;
@property (nonatomic,strong) NSString *t_zy_num;
@property (nonatomic,strong) NSString *t_ze_num;

@property (nonatomic,strong) NSString *t_gr_num;
@property (nonatomic,strong) NSString *t_rw_num;
@property (nonatomic,strong) NSString *t_yw_num;

@property (nonatomic,strong) NSString *t_rz_num;
@property (nonatomic,strong) NSString *t_yz_num;
@property (nonatomic,strong) NSString *t_wz_num;
@property (nonatomic,strong) NSString *t_qt_num;

/**
 
 "canWebBuy":"IS_TIME_NOT_BUY",可购买标志：Y为可买
 
 "lishiValue":"496",
 
 "yp_info":"1009103191402530001110091001093016400073",
 
 "control_train_day":"20201231",
 
 "start_train_date":"20140327",
 
 "seat_feature":"W3431333",
 
 "yp_ex":"10401030",
 
 "train_seat_feature":"3",
 
 "seat_types":"1413",
 
 "location_code":"B2",
 
 "control_day":19,
 
 "sale_time":"1000",
 
 "is_support_card":"0",可凭二代身份证直接进出站
 
**/

@property (nonatomic,strong) NSString *t_canWebBuy;
@property (nonatomic,strong) NSString *t_is_support_card;
@property (nonatomic,strong) NSString *t_start_train_date;

- (id)initWithDic:(NSDictionary*)dic;

@end
