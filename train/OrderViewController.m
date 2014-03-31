//
//  OrderViewController.m
//  train
//
//  Created by wanghaijun on 14-3-30.
//  Copyright (c) 2014年 ___NAVY___. All rights reserved.
//

#import "OrderViewController.h"

@interface OrderViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tfTrainCode;
@property (weak, nonatomic) IBOutlet UITextField *tfStartTrainDate;
@property (weak, nonatomic) IBOutlet UITextField *tfFromStation;
@property (weak, nonatomic) IBOutlet UITextField *tfToStation;
@property (weak, nonatomic) IBOutlet UITextField *tfStartTime;
@property (weak, nonatomic) IBOutlet UITextField *tfArriveTime;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segTrainGao;
- (IBAction)actionTrainSelectedGao:(id)sender;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segTrainNomal;
- (IBAction)actionTrainSelectedNomal:(id)sender;


@property (weak, nonatomic) IBOutlet UITextField *tfPassengerName;
@property (weak, nonatomic) IBOutlet UITextField *tfIdTypeName;
@property (weak, nonatomic) IBOutlet UITextField *tfIdTypeNo;
@property (weak, nonatomic) IBOutlet UITextField *tfMobileNo;

@property (weak, nonatomic) IBOutlet UITextField *tfVerCode;

@property (weak, nonatomic) IBOutlet UIImageView *imageVerCode;


@property (nonatomic,strong) NSString* repeatSubmitToken;

- (IBAction)actionAddPassenger:(id)sender;

- (IBAction)actionPreOrder:(id)sender;

- (IBAction)actionRefreshVercode:(id)sender;


@end

@implementation OrderViewController

@synthesize passInfo,trainInfo,repeatSubmitToken;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"车票预定";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:(UIBarButtonItemStylePlain) target:self action:@selector(confirmPreOrder)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
#pragma mark - 初始化车次显示数据
    
    self.tfTrainCode.text = self.trainInfo.t_station_train_code;
    
    self.tfStartTrainDate.text = self.trainInfo.t_start_train_date;
    
    self.tfFromStation.text = self.trainInfo.t_from_station_name;
    
    self.tfToStation.text = self.trainInfo.t_to_station_name;
    
    self.tfStartTime.text = self.trainInfo.t_start_time;
    
    self.tfArriveTime.text = self.trainInfo.t_arrive_time;

#pragma mark - 初始化座位显示数据
    
    NSString *title = nil;
    
    title = [NSString stringWithFormat:@"特等 %@",self.trainInfo.t_tz_num];
    [self.segTrainGao setTitle:title forSegmentAtIndex:0];
    
    title = [NSString stringWithFormat:@"一等 %@",self.trainInfo.t_zy_num];
    [self.segTrainGao setTitle:title forSegmentAtIndex:1];
    
    title = [NSString stringWithFormat:@"二等 %@",self.trainInfo.t_ze_num];
    [self.segTrainGao setTitle:title forSegmentAtIndex:2];
    
    title = [NSString stringWithFormat:@"无座 %@",self.trainInfo.t_wz_num];
    [self.segTrainGao setTitle:title forSegmentAtIndex:3];
    
    
    title = [NSString stringWithFormat:@"软卧 %@",self.trainInfo.t_rw_num];
    [self.segTrainNomal setTitle:title forSegmentAtIndex:0];
    
    title = [NSString stringWithFormat:@"硬卧 %@",self.trainInfo.t_yw_num];
    [self.segTrainNomal setTitle:title forSegmentAtIndex:1];
    
    title = [NSString stringWithFormat:@"软座 %@",self.trainInfo.t_rz_num];
    [self.segTrainNomal setTitle:title forSegmentAtIndex:2];
    
    title = [NSString stringWithFormat:@"硬座 %@",self.trainInfo.t_yz_num];
    [self.segTrainNomal setTitle:title forSegmentAtIndex:3];
    
    //初始化手势监听，用于点击关闭键盘
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionEndEditing)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    [self reqGetVerCode];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)confirmPreOrder{
    
//    OrderViewController *orderVC = [[OrderViewController alloc] init];
//    
//    orderVC.trainInfo = self.train;
//    
//    [self.navigationController pushViewController:orderVC animated:YES];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)actionEndEditing{
    
    [self.view endEditing:YES];
    
}

- (IBAction)actionAddPassenger:(id)sender {
    
    PassengerTableViewController* ptvc = [[PassengerTableViewController alloc] init];
    
    ptvc.delegate = self;
    
    [self.navigationController pushViewController:ptvc animated:YES];
    
}

