//
//  ViewController.m
//  CocoapodsDemo
//
//  Created by wanghaijun on 14-3-7.
//  Copyright (c) 2014年 ___NAVY___. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tfAccount;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UIImageView *imageVerCode;

- (IBAction)actionButtonClicked:(id)sender;

- (void)doInit;
- (void)getVerCode;

@end

@implementation ViewController

@synthesize tfAccount,tfPassword,imageVerCode;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionButtonClicked:(id)sender {
    
    NSString* account = tfAccount.text;
    NSString* password = tfPassword.text;
    
    [self doInit];
    
    
}

- (void)doInit{
    
    NSString* urlString = @"https://kyfw.12306.cn/otn/";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Headers:%@",operation.response.allHeaderFields);
        //        NSLog(@"responseString:%@",operation.responseString);
        NSLog(@"StatusCode:%d",operation.response.statusCode);
        NSLog(@"Error: %@", error);
    }];
    
}

- (void)getVerCode{
    
    
    
}

@end
