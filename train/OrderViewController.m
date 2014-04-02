//
//  OrderViewController.m
//  train
//
//  Created by wanghaijun on 14-3-30.
//  Copyright (c) 2014年 ___NAVY___. All rights reserved.
//

#import "OrderViewController.h"

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
 
 **/

#define SEAT_TYPE_ZE @"O"
#define SEAT_TYPE_ZY @"M"
#define SEAT_TYPE_YW @"3"
#define SEAT_TYPE_YZ @"1"
#define SEAT_TYPE_RW @"4"
#define SEAT_TYPE_SW @"9"
#define SEAT_TYPE_TZ @"P"
#define SEAT_TYPE_GR @"6"

#define SEAT_TYPE_RZ @"2"
#define SEAT_TYPE_WZ @"1"

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

- (IBAction)actionAddPassenger:(id)sender;

- (IBAction)actionPreOrder:(id)sender;

- (IBAction)actionRefreshVercode:(id)sender;



@property (nonatomic,strong) NSString* repeatSubmitToken;
@property (nonatomic,strong) NSString* selectedSeatType;


@end

@implementation OrderViewController

@synthesize passInfo,trainInfo,repeatSubmitToken,selectedSeatType;

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
    
    int index = self.segTrainGao.selectedSegmentIndex;
    
    NSArray *array = @[SEAT_TYPE_TZ,SEAT_TYPE_ZY,SEAT_TYPE_ZE,SEAT_TYPE_WZ];
    
    selectedSeatType = [array objectAtIndex:index];
    
}

- (IBAction)actionTrainSelectedNomal:(id)sender {
    
    [self.segTrainGao setSelectedSegmentIndex:-1];
    
    int index = self.segTrainNomal.selectedSegmentIndex;
    
    NSArray *array = @[SEAT_TYPE_RW,SEAT_TYPE_YW,SEAT_TYPE_RZ,SEAT_TYPE_YZ];
    
    selectedSeatType = [array objectAtIndex:index];
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
    
    NSString *urlString = [NSString stringWithFormat:@"https://kyfw.12306.cn/otn/login/checkUser"];
    
    [AFUtil doGet:urlString parameters:nil responseSerializer:[AFJSONResponseSerializer serializer] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Success--1-->");
        
        NSDictionary *headers = operation.response.allHeaderFields;
        
        NSLog(@"Headers:%@",headers);
        
        NSLog(@"responseString:%@",operation.responseString);
        
        Boolean flag = (int)[[responseObject objectForKey:@"data"] objectForKey:@"flag"];
        
        if (flag) {
            
            [self reqSubmitOrderRequest];
//            [self reqInitWc];
            
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
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:8];
    
    [SharedInstance addCookie:@"2014-04-01" forKey:@"_jc_save_fromDate"];
    [SharedInstance addCookie:@"北京,BJP" forKey:@"_jc_save_fromStation"];
    [SharedInstance addCookie:@"2014-04-01" forKey:@"_jc_save_toDate"];
    [SharedInstance addCookie:@"太原,TYV" forKey:@"_jc_save_toStation"];
    [SharedInstance addCookie:@"wf" forKey:@"_jc_save_wfdc_flag"];
    
    /**
     
     _jc_save_fromDate	Sent	2014-04-01
     _jc_save_fromStation	Sent	北京,BJP     
     _jc_save_toDate	Sent	2014-04-01     
     _jc_save_toStation	Sent	太原,TYV	     
     _jc_save_wfdc_flag	Sent	wf
     BIGipServerotn	1540948234.38945.0000
     JSESSIONID	4FED3F7C3A0A1806F963D16544C62346
     
     **/
    
    [dic setObject:self.trainInfo.t_secretStr forKey:@"secretStr"];
    [dic setObject:[SharedInstance sharedInstance].trainDateString forKey:@"train_date"];
    [dic setObject:[SharedInstance sharedInstance].trainDateString forKey:@"back_train_date"];
    
    [dic setObject:self.trainInfo.t_from_station_name forKey:@"query_from_station_name"];
    [dic setObject:self.trainInfo.t_to_station_name  forKey:@"query_to_station_name"];
    
    [dic setObject:@"wc" forKey:@"tour_flag"];
    [dic setObject:@"ADULT" forKey:@"purpose_codes"];
    [dic setObject:@"" forKey:@"undefined"];
    
    NSLog(@"parameters:%@",dic);
    
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"https://kyfw.12306.cn/otn/leftTicket/submitOrderRequest?secretStr=%@&train_date=%@&back_train_date=%@&tour_flag=dc&purpose_codes=ADULT&query_from_station_name=%@&query_to_station_name=%@",[dic objectForKey:@"secretStr"],[dic objectForKey:@"train_date"],[dic objectForKey:@"back_train_date"],[dic objectForKey:@"query_from_station_name"],[dic objectForKey:@"query_to_station_name"]];
    
    [AFUtil doGet:urlString parameters:nil responseSerializer:[AFJSONResponseSerializer serializer] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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

#pragma mark - 网络请求：获取订单Token

- (void)reqInitWc{
    
    NSLog(@"reqSubmitOrderRequest --2-->");
    
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
            
            [self reqCheckOrderInfo];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:@"获取订单Token失败"];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"获取订单Token失败"];
        
        NSLog(@"Error: %@", error);
    }];
}

