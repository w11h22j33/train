//
//  SharedInstance.m
//  train
//
//  Created by wanghaijun on 14-3-27.
//  Copyright (c) 2014年 ___NAVY___. All rights reserved.
//

#import "SharedInstance.h"
#import "Station.h"

@interface SharedInstance (){
    
    
    
}

@property (nonatomic,strong) NSString *loginFlag;

@end

@implementation SharedInstance

@synthesize cookies,loginFlag,stations;

static SharedInstance * instance;

+(SharedInstance *)sharedInstance{
    
    if (instance == nil) {
        instance = [SharedInstance new];
        instance.cookies = [[NSMutableDictionary alloc] initWithCapacity:4];
        instance.stations = [[NSMutableDictionary alloc] initWithCapacity:2048];
    }
    
    return instance;
    
}

+(void)addCookie:(NSString *)value forKey:(NSString *)key{
    
    NSLog(@"addCookie:%@-%@",key,value);
    
    SharedInstance *instance = [SharedInstance sharedInstance];
    
    [instance.cookies setObject:value forKey:key];
}



+ (void)addCookieFromInitResponse:(NSString *)responseString{
    
    NSArray * array = [NSArray arrayWithObjects:@"path",@"Path",nil];
    
    NSString *newString = [responseString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSArray* array1 = [newString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@";,="]];
    
    int size = array1.count;
    
    for (int index = 0; index < size; index = index + 2) {
        
        NSString* key = [array1 objectAtIndex:index];
        NSString* value = [array1 objectAtIndex:index+1];
        
        if (key != nil && ![key isEqualToString:@""] && value != nil && ![value isEqualToString:@""]) {
            
            if ([array containsObject:key]) {
                continue;
            }else{
                [SharedInstance addCookie:value forKey:key];
            }
            
        }
        
    }
    
    NSLog(@"cookies:%@",[[SharedInstance sharedInstance] cookies]);
    
}

+ (void)setLoginFlag:(BOOL)flag{
    
    [[SharedInstance sharedInstance] setLoginFlag:flag?@"YES":@"NO"];
    
}

+ (BOOL)isLogin{
    
    NSString* loginFlag = [[SharedInstance sharedInstance] loginFlag];
    
    return [@"YES" isEqualToString:loginFlag];
    
}

+ (void)initStations:(NSString *)string{
    
    if (string == nil || [@"" isEqualToString:string]) {
        return;
    }
    
    NSMutableDictionary* stations = [SharedInstance sharedInstance].stations;
    
    NSArray* array1 = [string componentsSeparatedByString:@"@"];
    
    int count = array1.count;
    
    for (int index = 1; index < count; index++) {
        
        NSString* stationString = [array1 objectAtIndex:index];
        
        NSArray* array = [stationString componentsSeparatedByString:@"|"];
        
        Station *sat = [[Station alloc] initWithString:array];
        
        [stations setObject:sat forKey:sat.sZHName];
        
    }
    
    NSLog(@"stations:%@",stations);
    
}

@end
