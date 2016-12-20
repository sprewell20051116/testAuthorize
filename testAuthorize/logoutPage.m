//
//  logoutPage.m
//  testAuthorize
//
//  Created by GIGIGUN on 20/12/2016.
//  Copyright © 2016 GIGIGUN. All rights reserved.
//

#import "logoutPage.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "NSString+Hashes.h"

@interface logoutPage ()
@property (strong, nonatomic) IBOutlet UILabel *userNameLab;
@property (strong, nonatomic) IBOutlet UIButton *logoutBtn;
@property (strong, nonatomic) IBOutlet UITextView *registrationCode;

@end

@implementation logoutPage

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([FBSDKAccessToken currentAccessToken]) { // User is logged in, do work such as go to next view
        _registrationCode.text = [[FBSDKAccessToken currentAccessToken].userID sha1];
    }
    // Do any additional setup after loading the view.
    [_logoutBtn
     addTarget:self
     action:@selector(logoutButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)logoutButtonClicked
{
    
    if ([FBSDKAccessToken currentAccessToken]) { // User is logged in, do work such as go to next view
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];

        [login logOut];
        [_logoutBtn setTitle:@"Log in with Facebook" forState:UIControlStateNormal];

        [self showPageWithStoryboardIDString:@"startPage" withAnimation:YES completion:nil];
    }
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
