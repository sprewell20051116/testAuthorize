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
@property (strong, nonatomic) NSString *tempUserID;
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
    
    // use Anonymous accoun
    
    [[FIRAuth auth]
     signInAnonymouslyWithCompletion:^(FIRUser *_Nullable user, NSError *_Nullable error) {
         NSLog(@"log in as anonymous");
         BOOL isAnonymous = user.anonymous;  // YES
         _tempUserID = user.uid;
     }];

    
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
        
        [[FirebaseDatabaseModel getInstance] retreiveRegisterDataByQueryIDString:_autherizedCodeTextField.text
                                                                         Success:^(FIRDataSnapshot *data) {
                                                                             NSLog(@"data = %@", data);
                                                                             
                                                                             NSLog(@"[Casper] Delete the anonymous user ");
                                                                             FIRUser *user = [FIRAuth auth].currentUser;
                                                                             if (user.anonymous) {
                                                                                 [user deleteWithCompletion:^(NSError *_Nullable error) {
                                                                                     if (error) {
                                                                                         // An error happened.
                                                                                     } else {
                                                                                         // Account deleted.
                                                                                         if ((data.hasChildren) || [_autherizedCodeTextField.text isEqualToString:@"0000"]) {
                                                                                             [self loginProcess];
                                                                                         } else {
                                                                                             NSLog(@"Not to log in");
                                                                                         }
                                                                                         
                                                                                     }
                                                                                 }];
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
                                        
                                        // Try to add facebook account to Firebase auth
                                        
                                        FIRAuthCredential *credential = [FIRFacebookAuthProvider credentialWithAccessToken:[FBSDKAccessToken currentAccessToken].tokenString];
                                        
                                        
                                        [[FIRAuth auth] signInWithCredential:credential completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                                            if(error) {
                                                NSLog(@"login to Firebase error");
                                                return;
                                            } else {
                                                
                                                
                                                
                                                [[FIRAuth auth].currentUser linkWithCredential:credential
                                                 completion:^(FIRUser *_Nullable user, NSError *_Nullable error) {
                                                     NSLog(@"Facebook login success and link current user ");
                                                     
                                                     
                                                 }];
                                                
                                                
                                                NSLog(@"Try to add user data to realtime database");
                                                
                                                NSString *userID = [[FBSDKAccessToken currentAccessToken] userID];
                                                
                                                [[FirebaseDatabaseModel getInstance] retreiveRegisterDataByQueryIDString:[[FBSDKAccessToken currentAccessToken].userID sha1]
                                                Success:^(FIRDataSnapshot *data) {
                                                                                                                     
                                                    if (data.hasChildren) {
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
