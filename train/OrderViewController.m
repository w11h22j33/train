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

- (IBAction)actionAddPassenger:(id)sender;

- (IBAction)actionPreOrder:(id)sender;



@end

@implementation OrderViewController

@synthesize passInfo,trainInfo;

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

- (IBAction)actionAddPassenger:(id)sender {
    
    PassengerTableViewController* ptvc = [[PassengerTableViewController alloc] init];
    
    ptvc.delegate = self;
    
    [self.navigationController pushViewController:ptvc animated:YES];
    
}

- (IBAction)actionPreOrder:(id)sender {
    
    

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
    
    self.tfIdTypeNo.text = self.passInfo.p_passenger_id_type_code;
    
    self.tfMobileNo.text = self.passInfo.p_mobile_no;
}

@end
