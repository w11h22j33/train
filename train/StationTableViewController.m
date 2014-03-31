//
//  StationTableViewTableViewController.m
//  train
//
//  Created by wanghaijun on 14-3-27.
//  Copyright (c) 2014年 ___NAVY___. All rights reserved.
//

#import "StationTableViewController.h"


@interface StationTableViewController ()<ADBIndexedTableViewDataSource>

@end

@implementation StationTableViewController
@synthesize stationType,delegate;

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
    
    self.navigationItem.title = @"车站列表";
    
    CGRect rect = [[[UIApplication sharedApplication] keyWindow] frame];
    
    self.tableView = [[ADBIndexedTableView alloc] initWithFrame:rect style:(UITableViewStylePlain)];
    
    [self.tableView setDataSource:(id<UITableViewDataSource>)self.tableView];
    [self.tableView setDelegate:self];
    [(ADBIndexedTableView*)self.tableView setIndexDataSource:self];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSMutableArray* stations = [SharedInstance sharedInstance].stations;
    
    if (stations && stations.count > 1) {
        
        [(ADBIndexedTableView*)self.tableView reloadDataWithObjects:stations];
        
        [self.tableView reloadData];
        
    }else{
        
        [self doLoadStation];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//初始化获取session
- (void)doLoadStation{
    
    NSString* urlString = @"https://kyfw.12306.cn/otn/resources/js/framework/station_name.js";
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    
    [AFUtil doGet:urlString parameters:nil responseSerializer:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [SVProgressHUD showSuccessWithStatus:@"车站列表获取成功"];
        
        NSLog(@"Success--->");
        
        NSDictionary *headers = operation.response.allHeaderFields;
        
        NSLog(@"Headers:%@",headers);
        
        [SharedInstance initStations:operation.responseString];
        
        NSMutableArray *stations = [SharedInstance sharedInstance].stations;
        
        [(ADBIndexedTableView*)self.tableView reloadDataWithObjects:stations];
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD dismiss];
        
        [SVProgressHUD showErrorWithStatus:@"车站列表获取失败"];
        
        NSLog(@"Error: %@", error);
    }];
    
}

#pragma mark - Table view data source

- (NSString *)objectsFieldForIndexedTableView:(ADBIndexedTableView *)tableView{
    
    return @"index0";
    
}

- (UITableViewCell *)indexedTableView:(ADBIndexedTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath usingObject:(id)object{
    
    static NSString *CellIdentifier = @"reuseIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Station *station = [[(ADBIndexedTableView*)tableView objectAtIndexPath:indexPath] objectForKey:@"object"];
    
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    
    cell.textLabel.text = [station description];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    Station *station = [[(ADBIndexedTableView*)tableView objectAtIndexPath:indexPath] objectForKey:@"object"];
    
    NSLog(@"%@",station);
    
    [cell setSelected:NO];
    
    [self.delegate didSelectedStation:station stationType:self.stationType];
    
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
