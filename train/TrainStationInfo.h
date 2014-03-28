//
//  TrainStationInfo.h
//  train
//
//  Created by wanghaijun on 14-3-28.
//  Copyright (c) 2014年 ___NAVY___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrainStationInfo : NSObject

/**
 
 {
 -------------前5条数据只有始发站信息有----------------
 "start_station_name":"北京西",
 "station_train_code":"T69",
 "train_class_name":"特快",
 "service_type":"1",
 "end_station_name":"乌鲁木齐",
 -----------------------------
 
 "arrive_time":"----",
 "station_name":"北京",
 "start_time":"10:01",
 "stopover_time":"----",
 "station_no":"01",
 "isEnabled":false}
 **/

@property (nonatomic,strong) NSString *ts_start_station_name;
@property (nonatomic,strong) NSString *ts_station_train_code;
@property (nonatomic,strong) NSString *ts_train_class_name;
@property (nonatomic,strong) NSString *ts_service_type;
@property (nonatomic,strong) NSString *ts_end_station_name;

@property (nonatomic,strong) NSString *ts_arrive_time;
@property (nonatomic,strong) NSString *ts_station_name;
@property (nonatomic,strong) NSString *ts_start_time;
@property (nonatomic,strong) NSString *ts_stopover_time;
@property (nonatomic,strong) NSString *ts_station_no;
@property (nonatomic,strong) NSString *ts_isEnabled;

- (id)initWithDic:(NSDictionary*)dic;

@end
