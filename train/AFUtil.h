//
//  AFUtil.h
//  train
//
//  Created by wanghaijun on 14-3-27.
//  Copyright (c) 2014年 ___NAVY___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFUtil : NSObject

+ (void)doGet:(NSString*)urlString parameters:(NSMutableDictionary*)parameters responseSerializer:(AFHTTPResponseSerializer*)responseSerializer success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)doPost:(NSString*)urlString parameters:(NSMutableDictionary*)parameters responseSerializer:(AFHTTPResponseSerializer*)responseSerializer success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
