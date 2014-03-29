//
//  StationTableViewTableViewController.m
//  train
//
//  Created by wanghaijun on 14-3-27.
//  Copyright (c) 2014年 ___NAVY___. All rights reserved.
//

#import "DetailTableViewController.h"
#import "AFUtil.h"
#import "SharedInstance.h"
#import "TrainStationInfo.h"

@interface DetailTableViewController ()

@property (nonatomic,strong) NSMutableArray *trainStations;

@end

@implementation DetailTableViewController

@synthesize train,trainStations;

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
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *train_date = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *from_station = [SharedInstance sharedInstance].beginStation.sNo;
    NSString *to_station = [SharedInstance sharedInstance].endStation.sNo;
    
    NSString *train_no = self.train.t_train_no;
    train_date = @"2014-03-29";
    from_station = @"VNP";
    to_station = @"TYV";
    
    
    NSString* urlString = [NSString stringWithFormat:@"https://kyfw.12306.cn/otn/czxx/queryByTrainNo?train_no=%@&from_station_telecode=%@&to_station_telecode=%@&depart_date=%@",train_no,from_station,to_station,train_date];
    
    /**
     
     {"validateMessagesShowId":"_validatorMessage","status":true,"httpstatus":200,
     
     "data":{
     
     "data":[
     
     {"start_station_name":"北京西","station_train_code":"T69","train_class_name":"特快","service_type":"1","end_station_name":"乌鲁木齐",
     "arrive_time":"----","station_name":"北京","start_time":"10:01","stopover_time":"----","station_no":"01","isEnabled":false},
     
     {"arrive_time":"15:18","station_name":"太原","start_time":"15:27","stopover_time":"9分钟","station_no":"05","isEnabled":false},
     
     {"arrive_time":"20:48","station_name":"乌鲁","start_time":"20:48","stopover_time":"----","station_no":"20","isEnabled":false}]
     
     },"messages":[],"validateMessages":{}}
     
     **/
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    
    [AFUtil doGet:urlString parameters:nil responseSerializer:[AFJSONResponseSerializer serializer] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [SVProgressHUD showSuccessWithStatus:@"车次时刻表获取成功"];
        
        NSLog(@"Success--->");
        
        NSDictionary *headers = operation.response.allHeaderFields;
        
        NSLog(@"Headers:%@",headers);
        
        NSArray* trainStationArray = [[responseObject objectForKey:@"data"]  objectForKey:@"data"];
        
        trainStations = [[NSMutableArray alloc] initWithCapacity:trainStationArray.count];
        
        for (NSDictionary *dic in trainStationArray) {
            
            TrainStationInfo *tsInfo = [[TrainStationInfo alloc] initWithDic:dic];
            
            [trainStations addObject:tsInfo];
            
            NSLog(@"%@",tsInfo);
            
        }
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"车次时刻表获取成功"];
        
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
    return (trainStations != nil) ? trainStations.count : 0;
    
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
    
    TrainStationInfo* tsInfo = [trainStations objectAtIndex:index];
    
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    
    cell.textLabel.text = [tsInfo description];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [cell setSelected:NO];
    
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
