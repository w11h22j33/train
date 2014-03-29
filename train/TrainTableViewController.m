//
//  StationTableViewTableViewController.m
//  train
//
//  Created by wanghaijun on 14-3-27.
//  Copyright (c) 2014年 ___NAVY___. All rights reserved.
//

#import "TrainTableViewController.h"
#import "AFUtil.h"
#import "SharedInstance.h"
#import "DetailTableViewController.h"

@interface TrainTableViewController ()

@property (nonatomic,strong) NSMutableArray *trains;

@end

@implementation TrainTableViewController

@synthesize trains,train_date;

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
    
    self.navigationItem.title = @"车次列表";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    Station* beginStation = [SharedInstance sharedInstance].beginStation;
    Station* endStation = [SharedInstance sharedInstance].endStation;
    
    if (beginStation && endStation) {
        
        NSLog(@"beginStation--->%@",beginStation);
        NSLog(@"endStation--->%@",endStation);
        
        [self doQueryTrain];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//初始化获取session
- (void)doQueryTrain{
    
    NSString *from_station = [SharedInstance sharedInstance].beginStation.sNo;
    NSString *to_station = [SharedInstance sharedInstance].endStation.sNo;
    
    
    NSString* urlString = [NSString stringWithFormat:@"https://kyfw.12306.cn/otn/leftTicket/query?leftTicketDTO.train_date=%@&leftTicketDTO.from_station=%@&leftTicketDTO.to_station=%@&purpose_codes=ADULT",self.train_date,from_station,to_station];
    
    /**
     
     
     {"data":[{"queryLeftNewDTO":{"train_no":"01000K108402","station_train_code":"K1081","start_station_telecode":"HBB","start_station_name":"哈尔滨","end_station_tele c
     ode":"TYV","end_station_name":"太原","from_station_telecode":"BJP","from_station_name":"北京","to_station_telecode":"TYV","to_station_name":"太原","start_time":"0 2
     :33","arrive_time":"10:49","day_difference":"0","train_class_name":"","lishi":"08:16","canWebBuy":"IS_TIME_NOT_BUY","lishiValue":"496","yp_info":"1009103191402530 0
     01110091001093016400073","control_train_day":"20201231","start_train_date":"20140327","seat_feature":"W3431333","yp_ex":"10401030","train_seat_feature":"3","seat_ t
     ypes":"1413","location_code":"B2","from_station_no":"18","to_station_no":"25","control_day":19,"sale_time":"1000","is_support_card":"0","gg_num":"--","gr_num":"-- "
     ,"qt_num":"--","rw_num":"11","rz_num":"--","tz_num":"--","wz_num":"有","yb_num":"--","yw_num":"有","yz_num":"有","ze_num":"--","zy_num":"--","swz_num":"--"},"secr e
     tStr":"","buttonTextInfo":"23:00-07:00系统维护时间"},
     
     
     {"queryLeftNewDTO":{"train_no":"24000D200109","station_train_code":"D2001","start_station_telecode":"BXP","st a
     rt_station_name":"北京西","end_station_telecode":"TYV","end_station_name":"太原","from_station_telecode":"BXP","from_station_name":"北京西","to_station_telecode": "
     TYV","to_station_name":"太原","start_time":"07:10","arrive_time":"10:31","day_difference":"0","train_class_name":"动车","lishi":"03:21","canWebBuy":"IS_TIME_NOT_B U
     Y","lishiValue":"201","yp_info":"O015200455M021700146O015203143","control_train_day":"20201231","start_train_date":"20140328","seat_feature":"O3M3W3","yp_ex":"O0M 0
     O0","train_seat_feature":"3","seat_types":"OMO","location_code":"P2","from_station_no":"01","to_station_no":"06","control_day":19,"sale_time":"1100","is_support_c a
     rd":"0","gg_num":"--","gr_num":"--","qt_num":"--","rw_num":"--","rz_num":"--","tz_num":"--","wz_num":"有","yb_num":"--","yw_num":"--","yz_num":"--","ze_num":"有", "
     zy_num":"有","swz_num":"--"},"secretStr":"","buttonTextInfo":"23:00-07:00系统维护时间"}]}
     
     
     **/
    
    
    
    [AFUtil doGet:urlString parameters:nil responseSerializer:[AFJSONResponseSerializer serializer] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Success--->");
        
        NSDictionary *headers = operation.response.allHeaderFields;
        
        NSLog(@"Headers:%@",headers);
        
        NSArray *array = [responseObject objectForKey:@"data"];
        
        int count = array.count;
        
        trains = [[NSMutableArray alloc] initWithCapacity:count];
        
        for (int index = 0 ; index < count; index++) {
            
            NSDictionary *dic = [[array objectAtIndex:index] objectForKey:@"queryLeftNewDTO"];
            
            TrainInfo *train = [[TrainInfo alloc] initWithDic:dic];
            
            NSLog(@"train:%@",train);
            
            [trains addObject:train];
            
        }
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
    return (trains != nil) ? trains.count : 0;
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
    
    TrainInfo *train = [trains objectAtIndex:index];
    
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    
    cell.textLabel.text = [train description];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [cell setSelected:NO];
    
    DetailTableViewController* detail = [[DetailTableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    detail.train = [trains objectAtIndex:indexPath.row];
    
    NSLog(@"%@",detail.train);
    
    [self.navigationController pushViewController:detail animated:YES];
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
