//
//  ViewController.m
//  CocoapodsDemo
//
//  Created by wanghaijun on 14-3-7.
//  Copyright (c) 2014年 ___NAVY___. All rights reserved.
//

#import "ViewController.h"
#import <UIImageView+AFNetworking.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tfAccount;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UITextField *tfVerCode;
@property (weak, nonatomic) IBOutlet UITextField *tfBeginStation;
@property (weak, nonatomic) IBOutlet UITextField *tfEndStation;

@property (weak, nonatomic) IBOutlet UIImageView *imageVerCode;
@property (weak, nonatomic) IBOutlet UIDatePicker *pickerDate;

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

@synthesize tfAccount,tfPassword,imageVerCode,sharedInstance,tfVerCode,tfBeginStation,tfEndStation,pickerDate;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"登录";
    
    
    [self.tfBeginStation setEnabled:NO];
    
    [self.tfEndStation setEnabled:NO];
    
    [self doInit];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString* account = [userDefaults objectForKey:KEY_ACCOUNT];
    NSString* password = [userDefaults objectForKey:KEY_PASSWORD];
    
    if (account) {
        self.tfAccount.text = account;
    }
    
    if (password) {
        self.tfPassword.text = password;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 按钮事件-登录

- (IBAction)actionButtonClicked:(id)sender {
    
    [self.view endEditing:YES];
    
    NSString* verCode = tfVerCode.text;
    
    [self doCheckVercode:verCode];
    
    
}

#pragma mark - 按钮事件-刷新图形验证码

- (IBAction)actionRefreshVerCode:(id)sender {
    
    [self getVerCode];
    
}

#pragma mark - 按钮事件-跳转车站选择页面

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

#pragma mark - 按钮事件-跳转车次查询页面

- (IBAction)actionQueryTrain:(id)sender {
    
    [self.view endEditing:YES];
    
    TrainTableViewController* vc = [[TrainTableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    NSDate *select = [self.pickerDate date]; // 获取被选中的时间
    NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
    selectDateFormatter.dateFormat = @"yyyy-MM-dd"; // 设置时间和日期的格式
    NSString *dateAndTime = [selectDateFormatter stringFromDate:select]; // 把date类型转为设置好格式的string类型
    
    vc.train_date = dateAndTime;
    
    [SharedInstance sharedInstance].trainDateString = dateAndTime;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 初始化获取session

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

#pragma mark - 网络请求：获取图形验证码

- (void)getVerCode{
    
    NSLog(@"getVerCode -->");
    
    NSString* JSessionid = [SharedInstance getCookieForKey:@"JSESSIONID"];
    
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

#pragma mark - 网络请求：单独校验验证码

- (void)doCheckVercode:(NSString *)verCode{
    
    [SVProgressHUD showWithMaskType:(SVProgressHUDMaskTypeGradient)];
    
    NSLog(@"doCheckVercode -->");
    
    NSString* urlString = @"https://kyfw.12306.cn/otn/passcodeNew/checkRandCodeAnsyn";
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [parameters setObject:verCode forKey:@"randCode"];
    
    [AFUtil doPost:urlString parameters:parameters responseSerializer:[AFJSONResponseSerializer serializer] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [SVProgressHUD dismiss];
        
        NSLog(@"doLogin Success--->");
        
        NSDictionary *headers = operation.response.allHeaderFields;
        
        NSLog(@"Headers:%@",headers);
        
        NSLog(@"responseString:%@",operation.responseString);
        
        NSLog(@"responseObject:%@",responseObject);
        
        NSString* data = [responseObject objectForKey:@"data"];
        
        if ([@"Y" isEqualToString:data]) {
            
            NSString* verCode = tfVerCode.text;
            NSString* account = tfAccount.text;
            NSString* password = tfPassword.text;
            
            [self doLogin:verCode account:account password:password];
            
        }else{
            [SVProgressHUD showErrorWithStatus:@"验证码输入有误"];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        [SVProgressHUD showErrorWithStatus:@"验证码输入有误"];
        
    }];
    
}



#pragma mark - 网络请求：登录

- (void)doLogin:(NSString *)verCode account:(NSString *)account password:(NSString *)password{
    
    [SVProgressHUD showWithMaskType:(SVProgressHUDMaskTypeGradient)];
    
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
        
        NSObject* data = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"loginCheck"]];
        
        NSLog(@"data:%@",data);
        
        NSString* messages = @"登录成功";
        
        if (data == Nil || [@"(null)" isEqual:data]) {
            
            messages = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"messages"] objectAtIndex:0]];
            
            [SharedInstance setLoginFlag:NO];
            
        }else{
            [SharedInstance setLoginFlag:YES];
            
            NSString* account = tfAccount.text;
            NSString* password = tfPassword.text;
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:account forKey:KEY_ACCOUNT];
            [userDefaults setObject:password forKey:KEY_PASSWORD];
            [userDefaults synchronize];
            
        }
        
        [SVProgressHUD showSuccessWithStatus:messages];
        
        NSLog(@"messages:%@",messages);
        
        if ([SharedInstance isLogin]) {
            
            PassengerTableViewController* ptvc = [[PassengerTableViewController alloc] init];
            
            [self.navigationController pushViewController:ptvc animated:YES];
            
            [self doLoginConfirm];
            
        }else{
            [self getVerCode];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        [SVProgressHUD showErrorWithStatus:@"登录失败"];
        
        [self doInit];
    }];
    
}

- (void)doLoginConfirm{
    
    NSLog(@"doLoginConfirm -->");
    
    NSString* urlString = @"https://kyfw.12306.cn/otn/login/userLogin";
    
    [AFUtil doPost:urlString parameters:nil responseSerializer:[AFHTTPResponseSerializer serializer] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"doLoginConfirm Success--->");
        
        NSDictionary *headers = operation.response.allHeaderFields;
        
        NSLog(@"Headers:%@",headers);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
    }];
    
}


#pragma mark - 选择车站回调方法

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
