//
//  LoginViewController.m
//  XMPP_For_iPhone
//
//  Created by xu lingyi on 11/18/14.
//  Copyright (c) 2014 xuly. All rights reserved.
//

#import "LoginViewController.h"

#import "AppDelegate.h"
#import "MyXMPP.h"
#import "XMPPUserMemoryStorageObject.h"
#import "XMPPRosterMemoryStorage.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    self.userName = [[UITextField alloc] initWithFrame:CGRectMake(50.0, 50.0, 200.0, 50.0)];
    [self.userName setPlaceholder:@"账号"];
    [self.userName setBorderStyle:UITextBorderStyleLine];
    
    self.passWord = [[UITextField alloc] initWithFrame:CGRectMake(50.0, 120.0, 200.0, 50.0)];
    [self.passWord setPlaceholder:@"密码"];
    [self.passWord setBorderStyle:UITextBorderStyleLine];
    
    [self.view addSubview:self.userName];
    [self.view addSubview:self.passWord];
    
    self.btnLogin = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.btnLogin.frame = CGRectMake(100.0, 200.0, 100.0, 25.0);
    self.btnLogin.backgroundColor = [UIColor whiteColor];
    [self.btnLogin addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.btnLogin setTitle:@"登陆" forState:UIControlStateNormal];
    [self.view addSubview:self.btnLogin];
}

- (void)loginAction {
    if (self.userName.text.length > 0 && self.passWord.text.length > 0) {
        NSUserDefaults *defaultuserinfo=[NSUserDefaults standardUserDefaults];
        [defaultuserinfo setObject:self.userName.text forKey:@"username"];
        [defaultuserinfo setObject:self.passWord.text forKey:@"password"];
        [defaultuserinfo synchronize];
        NSLog(@"login");
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate.myXMPP connect:[self.userName.text stringByAppendingString:Domain] password:self.passWord.text host:Host success:^(void) {
            NSLog(@"成功");
            
            [appDelegate.myXMPP getRosterList:^(XMPPRosterMemoryStorage *rosterList) {
                NSArray *users = [rosterList sortedUsersByName];
                for (XMPPUserMemoryStorageObject *user in users) {
                    NSLog(@"%@", user.displayName);
                }
            }];
        } fail:^(NSError *result) {
            NSLog(@"失败");
            
        }];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入账号和密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
