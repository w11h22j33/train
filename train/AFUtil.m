//
//  AFUtil.m
//  train
//
//  Created by wanghaijun on 14-3-27.
//  Copyright (c) 2014年 ___NAVY___. All rights reserved.
//

#import "AFUtil.h"
#import "SharedInstance.h"

typedef void(^BlockAddHeader)(AFHTTPRequestOperationManager *);

@interface AFUtil()

@end

@implementation AFUtil


BlockAddHeader addHeader = ^(AFHTTPRequestOperationManager * manager){
    
    NSLog(@"addHeader -->");
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"*/*" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"*/*; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager.requestSerializer setValue:@"Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; .NET4.0C; InfoPath.2; .NET4.0E)" forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
    [manager.requestSerializer setValue:@"zh-cn" forHTTPHeaderField:@"Accept-Language"];
    [manager.requestSerializer setValue:@"Keep-Alive" forHTTPHeaderField:@"Connection"];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
};

BlockAddHeader addCookie =  ^(AFHTTPRequestOperationManager * manager){
    
    NSDictionary* headers = [SharedInstance sharedInstance].cookies;
    
    if (headers) {
        
        NSArray *keys = headers.allKeys;
        
        if (keys && keys.count > 0) {
            
            NSMutableString* cookieString = [[NSMutableString alloc] init];
            
            for (NSString* key in keys) {
                
                [cookieString appendFormat:@"%@=%@",key,[headers objectForKey:key]];
                
                if ([keys indexOfObject:key] < keys.count-1) {
                    
                    [cookieString appendString:@";"];
                }
                
                
            }
            
            NSLog(@"cookieString:%@",cookieString);
            
            [manager.requestSerializer setValue:cookieString forHTTPHeaderField:@"Cookie"];
            
        }else{
            NSLog(@"there is no cookie!!!");
        }
        
    }else{
        NSLog(@"there is no cookie!!!");
    }
    
};

+ (void)doRequest:(NSString*)method urlString:(NSString*)urlString parameters:(NSMutableDictionary*)parameters responseSerializer:(AFHTTPResponseSerializer*)responseSerializer success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    addHeader(manager);
    
    addCookie(manager);
    
    if (responseSerializer) {
        manager.responseSerializer = responseSerializer;
    }
    
    if ([@"GET" isEqualToString:method]) {
        [manager GET:urlString parameters:parameters success:success failure:failure];
    }else if([@"POST" isEqualToString:method]){
        [manager POST:urlString parameters:parameters success:success failure:failure];
    }
    
    
    
}

+ (void)doGet:(NSString*)urlString parameters:(NSMutableDictionary*)parameters responseSerializer:(AFHTTPResponseSerializer*)responseSerializer success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    [AFUtil doRequest:@"GET" urlString:urlString parameters:parameters responseSerializer:responseSerializer success:success failure:failure];
    
}

+ (void)doPost:(NSString*)urlString parameters:(NSMutableDictionary*)parameters responseSerializer:(AFHTTPResponseSerializer*)responseSerializer success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    [AFUtil doRequest:@"POST" urlString:urlString parameters:parameters responseSerializer:responseSerializer success:success failure:failure];
    
}


@end
