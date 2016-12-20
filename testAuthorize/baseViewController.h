//
//  baseViewController.h
//  testAuthorize
//
//  Created by GIGIGUN on 17/12/2016.
//  Copyright © 2016 GIGIGUN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface baseViewController : UIViewController

- (void) showPageWithStoryboardIDString : (NSString *) ViewControllerIDString
                          withAnimation : (BOOL) animation
                             completion : (void (^ __nullable)(void))completion;
@end