- (void)reqCheckOrderInfo{
    
    NSLog(@"reqCheckOrderInfo --3-->");
    
    NSString *urlString = [NSString stringWithFormat:@"https://kyfw.12306.cn/otn/confirmPassenger/checkOrderInfo"];
    
    NSString *oldPassengerStr = [NSString stringWithFormat:@"%@,%@,%@,%@_",self.passInfo.p_passenger_name,self.passInfo.p_passenger_id_type_code,self.passInfo.p_passenger_id_no,self.passInfo.p_passenger_type];
    
    NSMutableString *ptMStr = [NSMutableString string];
    
    [ptMStr appendString:self.selectedSeatType];
    [ptMStr appendString:@",0,"];
    
    [ptMStr appendString:passInfo.p_passenger_type];
    [ptMStr appendString:@","];
    
    [ptMStr appendString:[NSString stringWithFormat:@"%@,%@,%@,%@,N",self.passInfo.p_passenger_name,self.passInfo.p_passenger_id_type_code,self.passInfo.p_passenger_id_no,self.passInfo.p_mobile_no]];
    
    NSString *passengerTicketStr = ptMStr;
    
    NSString *randCode = [self.tfVerCode text];
    
    NSString *bed_level_order_num = @"000000000000000000000000000000";
    
    NSString *REPEAT_SUBMIT_TOKEN = self.repeatSubmitToken;
    
    NSString *tour_flag = @"dc";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:8];
    
    [parameters setObject:bed_level_order_num forKey:@"bed_level_order_num"];
    [parameters setObject:@"2" forKey:@"cancel_flag"];
    [parameters setObject:oldPassengerStr forKey:@"oldPassengerStr"];
    [parameters setObject:passengerTicketStr forKey:@"passengerTicketStr"];
    [parameters setObject:randCode forKey:@"randCode"];
    [parameters setObject:REPEAT_SUBMIT_TOKEN forKey:@"REPEAT_SUBMIT_TOKEN"];
    [parameters setObject:tour_flag forKey:@"tour_flag"];
    
    NSLog(@"parameters:%@",parameters);
    
    /**
     
     cancel_flag=2&bed_level_order_num=000000000000000000000000000000&passengerTicketStr=3%2C0%2C1%2C%E7%8E%8B%E6%B5%B7%E5%86%9B%2C1%2C142401198504235856%2C18618185814%2CN&oldPassengerStr=%E7%8E%8B%E6%B5%B7%E5%86%9B%2C1%2C142401198504235856%2C1_&tour_flag=dc&randCode=t3d2&_json_att=&REPEAT_SUBMIT_TOKEN=04944a2ee32873cac89495d7ff8d7935
     
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
    
    [AFUtil doPost:urlString parameters:parameters responseSerializer:[AFJSONResponseSerializer serializer] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Success--->");
        
        NSDictionary *headers = operation.response.allHeaderFields;
        
        NSLog(@"Headers:%@",headers);
        
        NSLog(@"responseString:%@",operation.responseString);
        
        [SVProgressHUD dismiss];
        
        BOOL submitStatus = (int)[[responseObject objectForKey:@"data"] objectForKey:@"submitStatus"];
        
        if (submitStatus) {
            
            [SVProgressHUD showSuccessWithStatus:@"校验订单成功"];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:@"校验订单失败"];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"校验订单失败"];
        
        NSLog(@"Error: %@", error);
    }];
    
}

@end
