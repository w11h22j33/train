//
//  StationTableViewTableViewController.m
//  train
//
//  Created by wanghaijun on 14-3-27.
//  Copyright (c) 2014年 ___NAVY___. All rights reserved.
//

#import "PassengerTableViewController.h"
#import "AFUtil.h"
#import "SharedInstance.h"
#import "TrainStationInfo.h"

@interface PassengerTableViewController ()

@property (nonatomic,strong) NSMutableArray *passengers;

@end

@implementation PassengerTableViewController

@synthesize passengers,delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"时刻表";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self doPassengerQuery];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//初始化获取session
- (void)doPassengerQuery{
    
    NSString* urlString = [NSString stringWithFormat:@"https://kyfw.12306.cn/otn/confirmPassenger/getPassengerDTOs"];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithCapacity:4];
    
    [parameters setObject:[[[SharedInstance sharedInstance] cookies] objectForKey:@"JSESSIONID"] forKey:@"REPEAT_SUBMIT_TOKEN"];
    
    
    /**
     
     {
     
     "validateMessagesShowId":"_validatorMessage",
     "status":true,
     "httpstatus":200,
     "data":{
     "isExist":true,
     "exMsg":"",
     "two_isOpenClick":["93","95","97","99"],
     "other_isOpenClick":["91","93","98","99","95","97"],
     "normal_passengers":[
     {"code":"3","passenger_name":"王海军","sex_code":"M","sex_name":"男","born_date":"1985-04-23
     00:00:00","country_code":"CN","passenger_id_type_code":"1","passenger_id_type_name":"二代身份证","passenger_id_no":"142401198504235856","passenger_type":"1","passenger_flag
     ":"0","passenger_type_name":"成人","mobile_no":"18618185814","phone_no":"","email":"w11h22j33@163.com","address":"","postalcode":"","first_letter":"W11H22J33","recordCount"
     :"3","total_times":"99","index_id":"0"},
     {"code":"2","passenger_name":"王世院","sex_code":"M","sex_name":"男","born_date":"1900-01-01
     00:00:00","country_code":"CN","passenger_id_type_code":"1","passenger_id_type_name":"二代身份证","passenger_id_no":"131124198509290411","passenger_type":"1","passenger_flag
     ":"0","passenger_type_name":"成人","mobile_no":"13810302504","phone_no":"","email":"","address":"","postalcode":"","first_letter":"WSY","recordCount":"3","total_times":"99"
     ,"index_id":"1"},
     {"code":"1",
     "passenger_name":"朱媛",
     "sex_code":"F",
     "sex_name":"女",
     "born_date":"1984-01-14 00:00:00",
     "country_code":"CN",
     "passenger_id_type_code":"1",
     "passenger_id_type_name":"二代身份证",
     "passenger_id_no":"37250119840114604X",
     "passenger_type":"1",
     "passenger_flag":"0",
     "passenger_type_name":"成人",
     "mobile_no":"18618268346",
     "phone_no":"",
     "email":"navy.zy@gmail.com",
     "address":"",
     "postalcode":"",
     "first_letter":"ZY",
     "recordCount":"3",
     "total_times":"99",
     "index_id":"2"}
     ],
     "dj_passengers":[]
     },
     "messages":[],
     "validateMessages":{}
     
     }
     
     **/
    
    [AFUtil doGet:urlString parameters:nil responseSerializer:[AFJSONResponseSerializer serializer] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Success--->");
        
        NSDictionary *headers = operation.response.allHeaderFields;
        
        NSLog(@"Headers:%@",headers);
        
        NSLog(@"responseString:%@",operation.responseString);
        
        NSArray* passengersArray = [[responseObject objectForKey:@"data"]  objectForKey:@"normal_passengers"];

        NSLog(@"passengers:%@",passengers);
        
        if (passengersArray && [passengersArray isKindOfClass:[NSArray class]]) {
            
            [SVProgressHUD showSuccessWithStatus:@"联系人列表获取成功"];
            
            passengers = [[NSMutableArray alloc] initWithCapacity:passengersArray.count];
            
            for (NSDictionary *dic in passengersArray) {
                
                PassengerInfo *passInfo = [[PassengerInfo alloc] initWithDic:dic];
                
                [passengers addObject:passInfo];
                
                NSLog(@"%@",passengers);
                
            }
            
            [self.tableView reloadData];
        }else{
            
            NSString* exMsg = [[responseObject objectForKey:@"data"]  objectForKey:@"exMsg"];
            
            [SVProgressHUD showSuccessWithStatus:exMsg];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"联系人表获取失败"];
        
        NSLog(@"Error: %@", error);
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return (passengers != nil) ? passengers.count : 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"reuseIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    int index = indexPath.row;
    
    PassengerInfo* passInfo = [passengers objectAtIndex:index];
    
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    
    cell.textLabel.text = [passInfo description];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [cell setSelected:NO];
    
    int index = indexPath.row;
    
    PassengerInfo* passInfo = [passengers objectAtIndex:index];
    
    if (self.delegate) {
        [self.delegate didSelectedPassenger:passInfo];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
