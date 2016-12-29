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
#import "FirebaseDatabaseModel+FBLogin.h"

@import Firebase;
@import FirebaseAuth;

@interface startPage ()
@property (strong) FirebaseDatabaseModel *firebaseDataObj;
@property (strong, nonatomic) NSString *tempUserID;
@property (strong, nonatomic) IBOutlet UIButton *FBLoginBtn;
@property (strong, nonatomic) IBOutlet UITextField *autherizedCodeTextField;

@end

@implementation startPage

- (void)viewDidLoad {
    [super viewDidLoad];
    _firebaseDataObj = [FirebaseDatabaseModel getInstance];
    
    [_firebaseDataObj loginAsAnomymounSuccess:^(FIRUser *user) {
        NSLog(@"log in as anonymous");
    } Failure:^(NSError *error) {
        NSLog(@"failed to log in as anonymous error = %@", error.localizedDescription);
    }];

    
    [_FBLoginBtn addTarget:self
                    action:@selector(loginButtonClicked)
          forControlEvents:UIControlEventTouchUpInside];
    
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
        
        [_firebaseDataObj retreiveRegisterDataByQueryIDString:_autherizedCodeTextField.text
                                                      Success:^(FIRDataSnapshot *data) {
             
                                                          
            NSLog(@"data = %@", data);
             
            NSLog(@"[Casper] Delete the anonymous user ");
            FIRUser *user = [_firebaseDataObj getcurrentUser];

            if (user.anonymous) {
                
                [_firebaseDataObj deleteCurrentUserSuccess:^{
                    if ((data.hasChildren) || [_autherizedCodeTextField.text isEqualToString:@"0000"]) {
                         [self loginProcess];
                     } else {
                         NSLog(@"Not to log in");
                     }

                 } Failure:^(NSError *error) {
                     NSLog(@"[Casper] delete anonymous error %@", error.localizedDescription);
                 }];
                 
             }
             
         } Failure:^(NSError *error) {
             
         }];
        
        
        
    }
    
    
    
    
}

-(void) loginProcess
{
    
    [_firebaseDataObj FBLoginWithPublicProfilefromViewController:self
        Success:^(FIRUser * _Nullable user) {
         // TODO: Retreive user id from Firebase
         
            [_firebaseDataObj retreiveRegisterDataByQueryIDString:[user.uid sha1]
                Success:^(FIRDataSnapshot *data) {

                if (data.hasChildren) {
                    NSLog(@"no need to add registration code");
                    [self showPageWithStoryboardIDString:@"baseTabbarViewController" withAnimation:YES completion:nil];
                } else {
                    NSLog(@"add registration code");
                    [_firebaseDataObj addRegisterDataWithRegisterIDString:[user.uid sha1]
                        Success:^{
                            NSLog(@"ok userid = %@", [user.uid sha1]);
                            [super showPageWithStoryboardIDString:@"baseTabbarViewController" withAnimation:YES completion:nil];
                        } Failure:^(NSError *error) {
                            NSLog(@"failed");
                        }];
                }

                } Failure:^(NSError *error) {
                    
                }];
            } Failure:^(NSError * _Nullable error) {
             
            }];
    
}

@end
