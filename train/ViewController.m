//
//  ViewController.m
//  CocoapodsDemo
//
//  Created by wanghaijun on 14-3-7.
//  Copyright (c) 2014年 ___NAVY___. All rights reserved.
//

#import "ViewController.h"
#import "SharedInstance.h"
#import <UIImageView+AFNetworking.h>
#import "AFUtil.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tfAccount;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UITextField *tfVerCode;
@property (weak, nonatomic) IBOutlet UITextField *tfBeginStation;
@property (weak, nonatomic) IBOutlet UITextField *tfEndStation;

@property (weak, nonatomic) IBOutlet UIImageView *imageVerCode;
@property (strong,nonatomic) SharedInstance *sharedInstance;


- (IBAction)actionButtonClicked:(id)sender;
- (IBAction)actionRefreshVerCode:(id)sender;
- (IBAction)actionSelectStation:(id)sender;
- (IBAction)actionQueryTrain:(id)sender;

- (void)doInit;
- (void)getVerCode;
- (void)doLogin:(NSString*)verCode account:(NSString*)account password:(NSString*)password;

@end

@implementation ViewController

@synthesize tfAccount,tfPassword,imageVerCode,sharedInstance,tfVerCode,tfBeginStation,tfEndStation;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"登录";
    
    [self doInit];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionButtonClicked:(id)sender {
    
    [self.view endEditing:YES];
    
    NSString* verCode = tfVerCode.text;
    NSString* account = tfAccount.text;
    NSString* password = tfPassword.text;
    
    [self doLogin:verCode account:account password:password];
    
    
}

- (IBAction)actionRefreshVerCode:(id)sender {
    
    [self getVerCode];
    
}



- (IBAction)actionSelectStation:(id)sender {
    
    [self.view endEditing:YES];
    
    int tag = [sender tag];
    
    NSString* identifier = nil;
    
    if (tag==101) {
        
        identifier = @"beginStation";
        
    }else if(tag==102){
        
        identifier = @"endStation";
        
    }
    
    StationTableViewController* vc = [[StationTableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    [vc setDelegate:self];
    [vc setStationType:identifier];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)actionQueryTrain:(id)sender {
    
    [self.view endEditing:YES];
    
    TrainTableViewController* vc = [[TrainTableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    [self.navigationController pushViewController:vc animated:YES];

    
}

//初始化获取session
- (void)doInit{
    
    NSString* urlString = @"https://kyfw.12306.cn/otn/login/init";
    
    [AFUtil doGet:urlString parameters:nil responseSerializer:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success--->");
        
        NSDictionary *headers = operation.response.allHeaderFields;
        
        NSLog(@"Headers:%@",headers);
        
        [SharedInstance addCookieFromInitResponse:[headers objectForKey:@"Set-Cookie"]];
        
        [self getVerCode];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

//获取图形验证码
- (void)getVerCode{
    
    NSLog(@"getVerCode -->");
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSString* JSessionid = [[[SharedInstance sharedInstance] cookies] objectForKey:@"JSESSIONID"];
    
    NSString *urlString = [NSString stringWithFormat:@"https://kyfw.12306.cn/otn/passcodeNew/getPassCodeNew;jsessionid=%@?module=login&rand=sjrand",JSessionid];
    
    [AFUtil doGet:urlString parameters:nil responseSerializer:[AFImageResponseSerializer serializer] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success--->");
        
        NSDictionary *headers = operation.response.allHeaderFields;
        
        NSLog(@"Headers:%@",headers);
        
        [imageVerCode setImage:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)doLogin:(NSString *)verCode account:(NSString *)account password:(NSString *)password{
    
    NSLog(@"doLogin -->");
    
    NSString* urlString = @"https://kyfw.12306.cn/otn/login/loginAysnSuggest";
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithCapacity:4];
    
    [parameters setObject:verCode forKey:@"randCode"];
    [parameters setObject:account forKey:@"loginUserDTO.user_name"];
    [parameters setObject:password forKey:@"userDTO.password"];
    
    [AFUtil doPost:urlString parameters:parameters responseSerializer:[AFJSONResponseSerializer serializer] success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSLog(@"doLogin Success--->");
        
        NSDictionary *headers = operation.response.allHeaderFields;
        
        NSLog(@"Headers:%@",headers);
        
        NSLog(@"responseString:%@",operation.responseString);
        
        NSLog(@"responseObject:%@",responseObject);
        
        NSString* data = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"loginCheck"]];
        
        NSLog(@"data:%@",data);
        
        NSString* messages = @"";
        
        @try {
            messages = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"messages"] objectAtIndex:0]];
        }
        @catch (NSException *exception) {}
        @finally {}
        
        [SharedInstance setLoginFlag:YES];
        
        messages = [SharedInstance isLogin]?@"登录成功":messages;
        
        NSLog(@"messages:%@",messages);
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"登录结果" message:messages delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
        
        if ([SharedInstance isLogin]) {
            
        }else{
            [self getVerCode];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self doInit];
    }];
    
}

- (void)didSelectedStation:(Station *)station stationType:(NSString *)stationType{
    
    NSLog(@"%@ ---> %@",stationType,station);
    
    if ([@"beginStation" isEqualToString:stationType]) {
        
        [tfBeginStation setText:station.sZHName];
        
        [SharedInstance sharedInstance].beginStation = station;
        
    }else if ([@"endStation" isEqualToString:stationType]){
        
        [tfEndStation setText:station.sZHName];
        
        [SharedInstance sharedInstance].endStation = station;
        
    }
    
}

@end
