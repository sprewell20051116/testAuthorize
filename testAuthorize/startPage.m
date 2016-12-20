//
//  startPage.m
//  testAuthorize
//
//  Created by GIGIGUN on 17/12/2016.
//  Copyright © 2016 GIGIGUN. All rights reserved.
//

#import "startPage.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "FirebaseDatabaseModel.h"
#import "NSString+Hashes.h"

@import Firebase;
@import FirebaseAuth;

@interface startPage ()
@property (strong, nonatomic) IBOutlet UIButton *FBLoginBtn;
@property (strong, nonatomic) IBOutlet UITextField *autherizedCodeTextField;

@end

@implementation startPage

- (void)viewDidLoad {
    [super viewDidLoad];
    //    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    //    // Optional: Place the button in the center of your view.
    //    loginButton.center = self.view.center;
    //    [self.view addSubview:loginButton];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Handle clicks on the button
    
//    if ([FBSDKAccessToken currentAccessToken]) { // User is logged in, do work such as go to next view
//        
//        [_FBLoginBtn setTitle:@"Log out" forState:UIControlStateNormal];
//        [[FirebaseDatabaseModel getInstance] retreiveRegisterDataByQueryIDString:[[FBSDKAccessToken currentAccessToken].userID sha1]
//                                                                         Success:^(FIRDataSnapshot *data) {
//                                                                             NSLog(@"id= %@", [[FBSDKAccessToken currentAccessToken].userID sha1]);
//                                                                         } Failure:^(NSError *error) {
//                                                                             
//                                                                         }];
//        
//    }
//    
    
    [_FBLoginBtn
     addTarget:self
     action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// Once the button is clicked, show the login dialog
-(void)loginButtonClicked
{
    
    
    NSLog(@"TODO: look for authorized code user in Firebase");
    
    if ((_autherizedCodeTextField.text.length != 0) || ([_autherizedCodeTextField.text isEqualToString:@"0000"])) {
        
        [[FirebaseDatabaseModel getInstance] retreiveRegisterDataByQueryIDString:[[FBSDKAccessToken currentAccessToken].userID sha1]
                                                                         Success:^(FIRDataSnapshot *data) {
                                                                             
                                                                             if (data) {
                                                                                 [self loginProcess];
                                                                             }
                                                                             
                                                                         } Failure:^(NSError *error) {
                                                                             
                                                                         }];
        
        
        
    }
    
    
    
    
}

-(void) loginProcess
{
    
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    [login logInWithReadPermissions: @[@"public_profile"] fromViewController:self
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                
                                if (error) {
                                    NSLog(@"Process error");
                                } else if (result.isCancelled) {
                                    NSLog(@"Cancelled");
                                    
                                } else {
                                    NSLog(@"Logged in");
                                    
                                    [_FBLoginBtn setTitle:@"Log out" forState:UIControlStateNormal];
                                    
                                    if ([FBSDKAccessToken currentAccessToken]) {
                                        
                                        FIRAuthCredential *credential = [FIRFacebookAuthProvider credentialWithAccessToken:[FBSDKAccessToken currentAccessToken].tokenString];
                                        [[FIRAuth auth] signInWithCredential:credential completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                                            if(error) {
                                                NSLog(@"login to Firebase error");
                                                return;
                                            } else {
                                                
                                                NSLog(@"Try to add user data to realtime database");
                                                //[_FBLoginBtn setTitle:@"Log out" forState:UIControlStateNormal];
                                                
                                                NSString *userID = [[FBSDKAccessToken currentAccessToken] userID];
                                                
                                                [[FirebaseDatabaseModel getInstance] retreiveRegisterDataByQueryIDString:[[FBSDKAccessToken currentAccessToken].userID sha1]
                                                                                                                 Success:^(FIRDataSnapshot *data) {
                                                                                                                     
                                                if (data) {
                                                    NSLog(@"no need to add registration code");
                                                    [self showPageWithStoryboardIDString:@"baseTabbarViewController" withAnimation:YES completion:nil];
                                                } else {
                                                    NSLog(@"add registration code");

                                                    [[FirebaseDatabaseModel getInstance] addRegisterDataWithRegisterIDString:[userID sha1]
                                                    Success:^{
                                                        NSLog(@"ok userid = %@", [userID sha1]);
                                                        [self showPageWithStoryboardIDString:@"baseTabbarViewController" withAnimation:YES completion:nil];
                                                    } Failure:^(NSError *error) {
                                                        NSLog(@"failed");
                                                    }];
                                                }
                                                                                                                     
                                                } Failure:^(NSError *error) {
                                                }];
                                                
                                                

                                                
                                            }
                                        }];
                                    } else {
                                        NSLog(@"%s, something wrong", __PRETTY_FUNCTION__);
                                    }
                                    
                                }
                            }];
    

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
