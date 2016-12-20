//
//  baseViewController.m
//  testAuthorize
//
//  Created by GIGIGUN on 17/12/2016.
//  Copyright © 2016 GIGIGUN. All rights reserved.
//

#import "baseViewController.h"

@interface baseViewController ()

@end

@implementation baseViewController

- (void) viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showPageWithStoryboardIDString : (NSString * _Nonnull) ViewControllerIDString
                          withAnimation : (BOOL) animation
                             completion : (void (^ __nullable)(void))completion
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    UIViewController *destinationPage = (UIViewController*)[mainStoryboard
                                                                 instantiateViewControllerWithIdentifier: ViewControllerIDString];
    [self presentViewController:destinationPage animated:YES completion:completion];
}

- (void) showSimpleAlertWithTitleString : (NSString *) titleString
                          MessageString : (NSString *) messageStr
                              BtnString : (NSString *) btnString
                           andBtnAction : (void (^ __nullable)(UIAlertAction *action)) action
{
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:titleString
                                                                   message:messageStr
                                                            preferredStyle:  UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:btnString
                                style:UIAlertActionStyleDefault
                                handler:action];

    [alert addAction:yesButton];
    
    [self presentViewController:alert animated:true completion:nil];

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
