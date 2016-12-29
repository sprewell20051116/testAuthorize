//
//  FirebaseDatabaseModel+FBLogin.m
//  testAuthorize
//
//  Created by GIGIGUN on 22/12/2016.
//  Copyright © 2016 GIGIGUN. All rights reserved.
//

#import "FirebaseDatabaseModel+FBLogin.h"

@implementation FirebaseDatabaseModel (FBLogin)

-(void) FBLoginWithPublicProfilefromViewController : (UIViewController* _Nonnull) viewController
                                           Success : (void (^ _Nonnull) (FIRUser * _Nullable user)) success
                                           Failure :(void (^ _Nonnull) (NSError * _Nullable error)) failure

{
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"public_profile"]
                 fromViewController:viewController
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
    {
                                
        if (error) {
            failure(error);
        } else if (result.isCancelled) {
            
        } else {
            FIRAuthCredential *credential = [FIRFacebookAuthProvider credentialWithAccessToken:[FBSDKAccessToken currentAccessToken].tokenString];
            [[FIRAuth auth] signInWithCredential:credential completion:^(FIRUser * _Nullable user, NSError * _Nullable error)
            {
                NSLog(@"FIRUser login %@", user.uid);
                success(user);
            }];

        }
    }];
}
@end