- (IBAction)actionRefreshVercode:(id)sender {
    
    [self reqGetVerCode];
    
}

- (IBAction)actionPreOrder:(id)sender {
    
    [SVProgressHUD showWithMaskType:(SVProgressHUDMaskTypeGradient)];
    
    [self reqCheckUser];
    
}

- (IBAction)actionTrainSelectedGao:(id)sender {
    
    [self.segTrainNomal setSelectedSegmentIndex:-1];
    
    int index = self.segTrainNomal.selectedSegmentIndex;
    
}
- (IBAction)actionTrainSelectedNomal:(id)sender {
    
    [self.segTrainGao setSelectedSegmentIndex:-1];
    
    int index = self.segTrainNomal.selectedSegmentIndex;
    
}

- (void)didSelectedPassenger:(PassengerInfo *)passenger{
    
    self.passInfo  = passenger;
    
    self.tfPassengerName.text = self.passInfo.p_passenger_name;
    
    self.tfIdTypeName.text = self.passInfo.p_passenger_id_type_name;
    
    self.tfIdTypeNo.text = self.passInfo.p_passenger_id_no;
    
    self.tfMobileNo.text = self.passInfo.p_mobile_no;
}


#pragma mark - 网络请求：获取图形验证码

- (void)reqGetVerCode{
    
    NSLog(@"reqGetVerCode -->");
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSString *urlString = [NSString stringWithFormat:@"https://kyfw.12306.cn/otn/passcodeNew/getPassCodeNew?module=passenger&rand=randp"];
    
    [AFUtil doGet:urlString parameters:nil responseSerializer:[AFImageResponseSerializer serializer] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Success--->");
        
        NSDictionary *headers = operation.response.allHeaderFields;
        
        NSLog(@"Headers:%@",headers);
        
        NSLog(@"responseString:%@",operation.responseString);
        
        [self.imageVerCode setImage:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


#pragma mark - 网络请求：用户登录校验

- (void)reqCheckUser{
    
    NSLog(@"reqCheckUser -->");
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSString *urlString = [NSString stringWithFormat:@"https://kyfw.12306.cn/otn/login/checkUser"];
    
    [AFUtil doGet:urlString parameters:nil responseSerializer:[AFJSONResponseSerializer serializer] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Success--1-->");
        
        NSDictionary *headers = operation.response.allHeaderFields;
        
        NSLog(@"Headers:%@",headers);
        
        NSLog(@"responseString:%@",operation.responseString);
        
        Boolean flag = (int)[[responseObject objectForKey:@"data"] objectForKey:@"flag"];
        
        if (flag) {
            
            [self reqInitWc];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:@"用户登录校验失败"];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"用户登录校验失败"];
        
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - 网络请求：提交订单
#warning 未通过

- (void)reqSubmitOrderRequest{
    
    NSLog(@"reqSubmitOrderRequest --2-->");
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSString *urlString = [NSString stringWithFormat:@"https://kyfw.12306.cn/otn/leftTicket/submitOrderRequest"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:8];
    
    [dic setObject:self.trainInfo.t_secretStr forKey:@"secretStr"];
    [dic setObject:[SharedInstance sharedInstance].trainDateString forKey:@"train_date"];
    [dic setObject:[SharedInstance sharedInstance].trainDateString forKey:@"back_train_date"];
    
    [dic setObject:self.trainInfo.t_from_station_name forKey:@"query_from_station_name"];
    [dic setObject:self.trainInfo.t_to_station_name  forKey:@"query_to_station_name"];
    
    [dic setObject:@"wc" forKey:@"tour_flag"];
    [dic setObject:@"ADULT" forKey:@"purpose_codes"];
    [dic setObject:@"" forKey:@"undefined"];
    
    NSLog(@"parameters:%@",dic);
    
    [AFUtil doGet:urlString parameters:dic responseSerializer:[AFJSONResponseSerializer serializer] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Success--->");
        
        NSDictionary *headers = operation.response.allHeaderFields;
        
        NSLog(@"Headers:%@",headers);
        
        NSLog(@"responseString:%@",operation.responseString);
        
        Boolean flag = (int)[responseObject objectForKey:@"status"];
        
        if (flag) {
            
            [SVProgressHUD showSuccessWithStatus:@"提交订单成功"];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:@"提交订单失败"];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"提交订单失败"];
        
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - 网络请求：提交订单

- (void)reqInitWc{
    
    NSLog(@"reqSubmitOrderRequest --2-->");
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSString *urlString = [NSString stringWithFormat:@"https://kyfw.12306.cn/otn/confirmPassenger/initWc"];
    
    [AFUtil doGet:urlString parameters:nil responseSerializer:[AFHTTPResponseSerializer serializer] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Success--->");
        
        NSDictionary *headers = operation.response.allHeaderFields;
        
        NSLog(@"Headers:%@",headers);
        
        NSLog(@"responseString:%@",operation.responseString);
        
        [SVProgressHUD dismiss];
        
        NSRange range = [operation.responseString rangeOfString:@"globalRepeatSubmitToken = '"];
        range.length = 60;
        
        NSString* globalRepeatSubmitToken = [operation.responseString substringWithRange:range];
        
        NSLog(@"globalRepeatSubmitToken:%@",globalRepeatSubmitToken);
        
        self.repeatSubmitToken = [globalRepeatSubmitToken stringByReplacingOccurrencesOfString:@"globalRepeatSubmitToken = '" withString:@""];
        
        self.repeatSubmitToken = [self.repeatSubmitToken stringByReplacingOccurrencesOfString:@"'" withString:@""];
        
        NSLog(@"repeatSubmitToken:%@",self.repeatSubmitToken);
        
        if (self.repeatSubmitToken) {
            
            [SVProgressHUD showSuccessWithStatus:@"提交订单成功"];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:@"提交订单失败"];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"提交订单失败"];
        
        NSLog(@"Error: %@", error);
    }];
}

- (void)reqCheckOrderInfo{
    
    NSLog(@"reqCheckOrderInfo --3-->");
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSString *urlString = [NSString stringWithFormat:@"https://kyfw.12306.cn/otn/confirmPassenger/checkOrderInfo"];
    
    NSString *oldPassengerStr = [NSString stringWithFormat:@"%@,%@,%@,%@_",self.passInfo.p_passenger_name,self.passInfo.p_passenger_id_type_code,self.passInfo.p_passenger_id_no,self.passInfo.p_passenger_type];
    
    NSMutableString *ptMStr = [NSMutableString string];
    
    
    
    /**
     
     SeatType-->
     
     O:100,二等座
     M:99,一等座
     "3":98,硬卧
     "1":97,硬座
     "2":96,
     "4":95,软卧
     "7":94,
     "8":93,
     "9":92,商务
     P:91,特等
     "6":90,高级软卧
     A:89,
     H:88
     
     String oldStrs = "";
     
     for(int i=0;i<userInfo.size();i++)
     {
     String oldStr = "";
     if("WZ"==userInfo.get(i).getSeatType())
     {}
     else{
     oldStr=userInfo.get(i).getSeatType();
     }
     String bR = oldStr 
     + ",0,"
     +userInfo.get(i).getTickType()
     +","
     +userInfo.get(i).getName()
     +","
     +userInfo.get(i).getCardType()
     +","
     +userInfo.get(i).getCardID()
     +","
     +(userInfo.get(i).getPhone()==null?"":userInfo.get(i).getPhone())
     +",N";
     oldStrs+=bR+"_";
     }
     
     return oldStrs.substring(0,oldStrs.length()-1);
     
     **/
    
    [AFUtil doGet:urlString parameters:nil responseSerializer:[AFHTTPResponseSerializer serializer] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Success--->");
        
        NSDictionary *headers = operation.response.allHeaderFields;
        
        NSLog(@"Headers:%@",headers);
        
        NSLog(@"responseString:%@",operation.responseString);
        
        [SVProgressHUD dismiss];
        
        NSRange range = [operation.responseString rangeOfString:@"globalRepeatSubmitToken = '"];
        range.length = 60;
        
        NSString* globalRepeatSubmitToken = [operation.responseString substringWithRange:range];
        
        NSLog(@"globalRepeatSubmitToken:%@",globalRepeatSubmitToken);
        
        self.repeatSubmitToken = [globalRepeatSubmitToken stringByReplacingOccurrencesOfString:@"globalRepeatSubmitToken = '" withString:@""];
        
        self.repeatSubmitToken = [self.repeatSubmitToken stringByReplacingOccurrencesOfString:@"'" withString:@""];
        
        NSLog(@"repeatSubmitToken:%@",self.repeatSubmitToken);
        
        if (self.repeatSubmitToken) {
            
            [SVProgressHUD showSuccessWithStatus:@"提交订单成功"];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:@"提交订单失败"];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"提交订单失败"];
        
        NSLog(@"Error: %@", error);
    }];
    
}

@end
